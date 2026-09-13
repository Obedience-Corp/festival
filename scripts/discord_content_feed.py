#!/usr/bin/env python3
"""Publish a small, allowlisted GitHub activity feed to a Discord webhook."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable

ALLOWLIST = ("Obedience-Corp/festival", "Obedience-Corp/fest", "Obedience-Corp/camp")
API_ROOT = "https://api.github.com"
MEANINGFUL_TITLE = re.compile(r"^(feat|fix)(?:\([^)]*\))?!?:\s+\S", re.IGNORECASE)
BOT_NAMES = {"dependabot[bot]", "renovate[bot]", "github-actions[bot]", "dependabot", "renovate"}
MENTION = re.compile(r"@(everyone|here|&?\d+|[A-Za-z0-9_.-]+)", re.IGNORECASE)


def clean_text(value: str, limit: int = 180) -> str:
    """Make untrusted titles safe and concise for Discord."""
    value = MENTION.sub(lambda match: "@\u200b" + match.group(1), value)
    value = re.sub(r"([\\`*_~|>\[\]()])", r"\\\1", value)
    value = " ".join(value.split()).strip()
    return value if len(value) <= limit else value[: limit - 1].rstrip() + "…"


def parse_time(value: str | None) -> datetime | None:
    if not value:
        return None
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def is_stable_release(release: dict[str, Any]) -> bool:
    tag = str(release.get("tag_name", ""))
    return bool(tag) and not release.get("prerelease") and not release.get("draft")


class GitHub:
    def __init__(self, token: str | None = None, opener: Callable[..., Any] = urllib.request.urlopen):
        self.token = token
        self.opener = opener

    def get(self, path: str, query: dict[str, str] | None = None) -> Any:
        url = API_ROOT + path
        if query:
            url += "?" + urllib.parse.urlencode(query)
        headers = {"Accept": "application/vnd.github+json", "User-Agent": "obc-discord-content-feed"}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        request = urllib.request.Request(url, headers=headers)
        try:
            with self.opener(request, timeout=20) as response:
                return json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as exc:
            if exc.code == 404:
                return None
            raise RuntimeError(f"GitHub API request failed ({exc.code})") from exc
        except (urllib.error.URLError, json.JSONDecodeError) as exc:
            raise RuntimeError("GitHub API request failed") from exc


def public_repositories(client: GitHub) -> list[str]:
    result = []
    for repo in ALLOWLIST:
        metadata = client.get("/repos/" + repo)
        if metadata and metadata.get("visibility") == "public" and not metadata.get("private"):
            result.append(repo)
    return result


def meaningful_pr(pr: dict[str, Any]) -> bool:
    user = (pr.get("user") or {}).get("login", "").lower()
    if user in BOT_NAMES or user.endswith("[bot]"):
        return False
    labels = {str(label.get("name", "")).lower() for label in pr.get("labels", [])}
    if "dependencies" in labels or "dependency" in labels:
        return False
    title = str(pr.get("title", ""))
    if re.match(r"^\w+\((?:deps|deps-dev|dependencies)\)!?:", title, re.IGNORECASE):
        return False
    return bool(MEANINGFUL_TITLE.match(title) or "community" in labels)


def load_state(path: Path) -> dict[str, Any]:
    try:
        state = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(state, dict) or any(
            not isinstance(state.get(key, []), list) or
            any(not isinstance(item, str) for item in state.get(key, []))
            for key in ("seen", "weekly", "spotlights")
        ):
            raise RuntimeError(f"invalid state file: {path}")
        return state
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"invalid state file: {path}") from exc


def save_state(path: Path, state: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    temporary.replace(path)


def release_message(repo: str, release: dict[str, Any]) -> tuple[str, str] | None:
    if not is_stable_release(release):
        return None
    key = f"release:{repo}:{release['id']}"
    name = clean_text(release.get("name") or release.get("tag_name", "release"))
    url = release.get("html_url") or f"https://github.com/{repo}/releases/tag/{release['tag_name']}"
    return key, f"📦 **{repo.split('/', 1)[1]} {name}**\n{url}"


def weekly_candidates(client: GitHub, repositories: list[str], state: dict[str, Any], now: datetime, days: int) -> list[tuple[str, str]]:
    cutoff = now - timedelta(days=days)
    seen = set(state.get("seen", []))
    candidates: list[tuple[str, str]] = []
    for repo in repositories:
        prs = client.get(f"/repos/{repo}/pulls", {"state": "closed", "sort": "updated", "direction": "desc", "per_page": "50"}) or []
        for pr in prs:
            if not pr.get("merged_at") or not meaningful_pr(pr):
                continue
            merged = parse_time(pr["merged_at"])
            if not merged or merged < cutoff:
                continue
            key = f"pr:{repo}:{pr.get('number')}"
            if key in seen:
                continue
            title = clean_text(pr.get("title", "untitled"))
            candidates.append((key, f"• **{repo.split('/', 1)[1]}:** {title} — {pr['html_url']}"))
            seen.add(key)
    return candidates


def spotlight_message(path: Path, state: dict[str, Any]) -> str | None:
    """Select one checked-in, curated visual that has not been sent before."""
    try:
        catalog = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return None
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"invalid spotlight manifest: {path}") from exc
    seen = set(state.get("spotlights", []))
    for item in catalog if isinstance(catalog, list) else []:
        if not isinstance(item, dict) or not all(item.get(field) for field in ("id", "title", "caption", "source_url", "image_url")):
            continue
        if item["id"] in seen or not all(public_spotlight_url(str(item[field])) for field in ("source_url", "image_url")):
            continue
        state["spotlights"] = sorted(seen | {item["id"]})[-100:]
        return f"🎞️ **Visual spotlight: {clean_text(str(item['title']))}**\n{clean_text(str(item['caption']), 240)}\n{item['image_url']}\nSource: {item['source_url']}"
    return None


def public_spotlight_url(value: str) -> bool:
    """Keep the reviewed catalog on the project's public documentation/assets."""
    parsed = urllib.parse.urlsplit(value)
    if parsed.scheme != "https" or parsed.username or parsed.password or parsed.query or parsed.fragment:
        return False
    if parsed.netloc in ("fest.build", "docs.fest.build"):
        return True
    if parsed.netloc == "github.com":
        path = parsed.path.strip("/").split("/")
        return "/".join(path[:2]) in (*ALLOWLIST, "Festival-Examples/example-camp-hardening-festival")
    return False


def content_length(value: str) -> int:
    # Count astral emoji conservatively as two characters.
    return len(value.encode("utf-16-le")) // 2


def recent_release_candidates(client: GitHub, repositories: list[str], state: dict[str, Any], now: datetime, days: int) -> list[tuple[str, str]]:
    cutoff = now - timedelta(days=days)
    seen = set(state.get("seen", []))
    candidates: list[tuple[str, str]] = []
    for repo in repositories:
        releases = client.get(f"/repos/{repo}/releases", {"per_page": "20"}) or []
        for release in releases:
            published = parse_time(release.get("published_at"))
            item = release_message(repo, release)
            if not item or not published or published < cutoff:
                continue
            key, message = item
            if key in seen:
                continue
            candidates.append((key, message))
            seen.add(key)
            break  # one latest stable release per project per weekly digest
    return candidates


def select_weekly_content(client: GitHub, repositories: list[str], state: dict[str, Any], now: datetime, days: int, manifest: Path, releases_only: bool = False) -> tuple[list[str], dict[str, Any]]:
    week_key = now.strftime("%G-W%V")
    if week_key in set(state.get("weekly", [])):
        return [], state
    candidates = recent_release_candidates(client, repositories, state, now, days)
    if not releases_only:
        candidates += weekly_candidates(client, repositories, state, now, days)
    working = dict(state)
    spotlight_state = dict(state)
    spotlight = None if releases_only else spotlight_message(manifest, spotlight_state)
    header = "🧭 **Weekly project feed**\n"
    if spotlight and content_length(header + spotlight) > 1900:
        spotlight = None
    seen = set(working.get("seen", []))
    parts: list[str] = []
    selected_keys: list[str] = []
    for key, message in candidates:
        if len(parts) >= 5:
            break
        draft = header + "\n".join(parts + [message] + ([spotlight] if spotlight else []))
        if content_length(draft) > 1900:
            continue
        parts.append(message)
        selected_keys.append(key)
    seen.update(selected_keys)
    if spotlight:
        parts.append(spotlight)
        working["spotlights"] = spotlight_state["spotlights"]
    content = header + "\n".join(parts)
    if len(parts) < 1:
        return [], state
    working["seen"] = sorted(seen)[-500:]
    working["weekly"] = sorted(set(working.get("weekly", [])) | {week_key})[-52:]
    return [content], working


def post(webhook: str, content: str) -> None:
    if content_length(content) > 2000:
        raise RuntimeError("Discord content exceeds 2000 characters")
    parsed = urllib.parse.urlsplit(webhook)
    if parsed.scheme != "https" or parsed.netloc != "discord.com" or not re.fullmatch(r"/api(?:/v\d+)?/webhooks/\d+/[A-Za-z0-9_.-]+", parsed.path):
        raise RuntimeError("Expected a Discord incoming webhook URL")
    query = urllib.parse.parse_qsl(parsed.query, keep_blank_values=True)
    query = [(key, value) for key, value in query if key != "wait"] + [("wait", "true")]
    webhook = urllib.parse.urlunsplit(parsed._replace(query=urllib.parse.urlencode(query)))
    request = urllib.request.Request(
        webhook,
        data=json.dumps({"content": content, "allowed_mentions": {"parse": []}}).encode("utf-8"),
        headers={"Content-Type": "application/json", "User-Agent": "obc-discord-content-feed"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            body = json.loads(response.read().decode("utf-8"))
            if not body.get("id"):
                raise RuntimeError("Discord webhook returned no message ID")
    except (urllib.error.URLError, urllib.error.HTTPError) as exc:
        raise RuntimeError("Discord webhook request failed") from exc
    except (json.JSONDecodeError, AttributeError) as exc:
        raise RuntimeError("Discord webhook returned an invalid message") from exc


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=("weekly", "release"), required=True)
    parser.add_argument("--repo", help="allowlisted repository for release mode")
    parser.add_argument("--tag", help="release tag for release mode")
    parser.add_argument("--state-file", type=Path, default=Path(".discord-feed-state.json"))
    parser.add_argument("--spotlight-manifest", type=Path, default=Path("docs/discord-spotlights.json"))
    parser.add_argument("--since-days", type=int, default=7)
    parser.add_argument("--releases-only", action="store_true", help="omit merged PRs and visual spotlights from the weekly scan")
    parser.add_argument("--send", action="store_true", help="send only when DISCORD_FEED_ENABLED=true and a webhook is set")
    args = parser.parse_args(argv)
    if args.mode == "release" and (args.repo not in ALLOWLIST or not args.tag):
        parser.error("release mode requires an allowlisted --repo and --tag")

    now = datetime.now(timezone.utc)
    state = load_state(args.state_file)
    working = json.loads(json.dumps(state))
    client = GitHub(os.environ.get("GITHUB_TOKEN"))
    repositories = public_repositories(client)
    messages: list[str] = []
    if args.mode == "release":
        if args.repo not in repositories:
            print("NO_MESSAGES: repository is not public or is not allowlisted")
        else:
            release = client.get(f"/repos/{args.repo}/releases/tags/{urllib.parse.quote(args.tag, safe='')}")
            item = release_message(args.repo, release or {})
            if item:
                key, message = item
                if key not in set(state.get("seen", [])):
                    messages = [message]
                    working["seen"] = sorted(set(working.get("seen", [])) | {key})[-500:]
    else:
        messages, working = select_weekly_content(client, repositories, working, now, args.since_days, args.spotlight_manifest, args.releases_only)
    if not messages:
        print("NO_MESSAGES")
        return 0
    content = "\n\n".join(messages)
    delivered = False
    if args.send:
        if os.environ.get("DISCORD_FEED_ENABLED", "false").lower() != "true":
            print("DRY_RUN (DISCORD_FEED_ENABLED is not true):\n" + content)
        elif not os.environ.get("DISCORD_WEBHOOK_URL"):
            raise RuntimeError("DISCORD_FEED_ENABLED=true but DISCORD_WEBHOOK_URL is unset")
        else:
            post(os.environ["DISCORD_WEBHOOK_URL"], content)
            print(f"SENT {len(messages)} message(s)")
            delivered = True
    else:
        print("DRY_RUN:\n" + content)
    if delivered:
        save_state(args.state_file, working)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except RuntimeError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
