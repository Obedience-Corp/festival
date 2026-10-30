import unittest
import os
from unittest.mock import patch

from reconcile_suite import newest_published, needs_bundle, main


class SuiteReconciliationTests(unittest.TestCase):
    def test_only_published_stable_component_tags(self):
        def release(tag, **kwargs):
            return dict(tag_name=tag, draft=False, prerelease=False, published_at="2026-10-30T00:00:00Z", **kwargs)
        stable = release("v0.10.0")
        candidates = [release("v0.9.0"), stable, release("dev"), release("v0.11.0-rc.1"), release("obey-v99.0.0")]
        draft = release("v1.0.0")
        draft["draft"] = True
        candidates.append(draft)
        self.assertEqual(newest_published(candidates), stable)

    def test_duplicate_and_interrupted_handoff(self):
        old = dict(camp="a", fest="b", installer="c")
        new = dict(camp="d", fest="b", installer="c")
        self.assertFalse(needs_bundle(old, old, old))
        self.assertTrue(needs_bundle(new, old, old))
        self.assertTrue(needs_bundle(new, new, old))
        self.assertFalse(needs_bundle(new, new, new))

    def test_published_source_only_components_are_eligible(self):
        release = dict(tag_name="v0.10.1", draft=False, prerelease=False, published_at="2026-10-27T04:28:15Z", assets=[])
        self.assertEqual(newest_published([release]), release)
        def git(*args, **kwargs):
            if "describe" in args:
                return "v0.10.1"
            if "rev-parse" in args:
                return "a" * 40
            return ""
        with patch.dict(os.environ), patch("reconcile_suite.published", return_value=release), patch("reconcile_suite.run", side_effect=git), patch("reconcile_suite.subprocess.run") as bundle:
            main()
            bundle.assert_not_called()
