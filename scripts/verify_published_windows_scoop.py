#!/usr/bin/env python3
"""Verify the published Windows ZIP and Scoop bucket entry for a stable tag."""

import argparse
import hashlib
import io
import json
from pathlib import Path
import re
import sys
import zipfile


EXPECTED_BINARIES = {"camp.exe", "fest.exe", "festival.exe"}
STABLE_TAG = re.compile(r"v[0-9]+\.[0-9]+\.[0-9]+")


def verify(tag: str, archive_name: str, archive_bytes: bytes,
           checksums_text: str, manifest: dict) -> str:
    if not STABLE_TAG.fullmatch(tag):
        raise ValueError(f"expected a stable release tag, got {tag!r}")
    version = tag[1:]
    expected_name = f"festival-{version}-windows-x86_64.zip"
    if archive_name != expected_name:
        raise ValueError(f"published Windows asset must be {expected_name}, got {archive_name}")

    if not isinstance(manifest, dict) or manifest.get("version") != version:
        raise ValueError(f"Scoop bucket version must be {version}")
    architecture = manifest.get("architecture")
    if not isinstance(architecture, dict) or set(architecture) != {"64bit"}:
        raise ValueError("Scoop bucket must advertise only Windows x64")
    target = architecture["64bit"]
    if not isinstance(target, dict):
        raise ValueError("Scoop Windows x64 entry is invalid")
    expected_url = (
        f"https://github.com/Obedience-Corp/festival/releases/download/{tag}/{expected_name}"
    )
    if target.get("url") != expected_url:
        raise ValueError(f"Scoop bucket URL must be {expected_url}")
    bins = target.get("bin")
    if (not isinstance(bins, list) or len(bins) != len(EXPECTED_BINARIES)
            or any(not isinstance(name, str) for name in bins)
            or set(bins) != EXPECTED_BINARIES):
        raise ValueError("Scoop bucket must expose camp.exe, fest.exe, and festival.exe")

    digest = hashlib.sha256(archive_bytes).hexdigest()
    if target.get("hash") != digest:
        raise ValueError("Scoop bucket hash does not match the published Windows ZIP")
    matching = []
    for line in checksums_text.splitlines():
        fields = line.split()
        if len(fields) == 2 and fields[1] == expected_name:
            matching.append(fields[0].lower())
    if matching != [digest]:
        raise ValueError("published checksums.txt does not match the Windows ZIP")

    try:
        with zipfile.ZipFile(io.BytesIO(archive_bytes)) as bundle:
            members = bundle.namelist()
            if len(members) != len({name.casefold() for name in members}):
                raise ValueError("published Windows ZIP has duplicate Windows paths")
            if any(
                name.startswith(("/", "\\"))
                or ":" in name.split("/")[0]
                or ".." in name.replace("\\", "/").split("/")
                for name in members
            ):
                raise ValueError("published Windows ZIP has an unsafe path")
            if not EXPECTED_BINARIES.issubset(members):
                raise ValueError("published Windows ZIP is missing a suite executable")
            damaged = bundle.testzip()
            if damaged:
                raise ValueError(f"published Windows ZIP has a damaged member: {damaged}")
            for name in EXPECTED_BINARIES:
                with bundle.open(name) as executable:
                    if executable.read(2) != b"MZ":
                        raise ValueError(f"published {name} is not a Windows executable")
    except zipfile.BadZipFile as error:
        raise ValueError("published Windows ZIP is invalid") from error

    return f"verified published {tag}: {expected_name}, SHA-256 {digest}, three Scoop commands"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--archive", required=True, type=Path)
    parser.add_argument("--checksums", required=True, type=Path)
    parser.add_argument("--manifest", required=True, type=Path)
    args = parser.parse_args()
    try:
        result = verify(
            args.tag,
            args.archive.name,
            args.archive.read_bytes(),
            args.checksums.read_text(encoding="utf-8"),
            json.loads(args.manifest.read_text(encoding="utf-8")),
        )
    except (OSError, UnicodeError, ValueError, json.JSONDecodeError) as error:
        print(f"Published Windows/Scoop verification failed: {error}", file=sys.stderr)
        return 1
    print(result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
