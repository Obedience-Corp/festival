package operator

import (
	"encoding/json"
	"fmt"
	"sort"
	"time"
)

type MarketplaceEntryInput struct {
	FestivalVersion string
	Channel         string
	PublishedAt     string
	Components      []ComponentVersion
	Artifacts       []ArtifactInput
}

// ComponentVersion is one bundled binary's manifest identity: its name as
// shipped (matching provides_binaries and install.entries) and the version
// of the submodule it was built from.
type ComponentVersion struct {
	Name    string
	Version string
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
	if in.FestivalVersion == "" || in.Channel == "" {
		return nil, fmt.Errorf("missing required marketplace entry input")
	}
	if len(in.Components) == 0 {
		return nil, fmt.Errorf("no components for %s", in.FestivalVersion)
	}
	for _, c := range in.Components {
		if c.Name == "" || c.Version == "" {
			return nil, fmt.Errorf("incomplete component version for %q", c.Name)
		}
	}
	if len(in.Artifacts) == 0 {
		return nil, fmt.Errorf("no artifacts for %s", in.FestivalVersion)
	}
	// The hub's manifest schema requires published_at to be "format":
	// "date-time". v0.2.17 shipped with published_at="" because the workflow
	// omitted --published-at and this function accepted the empty string
	// anyway; the failure only surfaced on a user's machine as "schema
	// invalid at /releases/0/published_at". Refuse it here instead, so a
	// missing or malformed value fails the release, not the install.
	if in.PublishedAt == "" {
		return nil, fmt.Errorf("missing published_at for %s", in.FestivalVersion)
	}
	if _, err := time.Parse(time.RFC3339, in.PublishedAt); err != nil {
		return nil, fmt.Errorf("published_at %q is not RFC 3339: %w", in.PublishedAt, err)
	}

	binaries := make([]string, len(in.Components))
	componentVersions := make(map[string]string, len(in.Components))
	installEntries := make([]installEntry, len(in.Components))
	for i, c := range in.Components {
		binaries[i] = c.Name
		componentVersions[c.Name] = c.Version
		installEntries[i] = installEntry{Kind: "binary", Source: c.Name, ExecutableName: c.Name}
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
			Binaries: binaries,
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
		Summary:       "The camp, fest, and festival CLI suite, released and versioned together.",
		Description:   "Festival Methodology CLI suite. camp, fest, and festival are co-tested and shipped as one versioned product; all three binaries report the festival release version.",
		Homepage:      "https://fest.build",
		Licenses:      []string{"Apache-2.0"},
		// "festival" is both the product alias (it matches the distribution
		// ID) and, as of this release, one of the provided binaries. These
		// are separate namespaces in the resolver, so `festival install
		// festival` still resolves correctly: the first "festival" selects
		// this product, the second selects its festival binary. Leave the
		// alias in place; do not "fix" the apparent duplication.
		Aliases:          []string{"festival", "camp", "fest"},
		Tags:             []string{"festival", "planning", "cli"},
		SupportedScopes:  []string{"user"},
		ProvidesBinaries: binaries,
		// No festival-cli host runtime: nothing extends the hub as a plugin
		// host yet, and inventing a runtime with no consumer is speculative.
		// Add one when a real extension mechanism needs it.
		HostRuntimes: []hostRuntime{
			{Runtime: "camp-cli", DisplayName: "Camp CLI plugins", Features: []string{}},
			{Runtime: "fest-cli", DisplayName: "Fest CLI plugins", Features: []string{}},
			{Runtime: "fest-extension", DisplayName: "Fest methodology extensions", Features: []string{"marketplace_extension_source_v1"}},
		},
		Releases: []release{{
			Version:     in.FestivalVersion,
			Channel:     in.Channel,
			PublishedAt: in.PublishedAt,
			Components:  componentVersions,
			Compatibility: compatibility{
				OS:   sortedKeys(osSet),
				Arch: sortedKeys(archSet),
			},
			Dependencies: []any{},
			Artifacts:    arts,
			Install:      installBlock{Entries: installEntries},
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
