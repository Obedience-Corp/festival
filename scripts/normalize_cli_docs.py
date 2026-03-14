#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
from pathlib import Path


HEADING_RE = re.compile(r"^\s{0,3}#{1,6}\s+(.*)$")
RELATIVE_MD_LINK_RE = re.compile(
    r"\]\((?![a-z][a-z0-9+.-]*:|/|#)([^)\s?#]+)\.md([?#][^)]*)?\)"
)


def yaml_quote(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def parse_front_matter(text: str) -> tuple[list[str], str]:
    if not text.startswith("---\n"):
        return [], text

    lines = text.splitlines()
    for index in range(1, len(lines)):
        if lines[index] == "---":
            return lines[1:index], "\n".join(lines[index + 1 :]).lstrip("\n")

    return [], text


def strip_markdown_formatting(text: str) -> str:
    text = re.sub(r"`([^`]+)`", r"\1", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"\1", text)
    text = re.sub(r"\*([^*]+)\*", r"\1", text)
    return " ".join(text.split()).strip()


def extract_title_and_description(body: str) -> tuple[str | None, str | None]:
    title = None
    description_lines: list[str] = []
    in_code_block = False
    title_seen = False

    for raw_line in body.splitlines():
        line = raw_line.strip()

        if line.startswith("```"):
            in_code_block = not in_code_block
            continue

        if in_code_block:
            continue

        heading_match = HEADING_RE.match(line)
        if heading_match and not title_seen:
            title = strip_markdown_formatting(heading_match.group(1))
            title_seen = True
            continue

        if not title_seen:
            continue

        if not line:
            if description_lines:
                break
            continue

        if line == "---":
            continue

        if HEADING_RE.match(line):
            continue

        description_lines.append(strip_markdown_formatting(line))

    description = " ".join(description_lines).strip() or None
    return title, description


def rewrite_relative_markdown_links(body: str) -> str:
    return RELATIVE_MD_LINK_RE.sub(
        lambda match: f"](../{match.group(1)}/{match.group(2) or ''})",
        body,
    )


def rebuild_front_matter(existing_lines: list[str], title: str, description: str | None) -> str:
    filtered_lines = []

    for line in existing_lines:
        if re.match(r"^(title|linkTitle|description)\s*:", line):
            continue
        filtered_lines.append(line)

    front_matter = [
        "---",
        f"title: {yaml_quote(title)}",
        f"linkTitle: {yaml_quote(title)}",
    ]

    if description:
        front_matter.append(f"description: {yaml_quote(description)}")

    front_matter.extend(filtered_lines)
    front_matter.append("---")
    return "\n".join(front_matter)


def normalize_file(path: Path) -> None:
    original = path.read_text()
    existing_front_matter, body = parse_front_matter(original)
    title, description = extract_title_and_description(body)

    if not title:
        return

    normalized_body = rewrite_relative_markdown_links(body).rstrip() + "\n"
    normalized_front_matter = rebuild_front_matter(existing_front_matter, title, description)
    path.write_text(f"{normalized_front_matter}\n\n{normalized_body}")


def iter_markdown_files(root: Path) -> list[Path]:
    return sorted(
        path
        for path in root.rglob("*.md")
        if path.name != "_index.md"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("roots", nargs="+")
    args = parser.parse_args()

    for root_arg in args.roots:
        root = Path(root_arg)
        for path in iter_markdown_files(root):
            normalize_file(path)


if __name__ == "__main__":
    main()
