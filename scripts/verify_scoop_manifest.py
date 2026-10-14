#!/usr/bin/env python3
"""Verify that GoReleaser's Scoop manifest installs the checked Windows suite ZIP."""

import argparse
import hashlib
import json
from pathlib import Path
import sys
from urllib.parse import urlparse
import zipfile


EXPECTED_BINARIES = {"camp.exe", "fest.exe", "festival.exe"}
EXPECTED_REPOSITORY = "github.com"
EXPECTED_RELEASE_PATH = ("Obedience-Corp", "festival", "releases", "download")


def verify(dist: Path, manifest_path: Path) -> str:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if set(manifest["architecture"]) != {"64bit"}:
        raise ValueError("Scoop must advertise only the supported Windows x64 archive")

    target = manifest["architecture"]["64bit"]
    bins = target["bin"]
    if not isinstance(bins, list) or set(bins) != EXPECTED_BINARIES or len(bins) != 3:
        raise ValueError(f"Scoop bin entries must be exactly {sorted(EXPECTED_BINARIES)}")

    version = manifest["version"]
    expected_name = f"festival-{version}-windows-x86_64.zip"
    url = urlparse(target["url"])
    parts = tuple(url.path.strip("/").split("/"))
    if (
        url.scheme != "https"
        or url.netloc != EXPECTED_REPOSITORY
        or len(parts) != 6
        or parts[:4] != EXPECTED_RELEASE_PATH
        or not parts[4].startswith("v")
        or parts[5] != expected_name
        or url.query
        or url.fragment
    ):
        raise ValueError(f"Scoop URL does not identify the Festival release ZIP: {target['url']}")
    if not version.endswith("-next") and parts[4] != f"v{version}":
        raise ValueError(f"Scoop URL tag {parts[4]} does not match manifest version {version}")

    archive = dist / expected_name
    if not archive.is_file():
        raise ValueError(f"Scoop archive is missing: {archive}")
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    if target["hash"] != digest:
        raise ValueError(f"Scoop hash does not match {archive.name}")

    checksums = (dist / "checksums.txt").read_text(encoding="utf-8")
    checksum_entries = [line.split() for line in checksums.splitlines() if line.strip()]
    matching = [fields[0] for fields in checksum_entries if len(fields) == 2 and fields[1] == archive.name]
    if matching != [digest]:
        raise ValueError(f"checksums.txt does not match the Scoop archive {archive.name}")

    with zipfile.ZipFile(archive) as bundle:
        members = set(bundle.namelist())
    if not EXPECTED_BINARIES.issubset(members):
        raise ValueError("Scoop archive is missing a suite executable")

    return f"verified Scoop {version}: {archive.name}, SHA-256 {digest}, three command shims"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dist", type=Path, help="GoReleaser dist directory")
    parser.add_argument("--manifest", type=Path, help="manifest override for isolated negative tests")
    args = parser.parse_args()
    try:
        print(verify(args.dist, args.manifest or args.dist / "scoop" / "festival.json"))
    except (OSError, KeyError, TypeError, ValueError, json.JSONDecodeError, zipfile.BadZipFile) as error:
        print(f"Scoop manifest verification failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
