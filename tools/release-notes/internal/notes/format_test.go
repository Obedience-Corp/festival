package notes

import (
	"strings"
	"testing"
)

func TestRenderIncludesComponentReleaseBodies(t *testing.T) {
	out, err := Render(ReleaseNotesInput{
		FestivalTag: "v0.1.2",
		Fest: ReleaseInfo{
			Repo: "fest",
			Tag:  "v0.1.1",
			URL:  "https://example.com/fest/v0.1.1",
			Body: "## What's Changed\n* Fest fix",
		},
		Camp: ReleaseInfo{
			Repo: "camp",
			Tag:  "v0.1.1",
			URL:  "https://example.com/camp/v0.1.1",
			Body: "## What's Changed\n* Camp fix",
		},
	})
	if err != nil {
		t.Fatalf("Render returned error: %v", err)
	}

	for _, want := range []string{
		"## Festival v0.1.2",
		"- `fest` v0.1.1 ([release](https://example.com/fest/v0.1.1))",
		"- `camp` v0.1.1 ([release](https://example.com/camp/v0.1.1))",
		"## fest v0.1.1",
		"* Fest fix",
		"## camp v0.1.1",
		"* Camp fix",
		"## Festival Packaging Notes",
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
		Fest: ReleaseInfo{
			Repo: "fest",
			Tag:  "v0.1.1",
			URL:  "https://example.com/fest/v0.1.1",
		},
		Camp: ReleaseInfo{
			Repo: "camp",
			Tag:  "v0.1.1",
			URL:  "https://example.com/camp/v0.1.1",
		},
	})
	if err != nil {
		t.Fatalf("Render returned error: %v", err)
	}

	for _, want := range []string{
		"_No published release notes found for fest v0.1.1._",
		"_No published release notes found for camp v0.1.1._",
	} {
		if !strings.Contains(out, want) {
			t.Fatalf("rendered notes missing fallback %q:\n%s", want, out)
		}
	}
}
