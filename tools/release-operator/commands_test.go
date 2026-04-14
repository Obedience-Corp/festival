package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestCurrentStableReadinessReadyWhenPinsAreStableAndResolvable(t *testing.T) {
	root := t.TempDir()
	initComponentRepo(t, root, "fest", componentRepoOptions{
		modulePath: "example.com/fest",
		tag:        "v0.2.2",
	})
	initComponentRepo(t, root, "camp", componentRepoOptions{
		modulePath: "example.com/camp",
		tag:        "v0.3.1",
	})

	ctx, err := newRepoContext(root)
	if err != nil {
		t.Fatalf("newRepoContext returned error: %v", err)
	}

	report, err := ctx.currentStableReadiness()
	if err != nil {
		t.Fatalf("currentStableReadiness returned error: %v", err)
	}
	if !report.Ready {
		t.Fatalf("currentStableReadiness Ready = false, issues = %v", report.Issues)
	}
	if len(report.Issues) != 0 {
		t.Fatalf("currentStableReadiness Issues = %v, want none", report.Issues)
	}
}

func TestCurrentStableReadinessBlockedWhenPinnedTagIsNotStable(t *testing.T) {
	root := t.TempDir()
	initComponentRepo(t, root, "fest", componentRepoOptions{
		modulePath: "example.com/fest",
		tag:        "v0.2.2-dev.1",
	})
	initComponentRepo(t, root, "camp", componentRepoOptions{
		modulePath: "example.com/camp",
		tag:        "v0.3.1",
	})

	ctx, err := newRepoContext(root)
	if err != nil {
		t.Fatalf("newRepoContext returned error: %v", err)
	}

	report, err := ctx.currentStableReadiness()
	if err != nil {
		t.Fatalf("currentStableReadiness returned error: %v", err)
	}
	if report.Ready {
		t.Fatal("currentStableReadiness Ready = true, want false")
	}
	if !containsString(report.Issues, "fest is pinned to non-stable tag v0.2.2-dev.1") {
		t.Fatalf("currentStableReadiness Issues = %v, want non-stable fest issue", report.Issues)
	}
}

func TestCheckBundledModuleResolutionAtTagUsesTaggedSnapshot(t *testing.T) {
	root := t.TempDir()
	componentDir := initComponentRepo(t, root, "fest", componentRepoOptions{
		modulePath: "example.com/fest",
		goModExtra: "require example.com/missing v0.0.0\n",
		tag:        "v0.2.1",
	})
	writeFile(t, filepath.Join(componentDir, "go.mod"), "module example.com/fest\n\ngo 1.24.0\n")
	runGit(t, componentDir, "add", "go.mod")
	runGit(t, componentDir, "commit", "-m", "fix module resolution")
	runGit(t, componentDir, "tag", "v0.2.2")

	ctx, err := newRepoContext(root)
	if err != nil {
		t.Fatalf("newRepoContext returned error: %v", err)
	}

	if err := ctx.checkBundledModuleResolution("fest"); err != nil {
		t.Fatalf("checkBundledModuleResolution(HEAD) returned error: %v", err)
	}

	err = ctx.checkBundledModuleResolutionAtTag("fest", "v0.2.1")
	if err == nil {
		t.Fatal("checkBundledModuleResolutionAtTag returned nil, want error")
	}
	if !strings.Contains(err.Error(), "fest v0.2.1 module graph does not resolve from a clean cache") {
		t.Fatalf("checkBundledModuleResolutionAtTag error = %q, want tagged snapshot failure", err)
	}
}

func TestRunDraftExplicitDoesNotCreateTagWhenStablePreflightFails(t *testing.T) {
	root := initFestivalRepoFixture(t)
	tempBin := t.TempDir()
	writeExecutable(t, filepath.Join(tempBin, "gh"), "#!/bin/sh\nset -eu\ncase \"$1 $2\" in\n  \"auth status\")\n    exit 0\n    ;;\n  \"secret list\")\n    printf 'HOMEBREW_TAP_GITHUB_TOKEN\\nAUR_SSH_KEY\\n'\n    exit 0\n    ;;\nesac\nprintf 'unexpected gh invocation: %s\\n' \"$*\" >&2\nexit 1\n")
	writeExecutable(t, filepath.Join(tempBin, "just"), "#!/bin/sh\nprintf 'simulated preflight failure\\n' >&2\nexit 1\n")
	t.Setenv("PATH", tempBin+string(os.PathListSeparator)+os.Getenv("PATH"))

	ctx, err := newRepoContext(root)
	if err != nil {
		t.Fatalf("newRepoContext returned error: %v", err)
	}
	mode, err := modeConfig("stable")
	if err != nil {
		t.Fatalf("modeConfig returned error: %v", err)
	}

	err = runDraftExplicit(ctx, "0.3.0", mode, 0)
	if err == nil {
		t.Fatal("runDraftExplicit returned nil, want error")
	}
	if !strings.Contains(err.Error(), "exit status 1") {
		t.Fatalf("runDraftExplicit error = %q, want exit status 1", err)
	}

	tag, err := gitOutput(root, "tag", "-l", "v0.3.0")
	if err != nil {
		t.Fatalf("gitOutput(tag -l) returned error: %v", err)
	}
	if strings.TrimSpace(tag) != "" {
		t.Fatalf("festival tag v0.3.0 exists after failed preflight: %q", tag)
	}
}

type componentRepoOptions struct {
	modulePath string
	goModExtra string
	tag        string
}

func initComponentRepo(t *testing.T, root, name string, opts componentRepoOptions) string {
	t.Helper()

	dir := filepath.Join(root, name)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", dir, err)
	}
	runGit(t, dir, "init", "-b", "main")
	runGit(t, dir, "config", "user.name", "Test User")
	runGit(t, dir, "config", "user.email", "test@example.com")

	goMod := "module " + opts.modulePath + "\n\ngo 1.24.0\n"
	if opts.goModExtra != "" {
		goMod += "\n" + opts.goModExtra
	}
	writeFile(t, filepath.Join(dir, "go.mod"), goMod)
	writeFile(t, filepath.Join(dir, "main.go"), "package main\n\nfunc main() {}\n")
	runGit(t, dir, "add", "go.mod", "main.go")
	runGit(t, dir, "commit", "-m", "initial commit")
	if opts.tag != "" {
		runGit(t, dir, "tag", opts.tag)
	}

	return dir
}

func initFestivalRepoFixture(t *testing.T) string {
	t.Helper()

	root := t.TempDir()
	initComponentRepo(t, root, "fest", componentRepoOptions{
		modulePath: "example.com/fest",
		tag:        "v0.2.2",
	})
	initComponentRepo(t, root, "camp", componentRepoOptions{
		modulePath: "example.com/camp",
		tag:        "v0.3.1",
	})

	runGit(t, root, "init", "-b", "main")
	runGit(t, root, "config", "user.name", "Test User")
	runGit(t, root, "config", "user.email", "test@example.com")
	writeFile(t, filepath.Join(root, "README.md"), "festival\n")
	runGit(t, root, "add", "README.md", "fest", "camp")
	runGit(t, root, "commit", "-m", "initial commit")

	remote := filepath.Join(t.TempDir(), "festival-remote.git")
	runGit(t, t.TempDir(), "init", "--bare", remote)
	runGit(t, root, "remote", "add", "origin", remote)
	runGit(t, root, "push", "-u", "origin", "main")

	return root
}

func writeExecutable(t *testing.T, path, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o755); err != nil {
		t.Fatalf("write executable %s: %v", path, err)
	}
}

func containsString(items []string, want string) bool {
	for _, item := range items {
		if item == want {
			return true
		}
	}
	return false
}
