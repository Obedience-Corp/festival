#!/usr/bin/env python3
"""Feed published component releases into the existing co-tested suite operator."""

import json
from pathlib import Path
import re
import subprocess
import tempfile

from reconcile_marketplace import run, version_tuple

REPO = "Obedience-Corp/festival"
COMPONENTS = ("fest", "camp", "festival-installer")
STABLE = re.compile(r"v(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\Z")


def newest_published(releases):
    eligible = [r for r in releases if not r["draft"] and not r["prerelease"] and r.get("published_at") and STABLE.fullmatch(r["tag_name"])]
    if not eligible:
        raise ValueError("no published stable release")
    return max(eligible, key=lambda r: version_tuple(r["tag_name"][1:]))


def published(repo):
    releases = []
    page = 1
    while True:
        batch = json.loads(run("gh", "api", f"repos/{repo}/releases?per_page=100&page={page}"))
        releases.extend(batch)
        if len(batch) < 100:
            return newest_published(releases)
        page += 1


def needs_bundle(selected, pinned, released):
    # Comparing the last published bundle also recovers a pin PR that merged
    # before an interrupted operator got as far as tagging the suite.
    return selected != pinned or selected != released


def main():
    with tempfile.TemporaryDirectory(prefix="festival-components-") as directory:
        root = Path(directory) / "festival"
        run("git", "clone", "--recurse-submodules", f"https://github.com/{REPO}.git", str(root))
        run("git", "config", "credential.helper", "!gh auth git-credential", cwd=root)
        run("git", "config", "user.name", "obey-release-bot", cwd=root)
        run("git", "config", "user.email", "release@obediencecorp.com", cwd=root)
        latest_suite = published(REPO)["tag_name"]
        selected, pinned, released, selectors = {}, {}, {}, []
        for component in COMPONENTS:
            release = published(f"Obedience-Corp/{component}")
            tag = release["tag_name"]
            if not release.get("assets"):
                raise RuntimeError(f"{component} {tag} has no published artifacts; retry after its release completes")
            run("git", "fetch", "origin", "--tags", cwd=root / component)
            selected[component] = run("git", "rev-parse", f"{tag}^{{commit}}", cwd=root / component)
            pinned[component] = run("git", "rev-parse", f"HEAD:{component}", cwd=root)
            released[component] = run("git", "rev-parse", f"{latest_suite}:{component}", cwd=root)
            # Do not roll a manually advanced pin back to an older release.
            pin_tag = run("git", "describe", "--tags", "--exact-match", pinned[component], cwd=root / component)
            if not STABLE.fullmatch(pin_tag) or version_tuple(tag[1:]) < version_tuple(pin_tag[1:]):
                raise RuntimeError(f"{component} pin {pin_tag} is ahead of published stable {tag}; wait for publication")
            selectors.extend([f"--{component}-tag", tag])
            print(f"{component}: published {tag} ({selected[component][:12]})", flush=True)
        if not needs_bundle(selected, pinned, released):
            print(f"Published suite {latest_suite} already contains the latest released components", flush=True)
            return
        head_tags = run("git", "tag", "--points-at", "HEAD", cwd=root).splitlines()
        pending = [tag for tag in head_tags if STABLE.fullmatch(tag) and version_tuple(tag[1:]) > version_tuple(latest_suite[1:])]
        if pending:
            raise RuntimeError(f"Suite {max(pending, key=lambda tag: version_tuple(tag[1:]))} is tagged but not published; inspect/retry its release workflow before assembling another bundle")
        # This path retains pin PRs, preflight, component builds, release gates,
        # and the suite's normal version calculation. Clients never mix pins.
        subprocess.run(["go", "-C", "tools/release-operator", "run", ".", "bundle", "--repo-root", "../..", *selectors, "stable"], cwd=root, check=True)


if __name__ == "__main__":
    main()
