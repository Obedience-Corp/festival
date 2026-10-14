#!/usr/bin/env python3
"""Verify the Windows suite archive before publishing a release."""

import hashlib
import re
import sys
import zipfile
from pathlib import Path


REQUIRED = {
    "camp.exe",
    "fest.exe",
    "festival.exe",
    "README.md",
    "LICENSE",
    "NOTICE",
    "install.sh",
    "completions/manifest.txt",
    "shell/festival.bash",
    "shell/festival.zsh",
    "shell/festival.fish",
}
EXECUTABLES = {"camp.exe", "fest.exe", "festival.exe"}


def verify(dist: Path) -> None:
    archives = list(dist.glob("festival-*-windows-x86_64.zip"))
    if len(archives) != 1:
        raise ValueError(f"expected one Windows x86_64 archive in {dist}, found {len(archives)}")
    archive = archives[0]

    checksums = dist / "checksums.txt"
    if not checksums.is_file():
        raise ValueError(f"missing {checksums}")
    matching = []
    for line in checksums.read_text(encoding="utf-8").splitlines():
        fields = line.split(maxsplit=1)
        if len(fields) == 2 and fields[1].lstrip("*") == archive.name:
            matching.append(fields[0])
    if len(matching) != 1 or not re.fullmatch(r"[0-9a-fA-F]{64}", matching[0]):
        raise ValueError(f"expected one SHA-256 entry for {archive.name} in {checksums}")

    digest = hashlib.sha256()
    with archive.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    if digest.hexdigest().lower() != matching[0].lower():
        raise ValueError(f"SHA-256 mismatch for {archive.name}")

    with zipfile.ZipFile(archive) as bundle:
        names = bundle.namelist()
        normalized = [name.casefold() for name in names]
        if len(normalized) != len(set(normalized)):
            raise ValueError("archive contains duplicate Windows paths")
        if any(
            name.startswith(("/", "\\"))
            or ":" in name.split("/")[0]
            or ".." in name.replace("\\", "/").split("/")
            for name in names
        ):
            raise ValueError("archive contains an unsafe path")
        missing = REQUIRED.difference(names)
        if missing:
            raise ValueError(f"archive is missing: {', '.join(sorted(missing))}")
        damaged = bundle.testzip()
        if damaged:
            raise ValueError(f"archive member failed CRC: {damaged}")
        for executable in sorted(EXECUTABLES):
            with bundle.open(executable) as member:
                if member.read(2) != b"MZ":
                    raise ValueError(f"{executable} is not a Windows executable")

    print(f"verified {archive.name}: SHA-256, {len(names)} members, three Windows executables")


if __name__ == "__main__":
    try:
        verify(Path(sys.argv[1]) if len(sys.argv) == 2 else Path("dist"))
    except (OSError, ValueError, zipfile.BadZipFile) as error:
        print(f"Windows archive verification failed: {error}", file=sys.stderr)
        sys.exit(1)
