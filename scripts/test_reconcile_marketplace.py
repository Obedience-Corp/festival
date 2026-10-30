import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import reconcile_marketplace as publisher


class PublicationTests(unittest.TestCase):
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
        with patch.object(publisher, "gh_json", side_effect=[pr, check, {"merged": True}]) as gh, patch.object(publisher, "run", return_value="verified") as run, patch.object(publisher, "validate_candidate") as validate:
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
        with patch.object(publisher, "gh_json", side_effect=[pr, check]) as gh, patch.object(publisher, "run", side_effect=command), patch.object(publisher, "validate_candidate"):
            with self.assertRaises(subprocess.CalledProcessError):
                publisher.wait_and_merge(Path("repo"), Path("metadata"), "base", "release/test", 1, {})
            self.assertEqual(gh.call_count, 2)

    def test_version_order_is_numeric_and_rejects_nonstable(self):
        self.assertGreater(publisher.version_tuple("0.10.0"), publisher.version_tuple("0.9.0"))
        for invalid in ("1.0.0-rc.1", "01.0.0", "../1.0.0", "v1.0.0"):
            with self.assertRaises(ValueError):
                publisher.version_tuple(invalid)


if __name__ == "__main__":
    unittest.main()
