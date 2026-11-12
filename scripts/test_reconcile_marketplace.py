import contextlib
import hashlib
import io
import json
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import reconcile_marketplace as publisher


class PublicationTests(unittest.TestCase):
    def verification_run(self, **kwargs):
        return dict(id=2, event="pull_request", head_sha="a" * 40,
                    path=".github/workflows/metadata.yml", head_branch="release/test",
                    head_repository={"full_name": publisher.REPO}, pull_requests=[{"number": 1}],
                    status="completed", conclusion="success") | kwargs

    def test_only_matching_pr_workflow_satisfies_protection(self):
        valid = self.verification_run()
        for invalid in (dict(valid, event="workflow_dispatch"), dict(valid, head_sha="b" * 40),
                        dict(valid, head_repository={"full_name": "fork/marketplace"}),
                        dict(valid, pull_requests=[{"number": 2}]), dict(valid, path="other.yml")):
            self.assertIsNone(publisher.pr_verification_run([invalid], "a" * 40, "release/test", 1))
        self.assertEqual(publisher.pr_verification_run([valid], "a" * 40, "release/test", 1), valid)

    def test_only_latest_final_revision_check_can_pass(self):
        success = {"id": 1, "name": "verify", "app": {"id": 15368}, "status": "completed", "conclusion": "success"}
        self.assertEqual(publisher.verify_check_state([]), "pending")
        self.assertEqual(publisher.verify_check_state([success]), "success")
        pending = dict(success, id=2, status="in_progress")
        self.assertEqual(publisher.verify_check_state([success, pending]), "pending")
        self.assertEqual(publisher.verify_check_state([dict(success, app={"id": 1})]), "pending")
        self.assertEqual(publisher.verify_check_state([dict(success, conclusion="failure")]), "failed")

    def test_generated_payload_cannot_expand_to_workflow_changes(self):
        with patch.object(publisher, "run", return_value=".github/workflows/sign.yml"):
            with self.assertRaisesRegex(ValueError, "unexpected files"):
                publisher.generated_payload(Path("unused"), "camp-app")

    def test_real_git_candidate_rejects_foreign_changes_and_changed_payload(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            def git(*args):
                return subprocess.check_output(("git", "-c", "user.name=fixture", "-c", "user.email=fixture@example.invalid", *args), cwd=root, text=True).strip()
            git("init", "-q", "-b", "main")
            (root / "index.json").write_text('{"old":true}')
            git("add", ".")
            git("commit", "-qm", "base")
            base = git("rev-parse", "HEAD")
            (root / "index.json").write_text('{"new":true}')
            expected = publisher.generated_payload(root, "camp-app")
            (root / "index.json.sig").write_text("signature")
            git("add", ".")
            git("commit", "-qm", "generated")
            publisher.validate_candidate(root, base, expected)
            (root / "index.json").write_text("different")
            with self.assertRaisesRegex(ValueError, "prepared payload"):
                publisher.validate_candidate(root, base, expected)
            (root / "index.json").write_text('{"new":true}')
            (root / "unrelated").write_text("foreign")
            git("add", ".")
            git("commit", "-qm", "foreign")
            with self.assertRaisesRegex(ValueError, "non-generated"):
                publisher.validate_candidate(root, base, expected)

    def test_merge_pins_checked_sha_and_reverifies_signatures(self):
        sha = "a" * 40
        pr = {"state": "open", "head": {"ref": "release/test", "sha": sha, "repo": {"full_name": publisher.REPO}}, "base": {"ref": "main"}}
        check = {"check_runs": [{"id": 1, "name": "verify", "app": {"id": 15368}, "status": "completed", "conclusion": "success"}]}
        with patch.object(publisher, "gh_json", side_effect=[pr, check, {"workflow_runs": [self.verification_run()]}, {"merged": True}]) as gh, patch.object(publisher, "run", return_value="verified") as run, patch.object(publisher, "validate_candidate") as validate:
            publisher.wait_and_merge(Path("repo"), Path("metadata"), "base", "release/test", 1, {"index.json": "hash"})
            self.assertIn(f"sha={sha}", gh.call_args.args)
            validate.assert_called_once()
            run.assert_any_call("metadata", "verify", cwd=Path("repo"))

    def test_bad_signature_never_reaches_merge_even_with_green_check(self):
        pr = {"state": "open", "head": {"ref": "release/test", "sha": "a" * 40, "repo": {"full_name": publisher.REPO}}, "base": {"ref": "main"}}
        check = {"check_runs": [{"id": 1, "name": "verify", "app": {"id": 15368}, "status": "completed", "conclusion": "success"}]}
        def command(*args, **kwargs):
            if args[0] == "metadata":
                raise subprocess.CalledProcessError(1, "metadata verify")
            return ""
        with patch.object(publisher, "gh_json", side_effect=[pr, check, {"workflow_runs": [self.verification_run()]}]) as gh, patch.object(publisher, "run", side_effect=command), patch.object(publisher, "validate_candidate"):
            with self.assertRaises(subprocess.CalledProcessError):
                publisher.wait_and_merge(Path("repo"), Path("metadata"), "base", "release/test", 1, {})
            self.assertEqual(gh.call_count, 3)

    def test_held_pr_verification_requires_exact_signed_payload_before_approval(self):
        pr = {"state": "open", "head": {"ref": "release/test", "sha": "a" * 40, "repo": {"full_name": publisher.REPO}}, "base": {"ref": "main"}}
        held = {"workflow_runs": [self.verification_run(conclusion="action_required")]}
        responses = [pr, {"check_runs": []}, held, {"merged": True}]
        with patch.object(publisher, "gh_json", side_effect=responses), patch.object(publisher, "run", return_value="verified") as run, patch.object(publisher, "validate_candidate") as validate, patch.object(publisher.time, "sleep"):
            publisher.wait_and_merge(Path("repo"), Path("metadata"), "base", "release/test", 1, {})
            validate.assert_called_once()
            run.assert_any_call("metadata", "verify", cwd=Path("repo"))
            run.assert_any_call("gh", "api", "--method", "POST", f"repos/{publisher.REPO}/actions/runs/2/approve")
        with patch.object(publisher, "gh_json", side_effect=responses), patch.object(publisher, "run", return_value="") as run, patch.object(publisher, "validate_candidate", side_effect=ValueError("foreign change")):
            with self.assertRaisesRegex(ValueError, "foreign change"):
                publisher.wait_and_merge(Path("repo"), Path("metadata"), "base", "release/test", 1, {})
            self.assertFalse(any(c.args[0] == "gh" for c in run.call_args_list))

    def test_version_order_is_numeric_and_rejects_nonstable(self):
        self.assertGreater(publisher.version_tuple("0.10.0"), publisher.version_tuple("0.9.0"))
        for invalid in ("1.0.0-rc.1", "01.0.0", "../1.0.0", "v1.0.0"):
            with self.assertRaises(ValueError):
                publisher.version_tuple(invalid)

    def test_packages_include_festival_app_and_dispatch_choices_match(self):
        self.assertIn("festival-app", publisher.PACKAGES)
        workflow = Path(__file__).resolve().parents[1] / ".github/workflows/marketplace-reconcile.yml"
        match = re.search(r"options:\s*\[([^\]]*)\]", workflow.read_text())
        self.assertIsNotNone(match)
        options = [item.strip() for item in match.group(1).split(",")]
        self.assertEqual(options, ["all", *publisher.PACKAGES])

    def git_fixture(self, root):
        def git(*args):
            return subprocess.check_output(("git", "-c", "user.name=fixture", "-c", "user.email=fixture@example.invalid", *args),
                                           cwd=root, text=True, stderr=subprocess.DEVNULL).strip()
        return git

    def test_generated_payload_includes_first_publication_manifest(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            git = self.git_fixture(root)
            git("init", "-q", "-b", "main")
            (root / "index.json").write_text('{"v":1}')
            (root / "obey-marketplace.json").write_text('{"v":1}')
            git("add", ".")
            git("commit", "-qm", "base")
            (root / "index.json").write_text('{"v":2}')
            (root / "obey-marketplace.json").write_text('{"v":2}')
            manifest = root / "packages/obedience-corp/festival-app/obey-package.json"
            manifest.parent.mkdir(parents=True)
            manifest.write_text('{"new":true}')
            payload = publisher.generated_payload(root, "festival-app")
            self.assertEqual(set(payload), {"index.json", "obey-marketplace.json",
                                            "packages/obedience-corp/festival-app/obey-package.json"})
            for path, digest in payload.items():
                self.assertEqual(digest, hashlib.sha256((root / path).read_bytes()).hexdigest())

    def test_generated_payload_rejects_untracked_foreign_file(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            git = self.git_fixture(root)
            git("init", "-q", "-b", "main")
            (root / "index.json").write_text('{"v":1}')
            git("add", ".")
            git("commit", "-qm", "base")
            (root / "notes.txt").write_text("stray")
            with self.assertRaisesRegex(ValueError, "unexpected files"):
                publisher.generated_payload(root, "festival-app")

    def test_app_without_stable_release_is_current_and_opens_no_pr(self):
        calls = []
        none_yet = "obedience-corp/festival-app: no published stable app-v release yet; catalog unchanged"

        def fake_run(*args, cwd=None):
            calls.append(args)
            if args[0] == "git" and args[1] == "clone":
                Path(args[-1]).mkdir(parents=True, exist_ok=True)
            if args[0] == "git" and args[1] in ("diff", "ls-files"):
                return ""
            if len(args) > 2 and args[1] == "reconcile":
                self.assertEqual(args[2:], ("festival-app", "latest"))
                return none_yet
            return "a" * 40

        def no_gh(*args):
            raise AssertionError("gh must not be called when nothing changed")

        output = io.StringIO()
        with patch.object(publisher, "run", fake_run), patch.object(publisher, "gh_json", no_gh), \
                contextlib.redirect_stdout(output):
            self.assertIsNone(publisher.reconcile("festival-app", "latest", Path("validator")))
        self.assertIn(none_yet, output.getvalue())
        self.assertIn("festival-app: marketplace is current", output.getvalue())
        self.assertFalse([call for call in calls if call[0] == "gh" or "validate" in call])

    def test_all_mode_runs_every_package_without_failure_when_app_is_current(self):
        calls = []
        with tempfile.NamedTemporaryFile() as validator:
            argv = ["reconcile_marketplace.py", "--package", "all", "--validator", validator.name]
            with patch.object(publisher, "reconcile", lambda package, version, path: calls.append((package, version))), \
                    patch.object(sys, "argv", argv):
                publisher.main()
        self.assertEqual(calls, [("camp-app", "latest"), ("festival", "latest"), ("festival-app", "latest")])

    def test_resume_discards_untracked_manifest_before_detached_checkout(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            git = self.git_fixture(root)
            manifest = root / "packages/obedience-corp/festival-app/obey-package.json"
            git("init", "-q", "-b", "main")
            (root / "index.json").write_text('{"v":1}')
            (root / "obey-marketplace.json").write_text('{"v":1}')
            git("add", ".")
            git("commit", "-qm", "base")
            git("switch", "-q", "-c", "release/catalog-festival-app-v0.2.0-test")
            manifest.parent.mkdir(parents=True)
            manifest.write_text('{"signed":true}')
            (root / "index.json").write_text('{"v":2}')
            git("add", ".")
            git("commit", "-qm", "release")
            branch = git("rev-parse", "HEAD")
            git("switch", "-q", "main")
            (root / "index.json").write_text('{"v":3}')
            manifest.parent.mkdir(parents=True)
            manifest.write_text('{"prepared":true}')
            # Control: a bare reset leaves the untracked manifest, and git refuses the checkout.
            git("reset", "--hard", "HEAD")
            with self.assertRaises(subprocess.CalledProcessError):
                git("checkout", "-q", "--detach", branch)
            publisher.discard_prepared_files(root)
            git("checkout", "-q", "--detach", branch)
            self.assertEqual(git("status", "--porcelain"), "")
            self.assertEqual(manifest.read_text(), '{"signed":true}')


if __name__ == "__main__":
    unittest.main()
