package operator

import (
	"strings"
	"testing"
)

func TestDeriveBundlePlanDevFromFestivalHistory(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:              "dev",
		CurrentBranch:        "develop",
		SelectedTags:         map[string]string{"fest": "v0.2.0-dev.9", "camp": "v0.1.3-dev.2"},
		LatestFestivalStable: "v0.1.1",
		LatestFestivalDev:    "v0.1.2-dev.3",
	})
	if err != nil {
		t.Fatalf("DeriveBundlePlan returned error: %v", err)
	}

	if got, want := plan.ReleaseTag, "v0.1.2-dev.4"; got != want {
		t.Fatalf("ReleaseTag = %q, want %q", got, want)
	}
}

func TestDeriveBundlePlanDevRejectsWrongBranch(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:       "dev",
		CurrentBranch: "main",
		SelectedTags:  map[string]string{"fest": "v0.2.0-dev.9", "camp": "v0.1.3-dev.2"},
	})
	if err == nil {
		t.Fatal("expected error")
	}
}

func TestDeriveBundlePlanRCFromReleaseBranch(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:                 "rc",
		CurrentBranch:           "release/v0.3.0",
		SelectedTags:            map[string]string{"fest": "v0.2.1-rc.2", "camp": "v0.2.0-rc.7"},
		LatestFestivalVersionRC: "v0.3.0-rc.4",
	})
	if err != nil {
		t.Fatalf("DeriveBundlePlan returned error: %v", err)
	}

	if got, want := plan.ReleaseTag, "v0.3.0-rc.5"; got != want {
		t.Fatalf("ReleaseTag = %q, want %q", got, want)
	}
}

func TestDeriveBundlePlanStableBumpsLatestStablePatch(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "main",
		AtReleaseBase:        true,
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		CurrentPinned:        map[string]string{"fest": "v0.1.9", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err != nil {
		t.Fatalf("DeriveBundlePlan returned error: %v", err)
	}

	if got, want := plan.ReleaseTag, "v0.1.2"; got != want {
		t.Fatalf("ReleaseTag = %q, want %q", got, want)
	}
}

func TestDeriveBundlePlanStableRejectsCheckoutOffOriginMain(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "feature/hub",
		CheckoutState:        "feature/hub",
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err == nil {
		t.Fatal("expected error")
	}
	if !strings.Contains(err.Error(), "origin/main") {
		t.Fatalf("error = %q, want the release-base guard", err)
	}
	if !strings.Contains(err.Error(), "feature/hub") {
		t.Fatalf("error = %q, want it to name the checkout it refused", err)
	}
}

// TestDeriveBundlePlanStableAcceptsDetachedCheckoutAtOriginMain is the
// behavior this guard was changed for: a release cut from a worktree that
// cannot hold the main branch, because another worktree already does.
func TestDeriveBundlePlanStableAcceptsDetachedCheckoutAtOriginMain(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "",
		CheckoutState:        "detached at origin/main",
		AtReleaseBase:        true,
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		CurrentPinned:        map[string]string{"fest": "v0.1.9", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err != nil {
		t.Fatalf("DeriveBundlePlan returned error: %v", err)
	}
	if got, want := plan.ReleaseTag, "v0.1.2"; got != want {
		t.Fatalf("ReleaseTag = %q, want %q", got, want)
	}
}

// A branch named main that has fallen off origin/main is refused for the
// same reason any other stale checkout is: the release would not ship the
// commit main actually holds.
func TestDeriveBundlePlanStableRejectsMainBranchOffOriginMain(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "main",
		CheckoutState:        "main",
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err == nil {
		t.Fatal("expected error")
	}
	if !strings.Contains(err.Error(), "origin/main") {
		t.Fatalf("error = %q, want the release-base guard", err)
	}
}

func TestDeriveBundlePlanStableReadOnlyAllowsOffMain(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "feature/hub",
		ReadOnly:             true,
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		CurrentPinned:        map[string]string{"fest": "v0.1.9", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err != nil {
		t.Fatalf("DeriveBundlePlan returned error: %v", err)
	}

	if got, want := plan.ReleaseTag, "v0.1.2"; got != want {
		t.Fatalf("ReleaseTag = %q, want %q", got, want)
	}
}

func TestDeriveBundlePlanStableRejectsWhenMainHasNoStableHistory(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:       "stable",
		CurrentBranch: "main",
		AtReleaseBase: true,
		SelectedTags:  map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
	})
	if err == nil {
		t.Fatal("expected error")
	}
}

func TestDeriveBundlePlanStableRejectsWhenCurrentCommitAlreadyBundlesSelectedTags(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:                         "stable",
		CurrentBranch:                   "main",
		AtReleaseBase:                   true,
		SelectedTags:                    map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		CurrentPinned:                   map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		LatestFestivalStable:            "v0.2.0",
		CurrentCommitTaggedLatestStable: true,
	})
	if err == nil {
		t.Fatal("expected error")
	}
}
