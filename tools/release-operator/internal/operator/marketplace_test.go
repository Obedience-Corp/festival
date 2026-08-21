package operator

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestBuildMarketplaceEntry_Golden(t *testing.T) {
	in := MarketplaceEntryInput{
		FestivalVersion: "0.2.10",
		Channel:         "stable",
		PublishedAt:     "2026-06-23T00:50:22Z",
		Components: []ComponentVersion{
			{Name: "camp", Version: "0.2.11"},
			{Name: "fest", Version: "0.4.5"},
			{Name: "festival", Version: "0.1.0"},
		},
		Artifacts: []ArtifactInput{
			{OS: "linux", Arch: "arm64", Filename: "festival-0.2.10-linux-arm64.tar.gz",
				URL:    "https://github.com/Obedience-Corp/festival/releases/download/v0.2.10/festival-0.2.10-linux-arm64.tar.gz",
				SHA256: "2f92ec66886efd8a4eca34db169c49dff9408ab7c565dec7f8557e4ddd61302b"},
			{OS: "darwin", Arch: "all", Filename: "festival-0.2.10-macOS-all.tar.gz",
				URL:    "https://github.com/Obedience-Corp/festival/releases/download/v0.2.10/festival-0.2.10-macOS-all.tar.gz",
				SHA256: "4eab84d04cb088a8abf98bd740c0b20b685be5e8e6863c4752edc0d939f915a3"},
			{OS: "linux", Arch: "amd64", Filename: "festival-0.2.10-linux-x86_64.tar.gz",
				URL:    "https://github.com/Obedience-Corp/festival/releases/download/v0.2.10/festival-0.2.10-linux-x86_64.tar.gz",
				SHA256: "faab388d34c7d1224c3a7d940256b45b1e52af9f89f8e72a1b50ef377a42d0aa"},
		},
	}

	got, err := BuildMarketplaceEntry(in)
	if err != nil {
		t.Fatalf("BuildMarketplaceEntry: %v", err)
	}

	goldenPath := filepath.Join("testdata", "festival-v0.2.10.golden.json")
	if os.Getenv("UPDATE_GOLDEN") == "1" {
		if err := os.MkdirAll(filepath.Dir(goldenPath), 0o755); err != nil {
			t.Fatalf("mkdir golden dir: %v", err)
		}
		if err := os.WriteFile(goldenPath, got, 0o644); err != nil {
			t.Fatalf("update golden: %v", err)
		}
	}
	want, err := os.ReadFile(goldenPath)
	if err != nil {
		t.Fatalf("read golden: %v", err)
	}
	if string(got) != string(want) {
		t.Fatalf("manifest mismatch\n--- got ---\n%s\n--- want ---\n%s", got, want)
	}
}

func TestBuildMarketplaceEntry_DeterministicAcrossRuns(t *testing.T) {
	in := MarketplaceEntryInput{
		FestivalVersion: "0.2.10", Channel: "stable", PublishedAt: "2026-06-23T00:50:22Z",
		Components: []ComponentVersion{
			{Name: "camp", Version: "0.2.11"},
			{Name: "fest", Version: "0.4.5"},
			{Name: "festival", Version: "0.1.0"},
		},
		Artifacts: []ArtifactInput{{OS: "darwin", Arch: "all", Filename: "x", URL: "u", SHA256: "s"}},
	}
	a, err := BuildMarketplaceEntry(in)
	if err != nil {
		t.Fatalf("first build: %v", err)
	}
	b, err := BuildMarketplaceEntry(in)
	if err != nil {
		t.Fatalf("second build: %v", err)
	}
	if string(a) != string(b) {
		t.Fatal("non-deterministic output")
	}
}

// TestBuildMarketplaceEntry_RejectsBadPublishedAt covers the known defect
// found 2026-08-21: the official v0.2.17 manifest published with
// published_at="", which failed the hub's schema (format: date-time) only on
// a user's machine. These cases assert the release fails instead, in CI.
func TestBuildMarketplaceEntry_RejectsBadPublishedAt(t *testing.T) {
	base := MarketplaceEntryInput{
		FestivalVersion: "0.2.10",
		Channel:         "stable",
		Components: []ComponentVersion{
			{Name: "camp", Version: "0.2.11"},
			{Name: "fest", Version: "0.4.5"},
			{Name: "festival", Version: "0.1.0"},
		},
		Artifacts: []ArtifactInput{{OS: "darwin", Arch: "all", Filename: "x", URL: "u", SHA256: "s"}},
	}

	cases := []struct {
		name        string
		publishedAt string
		wantErrHas  string
	}{
		{name: "empty string, the exact v0.2.17 defect", publishedAt: "", wantErrHas: "published_at"},
		{name: "date only, no time component", publishedAt: "2026-08-20", wantErrHas: "RFC 3339"},
		{name: "not a date at all", publishedAt: "not-a-timestamp", wantErrHas: "RFC 3339"},
	}
	for _, tt := range cases {
		t.Run(tt.name, func(t *testing.T) {
			in := base
			in.PublishedAt = tt.publishedAt
			_, err := BuildMarketplaceEntry(in)
			if err == nil {
				t.Fatalf("BuildMarketplaceEntry(published_at=%q): expected error, got nil", tt.publishedAt)
			}
			if !strings.Contains(err.Error(), tt.wantErrHas) {
				t.Fatalf("BuildMarketplaceEntry(published_at=%q) error = %q, want it to mention %q", tt.publishedAt, err.Error(), tt.wantErrHas)
			}
		})
	}
}

func TestBuildMarketplaceEntry_AcceptsValidPublishedAt(t *testing.T) {
	in := MarketplaceEntryInput{
		FestivalVersion: "0.2.10",
		Channel:         "stable",
		PublishedAt:     "2026-08-20T01:51:38Z",
		Components: []ComponentVersion{
			{Name: "camp", Version: "0.2.11"},
			{Name: "fest", Version: "0.4.5"},
			{Name: "festival", Version: "0.1.0"},
		},
		Artifacts: []ArtifactInput{{OS: "darwin", Arch: "all", Filename: "x", URL: "u", SHA256: "s"}},
	}
	out, err := BuildMarketplaceEntry(in)
	if err != nil {
		t.Fatalf("BuildMarketplaceEntry: %v", err)
	}
	if !strings.Contains(string(out), `"published_at": "2026-08-20T01:51:38Z"`) {
		t.Fatalf("emitted manifest does not contain the published_at value:\n%s", out)
	}
}

func TestBuildMarketplaceEntry_RejectsMissingInput(t *testing.T) {
	if _, err := BuildMarketplaceEntry(MarketplaceEntryInput{Channel: "stable"}); err == nil {
		t.Fatal("expected error for missing version/components")
	}
	if _, err := BuildMarketplaceEntry(MarketplaceEntryInput{
		FestivalVersion: "0.2.10", Channel: "stable",
	}); err == nil {
		t.Fatal("expected error for missing components")
	}
	if _, err := BuildMarketplaceEntry(MarketplaceEntryInput{
		FestivalVersion: "0.2.10", Channel: "stable",
		Components: []ComponentVersion{{Name: "camp", Version: "0.2.11"}, {Name: "fest", Version: ""}},
	}); err == nil {
		t.Fatal("expected error for incomplete component version")
	}
	if _, err := BuildMarketplaceEntry(MarketplaceEntryInput{
		FestivalVersion: "0.2.10", Channel: "stable",
		Components: []ComponentVersion{
			{Name: "camp", Version: "0.2.11"},
			{Name: "fest", Version: "0.4.5"},
			{Name: "festival", Version: "0.1.0"},
		},
	}); err == nil {
		t.Fatal("expected error for missing artifacts")
	}
}
