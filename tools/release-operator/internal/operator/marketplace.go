package operator

import (
	"encoding/json"
	"fmt"
	"sort"
)

type MarketplaceEntryInput struct {
	FestivalVersion string
	Channel         string
	PublishedAt     string
	CampVersion     string
	FestVersion     string
	Artifacts       []ArtifactInput
}

type ArtifactInput struct {
	OS       string
	Arch     string
	Filename string
	URL      string
	SHA256   string
}

type productManifest struct {
	SchemaVersion    int           `json:"schema_version"`
	ID               string        `json:"id"`
	Class            string        `json:"class"`
	DisplayName      string        `json:"display_name"`
	Summary          string        `json:"summary"`
	Description      string        `json:"description"`
	Homepage         string        `json:"homepage"`
	Licenses         []string      `json:"licenses"`
	Aliases          []string      `json:"aliases"`
	Tags             []string      `json:"tags"`
	SupportedScopes  []string      `json:"supported_scopes"`
	ProvidesBinaries []string      `json:"provides_binaries"`
	HostRuntimes     []hostRuntime `json:"host_runtimes"`
	Releases         []release     `json:"releases"`
}

type hostRuntime struct {
	Runtime     string   `json:"runtime"`
	DisplayName string   `json:"display_name"`
	Features    []string `json:"features"`
}

type release struct {
	Version       string            `json:"version"`
	Channel       string            `json:"channel"`
	PublishedAt   string            `json:"published_at"`
	Components    map[string]string `json:"components"`
	Compatibility compatibility     `json:"compatibility"`
	Dependencies  []any             `json:"dependencies"`
	Artifacts     []artifact        `json:"artifacts"`
	Install       installBlock      `json:"install"`
}

type compatibility struct {
	OS   []string `json:"os"`
	Arch []string `json:"arch"`
}

type artifact struct {
	Kind     string   `json:"kind"`
	OS       string   `json:"os"`
	Arch     string   `json:"arch"`
	Filename string   `json:"filename"`
	URL      string   `json:"url"`
	SHA256   string   `json:"sha256"`
	Binaries []string `json:"binaries"`
}

type installBlock struct {
	Entries []installEntry `json:"entries"`
}

type installEntry struct {
	Kind           string `json:"kind"`
	Source         string `json:"source"`
	ExecutableName string `json:"executable_name"`
}

func BuildMarketplaceEntry(in MarketplaceEntryInput) ([]byte, error) {
	if in.FestivalVersion == "" || in.Channel == "" || in.CampVersion == "" || in.FestVersion == "" {
		return nil, fmt.Errorf("missing required marketplace entry input")
	}
	if len(in.Artifacts) == 0 {
		return nil, fmt.Errorf("no artifacts for %s", in.FestivalVersion)
	}

	sorted := append([]ArtifactInput(nil), in.Artifacts...)
	sort.Slice(sorted, func(i, j int) bool {
		if sorted[i].OS != sorted[j].OS {
			return sorted[i].OS < sorted[j].OS
		}
		return sorted[i].Arch < sorted[j].Arch
	})

	arts := make([]artifact, 0, len(sorted))
	osSet := map[string]struct{}{}
	archSet := map[string]struct{}{}
	for _, a := range sorted {
		if a.OS == "" || a.Arch == "" || a.Filename == "" || a.URL == "" || a.SHA256 == "" {
			return nil, fmt.Errorf("incomplete artifact for %s/%s", a.OS, a.Arch)
		}
		arts = append(arts, artifact{
			Kind:     "suite-archive",
			OS:       a.OS,
			Arch:     a.Arch,
			Filename: a.Filename,
			URL:      a.URL,
			SHA256:   a.SHA256,
			Binaries: []string{"camp", "fest"},
		})
		osSet[a.OS] = struct{}{}
		if a.Arch != "all" {
			archSet[a.Arch] = struct{}{}
		}
	}
	archSet["amd64"] = struct{}{}
	archSet["arm64"] = struct{}{}

	m := productManifest{
		SchemaVersion: 1,
		ID:            "obedience-corp/festival",
		Class:         "product",
		DisplayName:   "Festival Suite",
		Summary:       "The camp + fest CLI suite, released and versioned together.",
		Description:   "Festival Methodology CLI suite. camp and fest are co-tested and shipped as one versioned product; both binaries report the festival release version.",
		Homepage:      "https://fest.build",
		Licenses:      []string{"FSL-1.1-ALv2"},
		Aliases:       []string{"festival", "camp", "fest"},
		Tags:          []string{"festival", "planning", "cli"},
		SupportedScopes:  []string{"user"},
		ProvidesBinaries: []string{"camp", "fest"},
		HostRuntimes: []hostRuntime{
			{Runtime: "camp-cli", DisplayName: "Camp CLI plugins", Features: []string{}},
			{Runtime: "fest-cli", DisplayName: "Fest CLI plugins", Features: []string{}},
			{Runtime: "fest-extension", DisplayName: "Fest methodology extensions", Features: []string{"marketplace_extension_source_v1"}},
		},
		Releases: []release{{
			Version:     in.FestivalVersion,
			Channel:     in.Channel,
			PublishedAt: in.PublishedAt,
			Components:  map[string]string{"camp": in.CampVersion, "fest": in.FestVersion},
			Compatibility: compatibility{
				OS:   sortedKeys(osSet),
				Arch: sortedKeys(archSet),
			},
			Dependencies: []any{},
			Artifacts:    arts,
			Install: installBlock{Entries: []installEntry{
				{Kind: "binary", Source: "camp", ExecutableName: "camp"},
				{Kind: "binary", Source: "fest", ExecutableName: "fest"},
			}},
		}},
	}

	out, err := json.MarshalIndent(m, "", "  ")
	if err != nil {
		return nil, fmt.Errorf("marshal product manifest: %w", err)
	}
	return append(out, '\n'), nil
}

func sortedKeys(set map[string]struct{}) []string {
	keys := make([]string, 0, len(set))
	for k := range set {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}
