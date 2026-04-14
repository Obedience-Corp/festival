package main

import "testing"

func TestModeConfigStable(t *testing.T) {
	mode, err := modeConfig("stable")
	if err != nil {
		t.Fatalf("modeConfig returned error: %v", err)
	}

	if got, want := mode.BuildProfile, "stable"; got != want {
		t.Fatalf("BuildProfile = %q, want %q", got, want)
	}
	if got, want := mode.DocsEnv["CLI_RELEASE_CHANNEL"], "stable"; got != want {
		t.Fatalf("CLI_RELEASE_CHANNEL = %q, want %q", got, want)
	}
}

func TestModeConfigDev(t *testing.T) {
	mode, err := modeConfig("dev")
	if err != nil {
		t.Fatalf("modeConfig returned error: %v", err)
	}

	if got, want := mode.BuildProfile, "dev"; got != want {
		t.Fatalf("BuildProfile = %q, want %q", got, want)
	}
	if got, want := mode.DocsEnv["CLI_PROFILE"], "dev"; got != want {
		t.Fatalf("CLI_PROFILE = %q, want %q", got, want)
	}
}

func TestModeConfigRejectsUnknownMode(t *testing.T) {
	if _, err := modeConfig("beta"); err == nil {
		t.Fatal("expected unknown mode error")
	}
}

func TestReleaseTagFor(t *testing.T) {
	stable, _ := modeConfig("stable")
	rc, _ := modeConfig("rc")
	dev, _ := modeConfig("dev")

	if got, want := releaseTagFor(stable, "0.2.1", 0), "v0.2.1"; got != want {
		t.Fatalf("stable tag = %q, want %q", got, want)
	}
	if got, want := releaseTagFor(rc, "0.2.1", 3), "v0.2.1-rc.3"; got != want {
		t.Fatalf("rc tag = %q, want %q", got, want)
	}
	if got, want := releaseTagFor(dev, "0.2.1", 4), "v0.2.1-dev.4"; got != want {
		t.Fatalf("dev tag = %q, want %q", got, want)
	}
}
