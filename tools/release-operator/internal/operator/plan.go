package operator

import (
	"fmt"
	"regexp"
	"strconv"
)

var (
	stableTagPattern = regexp.MustCompile(`^v(\d+)\.(\d+)\.(\d+)$`)
	devTagPattern    = regexp.MustCompile(`^v(\d+)\.(\d+)\.(\d+)-dev\.(\d+)$`)
	rcTagPattern     = regexp.MustCompile(`^v(\d+)\.(\d+)\.(\d+)-rc\.(\d+)$`)
	releaseBranchRe  = regexp.MustCompile(`^release/v(\d+\.\d+\.\d+)$`)
)

type Version struct {
	Major int
	Minor int
	Patch int
}

func (v Version) String() string {
	return fmt.Sprintf("%d.%d.%d", v.Major, v.Minor, v.Patch)
}

func (v Version) Compare(other Version) int {
	switch {
	case v.Major != other.Major:
		if v.Major < other.Major {
			return -1
		}
		return 1
	case v.Minor != other.Minor:
		if v.Minor < other.Minor {
			return -1
		}
		return 1
	case v.Patch != other.Patch:
		if v.Patch < other.Patch {
			return -1
		}
		return 1
	default:
		return 0
	}
}

func (v Version) BumpPatch() Version {
	return Version{Major: v.Major, Minor: v.Minor, Patch: v.Patch + 1}
}

type ParsedPrerelease struct {
	Version Version
	N       int
}

type BundleInput struct {
	Channel                      string
	CurrentBranch                string
	FestTag                      string
	CampTag                      string
	LatestFestivalDev            string
	LatestFestivalRC             string
	LatestFestivalStable         string
	LatestFestivalVersionRC      string
	CurrentCommitTaggedLatestDev bool
	CurrentCommitTaggedVersionRC bool
	LatestRCReachableFromHead    bool
}

type BundlePlan struct {
	Channel     string
	Version     string
	Iteration   int
	ReleaseTag  string
	DraftRecipe string
	DraftArgs   []string
	Description string
}

func DeriveBundlePlan(in BundleInput) (BundlePlan, error) {
	if in.FestTag == "" || in.CampTag == "" {
		return BundlePlan{}, fmt.Errorf("missing component tags for %s release", in.Channel)
	}

	switch in.Channel {
	case "dev":
		return planDev(in)
	case "rc":
		return planRC(in)
	case "stable":
		return planStable(in)
	default:
		return BundlePlan{}, fmt.Errorf("unknown channel %q", in.Channel)
	}
}

func planDev(in BundleInput) (BundlePlan, error) {
	if in.CurrentBranch != "develop" {
		return BundlePlan{}, fmt.Errorf("dev releases must be created from the develop branch")
	}

	base := Version{Major: 0, Minor: 1, Patch: 0}
	if in.LatestFestivalStable != "" {
		stable, err := ParseStableTag(in.LatestFestivalStable)
		if err != nil {
			return BundlePlan{}, err
		}
		base = stable.BumpPatch()
	}

	n := 1
	if in.LatestFestivalDev != "" {
		dev, err := ParseDevTag(in.LatestFestivalDev)
		if err != nil {
			return BundlePlan{}, err
		}
		if dev.Version.Compare(base) >= 0 {
			if in.CurrentCommitTaggedLatestDev {
				return BundlePlan{}, fmt.Errorf("latest festival dev release already tags the current commit")
			}
			base = dev.Version
			n = dev.N + 1
		}
	}

	version := base.String()
	return BundlePlan{
		Channel:     "dev",
		Version:     version,
		Iteration:   n,
		ReleaseTag:  fmt.Sprintf("v%s-dev.%d", version, n),
		DraftRecipe: "draft-dev-from-latest",
		DraftArgs:   []string{version, strconv.Itoa(n)},
		Description: fmt.Sprintf("Festival version line: v%s-dev.%d (derived from festival history on develop)", version, n),
	}, nil
}

func planRC(in BundleInput) (BundlePlan, error) {
	matches := releaseBranchRe.FindStringSubmatch(in.CurrentBranch)
	if matches == nil {
		return BundlePlan{}, fmt.Errorf("rc releases must be created from a release/vX.Y.Z branch")
	}

	version := matches[1]
	n := 1
	if in.LatestFestivalVersionRC != "" {
		rc, err := ParseRCTag(in.LatestFestivalVersionRC)
		if err != nil {
			return BundlePlan{}, err
		}
		if in.CurrentCommitTaggedVersionRC {
			return BundlePlan{}, fmt.Errorf("latest festival rc release already tags the current commit")
		}
		n = rc.N + 1
	}

	return BundlePlan{
		Channel:     "rc",
		Version:     version,
		Iteration:   n,
		ReleaseTag:  fmt.Sprintf("v%s-rc.%d", version, n),
		DraftRecipe: "draft-rc-from-latest",
		DraftArgs:   []string{version, strconv.Itoa(n)},
		Description: fmt.Sprintf("Festival version line: v%s-rc.%d (derived from %s)", version, n, in.CurrentBranch),
	}, nil
}

func planStable(in BundleInput) (BundlePlan, error) {
	if in.CurrentBranch != "main" {
		return BundlePlan{}, fmt.Errorf("stable releases must be created from the main branch")
	}
	if in.LatestFestivalRC == "" {
		return BundlePlan{}, fmt.Errorf("no festival rc exists to promote")
	}
	if !in.LatestRCReachableFromHead {
		return BundlePlan{}, fmt.Errorf("main does not contain the latest festival rc commit")
	}

	rc, err := ParseRCTag(in.LatestFestivalRC)
	if err != nil {
		return BundlePlan{}, err
	}

	if in.LatestFestivalStable != "" {
		stable, err := ParseStableTag(in.LatestFestivalStable)
		if err != nil {
			return BundlePlan{}, err
		}
		if stable.Compare(rc.Version) >= 0 {
			return BundlePlan{}, fmt.Errorf("there is no newer festival rc line to promote")
		}
	}

	version := rc.Version.String()
	return BundlePlan{
		Channel:     "stable",
		Version:     version,
		ReleaseTag:  "v" + version,
		DraftRecipe: "draft-stable-from-latest",
		DraftArgs:   []string{version},
		Description: fmt.Sprintf("Festival version line: v%s (promoting %s on main)", version, in.LatestFestivalRC),
	}, nil
}

func ParseStableTag(tag string) (Version, error) {
	matches := stableTagPattern.FindStringSubmatch(tag)
	if matches == nil {
		return Version{}, fmt.Errorf("invalid stable tag %q", tag)
	}
	return Version{
		Major: mustAtoi(matches[1]),
		Minor: mustAtoi(matches[2]),
		Patch: mustAtoi(matches[3]),
	}, nil
}

func ParseDevTag(tag string) (ParsedPrerelease, error) {
	matches := devTagPattern.FindStringSubmatch(tag)
	if matches == nil {
		return ParsedPrerelease{}, fmt.Errorf("invalid dev tag %q", tag)
	}
	return ParsedPrerelease{
		Version: Version{
			Major: mustAtoi(matches[1]),
			Minor: mustAtoi(matches[2]),
			Patch: mustAtoi(matches[3]),
		},
		N: mustAtoi(matches[4]),
	}, nil
}

func ParseRCTag(tag string) (ParsedPrerelease, error) {
	matches := rcTagPattern.FindStringSubmatch(tag)
	if matches == nil {
		return ParsedPrerelease{}, fmt.Errorf("invalid rc tag %q", tag)
	}
	return ParsedPrerelease{
		Version: Version{
			Major: mustAtoi(matches[1]),
			Minor: mustAtoi(matches[2]),
			Patch: mustAtoi(matches[3]),
		},
		N: mustAtoi(matches[4]),
	}, nil
}

func TagMatchesMode(tag, mode string) bool {
	switch mode {
	case "stable":
		return stableTagPattern.MatchString(tag)
	case "dev":
		return devTagPattern.MatchString(tag)
	case "rc":
		return rcTagPattern.MatchString(tag)
	default:
		return false
	}
}

func TagMatchesModeVersion(tag, mode, version string) bool {
	switch mode {
	case "dev":
		return regexp.MustCompile(`^v` + regexp.QuoteMeta(version) + `-dev\.[0-9]+$`).MatchString(tag)
	case "rc":
		return regexp.MustCompile(`^v` + regexp.QuoteMeta(version) + `-rc\.[0-9]+$`).MatchString(tag)
	default:
		return false
	}
}

func mustAtoi(s string) int {
	n, err := strconv.Atoi(s)
	if err != nil {
		panic(err)
	}
	return n
}
