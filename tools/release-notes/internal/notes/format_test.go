package notes

import (
	"strings"
	"testing"
)

func TestRenderIncludesComponentReleaseBodies(t *testing.T) {
	out, err := Render(ReleaseNotesInput{
		FestivalTag: "v0.1.2",
		Festival: ReleaseInfo{
			Repo: "festival",
			Tag:  "v0.1.2",
			URL:  "https://example.com/festival/v0.1.2",
			Body: "## What's Changed\n* Festival packaging fix\n\n**Full Changelog**: https://example.com/festival/compare/v0.1.1...v0.1.2",
		},
		Components: []ReleaseInfo{
			{
				Repo: "fest",
				Tag:  "v0.1.1",
				URL:  "https://example.com/fest/v0.1.1",
				Body: "## What's Changed\n* Fest fix",
			},
			{
				Repo: "camp",
				Tag:  "v0.1.1",
				URL:  "https://example.com/camp/v0.1.1",
				Body: "## What's Changed\n* Camp fix",
			},
			{
				Repo: "festival",
				Tag:  "v0.1.0",
				URL:  "https://example.com/festival-installer/v0.1.0",
				Body: "## What's Changed\n* Hub fix",
			},
		},
	})
	if err != nil {
		t.Fatalf("Render returned error: %v", err)
	}

	for _, want := range []string{
		"## Festival v0.1.2",
		"- `fest` v0.1.1 ([release](https://example.com/fest/v0.1.1))",
		"- `camp` v0.1.1 ([release](https://example.com/camp/v0.1.1))",
		"- `festival` v0.1.0 ([release](https://example.com/festival-installer/v0.1.0))",
		"## Festival Changes",
		"### What's Changed",
		"* Festival packaging fix",
		"## fest v0.1.1",
		"* Fest fix",
		"## camp v0.1.1",
		"* Camp fix",
		"## festival v0.1.0",
		"* Hub fix",
		"## Festival Packaging Notes",
		"This release bundles the `camp` and `fest` CLIs together with `festival`, the installer and launcher for the suite.",
		"brew install --cask Obedience-Corp/tap/festival",
	} {
		if !strings.Contains(out, want) {
			t.Fatalf("rendered notes missing %q:\n%s", want, out)
		}
	}
}

func TestRenderFallsBackWhenComponentBodyMissing(t *testing.T) {
	out, err := Render(ReleaseNotesInput{
		FestivalTag: "v0.1.2",
		Festival: ReleaseInfo{
			Repo: "festival",
			Tag:  "v0.1.2",
			URL:  "https://example.com/festival/v0.1.2",
		},
		Components: []ReleaseInfo{
			{
				Repo: "fest",
				Tag:  "v0.1.1",
				URL:  "https://example.com/fest/v0.1.1",
			},
			{
				Repo: "camp",
				Tag:  "v0.1.1",
				URL:  "https://example.com/camp/v0.1.1",
			},
			{
				Repo: "festival",
				Tag:  "v0.1.0",
				URL:  "https://example.com/festival-installer/v0.1.0",
			},
		},
	})
	if err != nil {
		t.Fatalf("Render returned error: %v", err)
	}

	for _, want := range []string{
		"_No Festival repository changes were reported for this release._",
		"_No published release notes found for fest v0.1.1._",
		"_No published release notes found for camp v0.1.1._",
		"_No published release notes found for festival v0.1.0._",
	} {
		if !strings.Contains(out, want) {
			t.Fatalf("rendered notes missing fallback %q:\n%s", want, out)
		}
	}
}

func TestRenderRejectsMissingComponents(t *testing.T) {
	if _, err := Render(ReleaseNotesInput{FestivalTag: "v0.1.2"}); err == nil {
		t.Fatal("expected error when no components are given")
	}
	if _, err := Render(ReleaseNotesInput{
		FestivalTag: "v0.1.2",
		Components:  []ReleaseInfo{{Repo: "fest", Tag: "", URL: "https://example.com/fest/v0.1.1"}},
	}); err == nil {
		t.Fatal("expected error for an incomplete component release")
	}
}
