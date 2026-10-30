import unittest

from reconcile_suite import newest_published, needs_bundle


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
