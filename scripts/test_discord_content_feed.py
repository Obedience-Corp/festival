#!/usr/bin/env python3
import json
import contextlib
import io
import os
import sys
import tempfile
import unittest
from unittest.mock import patch
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from discord_content_feed import clean_text, content_length, is_stable_release, load_state, main, meaningful_pr, post, save_state, select_weekly_content, spotlight_message


class FeedRulesTest(unittest.TestCase):
    def test_private_repository_is_not_treated_as_public(self):
        from discord_content_feed import GitHub, public_repositories

        class Client(GitHub):
            def get(self, path, query=None):
                return {"private": path.endswith("fest"), "visibility": "private" if path.endswith("fest") else "public"}

        self.assertEqual(public_repositories(Client()), ["Obedience-Corp/festival", "Obedience-Corp/camp"])

    def test_bots_dependencies_and_unconventional_prs_are_excluded(self):
        base = {"title": "refactor: churn", "user": {"login": "human"}, "labels": []}
        self.assertFalse(meaningful_pr(base))
        self.assertFalse(meaningful_pr({**base, "title": "feat: deps", "labels": [{"name": "dependencies"}]}))
        self.assertFalse(meaningful_pr({**base, "title": "feat: bot", "user": {"login": "renovate[bot]"}}))
        self.assertFalse(meaningful_pr({**base, "title": "fix(deps): update library"}))
        self.assertTrue(meaningful_pr({**base, "title": "feat: useful change"}))
        self.assertTrue(meaningful_pr({**base, "title": "docs: improve guide", "labels": [{"name": "community"}]}))

    def test_mentions_are_neutralized(self):
        cleaned = clean_text("feat: @everyone @here <@123> <@&456>")
        self.assertNotIn("@everyone", cleaned)
        self.assertNotIn("@here", cleaned)
        self.assertNotIn("@123", cleaned)
        self.assertNotIn("@&456", cleaned)

    def test_titles_escape_discord_markdown_controls(self):
        cleaned = clean_text("feat: [click](https://evil.example) *surprise*")
        self.assertIn(r"\[click\]", cleaned)
        self.assertNotIn("[click]", cleaned.replace(r"\[click\]", ""))

    def test_release_filter_rejects_draft_and_prerelease(self):
        self.assertTrue(is_stable_release({"tag_name": "v1", "id": 1}))
        self.assertFalse(is_stable_release({"tag_name": "v1-rc1", "id": 2, "prerelease": True}))
        self.assertFalse(is_stable_release({"tag_name": "v1", "id": 3, "draft": True}))

    def test_state_write_is_valid_json(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "state.json"
            save_state(path, {"seen": ["pr:one:1"]})
            self.assertEqual(json.loads(path.read_text()), {"seen": ["pr:one:1"]})

    def test_spotlight_is_selected_once_and_skips_invalid_entries(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "spotlights.json"
            path.write_text(json.dumps([
                {"id": "bad", "title": "bad", "caption": "bad", "source_url": "http://x", "image_url": "https://x"},
                {"id": "internal", "title": "Internal", "caption": "No", "source_url": "https://internal.example", "image_url": "https://internal.example/demo.gif"},
                {"id": "good", "title": "A demo", "caption": "Useful", "source_url": "https://docs.fest.build/methodology/work-items/", "image_url": "https://fest.build/images/demos/tui-workitems.gif"},
            ]))
            state = {}
            self.assertIn("A demo", spotlight_message(path, state))
            self.assertIsNone(spotlight_message(path, state))

    def test_weekly_key_prevents_duplicate_digest(self):
        class Client:
            def get(self, path, query=None):
                if "/releases" in path:
                    return []
                return [{
                    "number": 1,
                    "title": "feat: useful change",
                    "html_url": "https://github.com/Obedience-Corp/festival/pull/1",
                    "merged_at": "2026-09-12T12:00:00Z",
                    "user": {"login": "human"},
                    "labels": [],
                }]

        now = datetime(2026, 9, 13, tzinfo=timezone.utc)
        with tempfile.TemporaryDirectory() as directory:
            manifest = Path(directory) / "empty.json"
            manifest.write_text("[]")
            messages, state = select_weekly_content(Client(), ["Obedience-Corp/festival"], {}, now, 7, manifest)
            self.assertEqual(len(messages), 1)
            self.assertLessEqual(len(messages[0]), 2000)
            repeated, _ = select_weekly_content(Client(), ["Obedience-Corp/festival"], state, now, 7, manifest)
            self.assertEqual(repeated, [])

    def test_busy_week_keeps_spotlight_inside_limit_and_only_marks_selected_items(self):
        class Client:
            def get(self, path, query=None):
                if "/releases" in path:
                    return []
                return [{"number": number, "title": "feat: " + "🎞" * 200,
                         "html_url": f"https://github.com/Obedience-Corp/festival/pull/{number}",
                         "merged_at": "2026-09-12T12:00:00Z", "user": {"login": "human"}, "labels": []}
                        for number in range(1, 7)]

        with tempfile.TemporaryDirectory() as directory:
            manifest = Path(directory) / "spotlights.json"
            manifest.write_text(json.dumps([{"id": "demo", "title": "D" * 180, "caption": "C" * 240,
                "source_url": "https://docs.fest.build/methodology/work-items/",
                "image_url": "https://fest.build/images/fest-show.gif"}]))
            original = {}
            messages, state = select_weekly_content(Client(), ["Obedience-Corp/festival"], original,
                datetime(2026, 9, 13, tzinfo=timezone.utc), 7, manifest)
            self.assertLessEqual(content_length(messages[0]), 1900)
            self.assertIn("Visual spotlight", messages[0])
            self.assertEqual(state["spotlights"], ["demo"])
            self.assertEqual(original, {})
            self.assertLess(len(state["seen"]), 6)
            for number in range(1, 7):
                self.assertEqual(f"pr:Obedience-Corp/festival:{number}" in state["seen"],
                                 f"/pull/{number}" in messages[0])

    def test_releases_only_does_not_fetch_prs_or_consume_spotlights(self):
        class Client:
            def get(self, path, query=None):
                if not path.endswith("/releases"):
                    raise AssertionError("must not fetch pull requests")
                return [{"id": 1, "tag_name": "v1", "published_at": "2026-09-12T12:00:00Z",
                         "html_url": "https://github.com/Obedience-Corp/festival/releases/tag/v1"}]

        messages, state = select_weekly_content(Client(), ["Obedience-Corp/festival"], {},
            datetime(2026, 9, 13, tzinfo=timezone.utc), 7, Path("not-read.json"), releases_only=True)
        self.assertIn("v1", messages[0])
        self.assertNotIn("spotlights", state)

    def test_dry_run_disabled_send_success_and_repeat(self):
        class Client:
            def __init__(self, *args):
                pass
            def get(self, path, query=None):
                if "/releases/tags/" in path:
                    return {"id": 1, "tag_name": "v1", "html_url": "https://github.com/Obedience-Corp/festival/releases/tag/v1"}
                return {"visibility": "public", "private": False}

        with tempfile.TemporaryDirectory() as directory, patch("discord_content_feed.GitHub", Client), \
                patch("discord_content_feed.post") as deliver, contextlib.redirect_stdout(io.StringIO()):
            state = Path(directory) / "state.json"
            args = ["--mode", "release", "--repo", "Obedience-Corp/festival", "--tag", "v1", "--state-file", str(state)]
            with patch.dict(os.environ, {"DISCORD_FEED_ENABLED": "true", "DISCORD_WEBHOOK_URL": "unused"}):
                main(args)
                self.assertFalse(state.exists())
                deliver.assert_not_called()
            with patch.dict(os.environ, {"DISCORD_FEED_ENABLED": "false"}):
                main(args + ["--send"])
                self.assertFalse(state.exists())
                deliver.assert_not_called()
            with patch.dict(os.environ, {"DISCORD_FEED_ENABLED": "true", "DISCORD_WEBHOOK_URL": "unused"}):
                deliver.side_effect = RuntimeError("send failed")
                with self.assertRaises(RuntimeError):
                    main(args + ["--send"])
                self.assertFalse(state.exists())
                deliver.side_effect = None
                main(args + ["--send"])
                saved = state.read_text()
                deliver.reset_mock()
                main(args + ["--send"])
                deliver.assert_not_called()
                self.assertEqual(state.read_text(), saved)

    def test_webhook_requires_confirmation_and_blocks_mentions(self):
        with patch("discord_content_feed.urllib.request.urlopen") as opener:
            opener.return_value.__enter__.return_value.read.return_value = b'{"id":"123"}'
            post("https://discord.com/api/webhooks/1/test?wait=false", "hello @everyone")
            request = opener.call_args.args[0]
            self.assertIn("wait=true", request.full_url)
            self.assertNotIn("wait=false", request.full_url)
            self.assertEqual(json.loads(request.data)["allowed_mentions"], {"parse": []})
            opener.return_value.__enter__.return_value.read.return_value = b'{}'
            with self.assertRaises(RuntimeError):
                post("https://discord.com/api/webhooks/1/test", "hello")
            opener.reset_mock()
            with self.assertRaises(RuntimeError):
                post("https://discord.com/api/webhooks/1/test", "🎞" * 1100)
            opener.assert_not_called()

    def test_corrupt_delivery_state_fails_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            state = Path(directory) / "state.json"
            for value in ("[]", '{"seen":"broken"}', '{"weekly":[1]}', "not json"):
                state.write_text(value)
                with self.assertRaises(RuntimeError):
                    load_state(state)


if __name__ == "__main__":
    unittest.main()
