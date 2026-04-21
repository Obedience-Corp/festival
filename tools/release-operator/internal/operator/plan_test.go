package operator

import "testing"

func TestDeriveBundlePlanDevFromFestivalHistory(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:              "dev",
		CurrentBranch:        "develop",
		FestTag:              "v0.2.0-dev.9",
		CampTag:              "v0.1.3-dev.2",
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
		FestTag:       "v0.2.0-dev.9",
		CampTag:       "v0.1.3-dev.2",
	})
	if err == nil {
		t.Fatal("expected error")
	}
}

func TestDeriveBundlePlanRCFromReleaseBranch(t *testing.T) {
	plan, err := DeriveBundlePlan(BundleInput{
		Channel:                 "rc",
		CurrentBranch:           "release/v0.3.0",
		FestTag:                 "v0.2.1-rc.2",
		CampTag:                 "v0.2.0-rc.7",
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
		FestTag:              "v0.2.0",
		CampTag:              "v0.2.1",
		CurrentPinnedFestTag: "v0.1.9",
		CurrentPinnedCampTag: "v0.2.1",
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
		FestTag:       "v0.2.0",
		CampTag:       "v0.2.1",
	})
	if err == nil {
		t.Fatal("expected error")
	}
}

func TestDeriveBundlePlanStableRejectsWhenCurrentCommitAlreadyBundlesSelectedTags(t *testing.T) {
	_, err := DeriveBundlePlan(BundleInput{
		Channel:                         "stable",
		CurrentBranch:                   "main",
		FestTag:                         "v0.2.0",
		CampTag:                         "v0.2.1",
		CurrentPinnedFestTag:            "v0.2.0",
		CurrentPinnedCampTag:            "v0.2.1",
		LatestFestivalStable:            "v0.2.0",
		CurrentCommitTaggedLatestStable: true,
	})
	if err == nil {
		t.Fatal("expected error")
	}
}
