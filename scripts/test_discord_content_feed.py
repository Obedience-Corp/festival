#!/usr/bin/env python3
import json
import tempfile
import unittest
from datetime import datetime, timezone
from pathlib import Path

from discord_content_feed import clean_text, is_stable_release, meaningful_pr, save_state, select_weekly_content, spotlight_message


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
                {"id": "good", "title": "A demo", "caption": "Useful", "source_url": "https://source", "image_url": "https://image"},
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


if __name__ == "__main__":
    unittest.main()
