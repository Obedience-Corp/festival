#!/usr/bin/env python3
"""Promote verified registered releases through signed, checked marketplace PRs."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import time

REPO = "Obedience-Corp/marketplace"
PACKAGES = ("camp-app", "festival")
VERSION = re.compile(r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\Z")


def run(*args, cwd=None):
    if args[0] == "git":
        args = ("git", "-c", "credential.helper=", "-c", "credential.https://github.com.helper=!gh auth git-credential", *args[1:])
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def gh_json(*args):
    return json.loads(run("gh", *args))


def version_tuple(value):
    if not VERSION.fullmatch(value):
        raise ValueError(f"invalid stable version {value!r}")
    return tuple(map(int, value.split(".")))


def catalog_version(root, package):
    doc = json.loads((root / f"packages/obedience-corp/{package}/obey-package.json").read_text())
    if doc["id"] != f"obedience-corp/{package}":
        raise ValueError("catalog identity mismatch")
    return max((r["version"] for r in doc["releases"] if r["channel"] == "stable"), key=version_tuple)


def generated_payload(root, package):
    allowed = {f"packages/obedience-corp/{package}/obey-package.json", "index.json", "obey-marketplace.json"}
    changed = set(run("git", "diff", "--name-only", cwd=root).splitlines())
    if not changed <= allowed:
        raise ValueError(f"preparation changed unexpected files: {sorted(changed - allowed)}")
    return {path: hashlib.sha256((root / path).read_bytes()).hexdigest() for path in changed}


def validate_candidate(root, base, expected):
    changed = set(run("git", "diff", "--name-only", f"{base}...HEAD", cwd=root).splitlines())
    allowed = set(expected) | {path + ".sig" for path in expected}
    if not changed <= allowed:
        raise ValueError(f"release PR contains non-generated changes: {sorted(changed - allowed)}")
    for path, digest in expected.items():
        if hashlib.sha256((root / path).read_bytes()).hexdigest() != digest:
            raise ValueError(f"release PR changed the prepared payload: {path}")


def verify_check_state(checks):
    # The branch protection also enforces the required check's GitHub App ID.
    # Never treat an empty/missing run or a check on a previous SHA as success.
    relevant = [c for c in checks if c.get("name") == "verify" and c.get("app", {}).get("id") == 15368]
    if not relevant:
        return "pending"
    latest = max(relevant, key=lambda c: c["id"])
    if latest.get("status") != "completed":
        return "pending"
    return "success" if latest.get("conclusion") == "success" else "failed"


def wait_and_merge(root, metadata, base, branch, number, expected, timeout=900):
    deadline = time.monotonic() + timeout
    last = None
    while time.monotonic() < deadline:
        pr = gh_json("api", f"repos/{REPO}/pulls/{number}")
        if pr.get("merged"):
            return
        if pr["state"] != "open" or pr["head"]["ref"] != branch or pr["head"]["repo"]["full_name"] != REPO or pr["base"]["ref"] != "main":
            raise RuntimeError("release PR identity/state changed")
        sha = pr["head"]["sha"]
        checks = gh_json("api", f"repos/{REPO}/commits/{sha}/check-runs?per_page=100")["check_runs"]
        state = verify_check_state(checks)
        if (sha, state) != last:
            print(f"{branch}: {sha[:12]} verification {state}", flush=True)
            last = (sha, state)
        if state == "success":
            run("git", "fetch", "origin", sha, cwd=root)
            run("git", "checkout", "--detach", sha, cwd=root)
            validate_candidate(root, base, expected)
            print(run(str(metadata), "verify", cwd=root), flush=True)
            # SHA is mandatory: a later signature/payload push must invalidate
            # this merge attempt. GitHub enforces protection; no admin bypass.
            result = gh_json("api", "--method", "PUT", f"repos/{REPO}/pulls/{number}/merge", "-f", f"sha={sha}", "-f", "merge_method=squash")
            if not result.get("merged"):
                raise RuntimeError(f"protected merge failed: {result.get('message')}")
            return
        if state == "failed":
            # The initial unsigned revision fails verification before signing.
            # A signed revision with a failed check is a real failure.
            run("git", "fetch", "origin", sha, cwd=root)
            run("git", "checkout", "--detach", sha, cwd=root)
            try:
                run(str(metadata), "verify", cwd=root)
            except subprocess.CalledProcessError:
                pass
            else:
                raise RuntimeError("signed release revision failed required verification")
        time.sleep(5)
    raise TimeoutError(f"signed promotion still pending: https://github.com/{REPO}/pull/{number}; rerun reconciliation")


def reconcile(package, version, validator):
    with tempfile.TemporaryDirectory(prefix="festival-marketplace-") as directory:
        work = Path(directory)
        root, metadata = work / "marketplace", work / "metadata"
        # gh's configured credential helper supplies the existing publish token;
        # credentials never appear in the remote URL or subprocess arguments.
        run("git", "clone", "--quiet", f"https://github.com/{REPO}.git", str(root))
        run("go", "build", "-o", str(metadata), "./tools/metadata", cwd=root)
        print(run(str(metadata), "verify", cwd=root), flush=True)
        base = run("git", "rev-parse", "HEAD", cwd=root)
        print(run(str(metadata), "reconcile", package, version, cwd=root), flush=True)
        expected = generated_payload(root, package)
        if not expected:
            print(f"{package}: marketplace is current", flush=True)
            return
        manifest = root / f"packages/obedience-corp/{package}/obey-package.json"
        print(run(str(validator), "validate", "--kind", "manifest", str(manifest)), flush=True)
        selected = catalog_version(root, package)
        # Include the base revision so a concurrently changed catalog can be
        # regenerated safely without force-pushing or overwriting a prior PR.
        branch = f"release/catalog-{package}-v{selected}-{base[:12]}"
        existing = gh_json("api", f"repos/{REPO}/pulls?state=all&head=Obedience-Corp:{branch}&base=main")
        if existing:
            pr = existing[0]
            if pr["state"] != "open" and not pr.get("merged_at"):
                raise RuntimeError(f"generated release PR was closed: {pr['html_url']}")
            number = pr["number"]
        else:
            remote = run("git", "ls-remote", "--heads", "origin", f"refs/heads/{branch}", cwd=root)
            if not remote:
                run("git", "switch", "-c", branch, cwd=root)
                run("git", "add", "--", *expected, cwd=root)
                run("git", "-c", "user.name=obey-release-bot", "-c", "user.email=release@obediencecorp.com", "commit", "-m", f"Publish {package} {selected} in the marketplace", cwd=root)
                run("git", "push", "origin", f"HEAD:refs/heads/{branch}", cwd=root)
            body = work / "pr.md"
            body.write_text(f"Publish verified public {package} {selected} through the existing signed marketplace.\n\nGenerated from marketplace {base}. Reconciliation merges only this prepared payload after the final signed revision passes the required verify check.\n")
            url = run("gh", "pr", "create", "--repo", REPO, "--base", "main", "--head", branch, "--title", f"Publish {package} {selected} automatically", "--body-file", str(body))
            number = int(url.rsplit("/", 1)[1])
        # Drop only this disposable clone's generated files before inspecting the
        # existing signed branch. The prepared content is pinned by its hashes.
        run("git", "reset", "--hard", "HEAD", cwd=root)
        wait_and_merge(root, metadata, base, branch, number, expected)
        run("git", "fetch", "origin", "main", cwd=root)
        run("git", "checkout", "--detach", "origin/main", cwd=root)
        print(run(str(metadata), "verify", cwd=root), flush=True)
        actual = catalog_version(root, package)
        if version_tuple(actual) < version_tuple(selected):
            raise RuntimeError("public marketplace readback is older than promoted version")
        revision = run("git", "rev-parse", "HEAD", cwd=root)
        summary = f"{package} {selected} is available in signed marketplace {revision}; PR https://github.com/{REPO}/pull/{number}"
        print(summary, flush=True)
        if os.getenv("GITHUB_STEP_SUMMARY"):
            with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as output:
                output.write(summary + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package", choices=(*PACKAGES, "all"), default="all")
    parser.add_argument("--version", default="latest")
    parser.add_argument("--validator", type=Path, required=True)
    args = parser.parse_args()
    if args.version != "latest":
        version_tuple(args.version)
        if args.package == "all":
            parser.error("an exact version requires one package")
    validator = args.validator.resolve(strict=True)
    failures = []
    for package in PACKAGES if args.package == "all" else (args.package,):
        try:
            reconcile(package, args.version, validator)
        except (ValueError, RuntimeError, OSError, subprocess.CalledProcessError) as error:
            print(f"{package}: publication failed: {error}", flush=True)
            failures.append(package)
    if failures:
        raise SystemExit("reconciliation failed for " + ", ".join(failures))


if __name__ == "__main__":
    main()
