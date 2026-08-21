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

func TestDeriveBundlePlanStableRejectsWrongBranch(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:              "stable",
		CurrentBranch:        "feature/hub",
		SelectedTags:         map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		LatestFestivalStable: "v0.1.1",
	})
	if err == nil {
		t.Fatal("expected error")
	}
	if !strings.Contains(err.Error(), "main branch") {
		t.Fatalf("error = %q, want main-branch guard", err)
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
		SelectedTags:                    map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		CurrentPinned:                   map[string]string{"fest": "v0.2.0", "camp": "v0.2.1"},
		LatestFestivalStable:            "v0.2.0",
		CurrentCommitTaggedLatestStable: true,
	})
	if err == nil {
		t.Fatal("expected error")
	}
}
