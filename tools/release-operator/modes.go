package main

import "fmt"

type releaseMode struct {
	Name         string
	BuildProfile string
	ReleaseLabel string
	DocsEnv      map[string]string
}

func modeConfig(name string) (releaseMode, error) {
	switch name {
	case "stable":
		return releaseMode{
			Name:         "stable",
			BuildProfile: "stable",
			ReleaseLabel: "stable",
			DocsEnv: map[string]string{
				"CLI_RELEASE_CHANNEL": "stable",
			},
		}, nil
	case "rc":
		return releaseMode{
			Name:         "rc",
			BuildProfile: "stable",
			ReleaseLabel: "rc",
			DocsEnv: map[string]string{
				"CLI_RELEASE_CHANNEL": "rc",
			},
		}, nil
	case "dev":
		return releaseMode{
			Name:         "dev",
			BuildProfile: "dev",
			ReleaseLabel: "dev",
			DocsEnv: map[string]string{
				"CLI_PROFILE":         "dev",
				"CLI_RELEASE_CHANNEL": "dev",
			},
		}, nil
	default:
		return releaseMode{}, fmt.Errorf("mode must be 'stable', 'rc', or 'dev' (got: %s)", name)
	}
}

func releaseTagFor(mode releaseMode, version string, iteration int) string {
	switch mode.Name {
	case "stable":
		return "v" + version
	case "rc":
		return fmt.Sprintf("v%s-rc.%d", version, iteration)
	case "dev":
		return fmt.Sprintf("v%s-dev.%d", version, iteration)
	default:
		panic("unsupported release mode")
	}
}
