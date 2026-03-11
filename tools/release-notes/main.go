package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/Obedience-Corp/festival/tools/release-notes/internal/notes"
)

type releaseView struct {
	TagName string `json:"tagName"`
	URL     string `json:"url"`
	Body    string `json:"body"`
}

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("release-notes", flag.ContinueOnError)
	fs.SetOutput(os.Stderr)

	repoRoot := fs.String("repo-root", ".", "festival repo root")
	tag := fs.String("tag", "", "festival tag to render")
	outputPath := fs.String("output", "dist/release-notes.md", "output markdown path")
	if err := fs.Parse(args); err != nil {
		return err
	}

	absRoot, err := filepath.Abs(*repoRoot)
	if err != nil {
		return fmt.Errorf("resolve repo root: %w", err)
	}

	if *tag == "" {
		return errors.New("--tag is required")
	}

	if _, err := exec.LookPath("gh"); err != nil {
		return errors.New("gh CLI is required to generate release notes")
	}

	festTag, err := exactTag(filepath.Join(absRoot, "fest"))
	if err != nil {
		return fmt.Errorf("resolve pinned fest tag: %w", err)
	}
	campTag, err := exactTag(filepath.Join(absRoot, "camp"))
	if err != nil {
		return fmt.Errorf("resolve pinned camp tag: %w", err)
	}

	festRelease, err := fetchRelease("Obedience-Corp/fest", festTag)
	if err != nil {
		return fmt.Errorf("fetch fest release %s: %w", festTag, err)
	}
	campRelease, err := fetchRelease("Obedience-Corp/camp", campTag)
	if err != nil {
		return fmt.Errorf("fetch camp release %s: %w", campTag, err)
	}

	rendered, err := notes.Render(notes.ReleaseNotesInput{
		FestivalTag: *tag,
		Fest: notes.ReleaseInfo{
			Repo: "fest",
			Tag:  festRelease.TagName,
			URL:  festRelease.URL,
			Body: festRelease.Body,
		},
		Camp: notes.ReleaseInfo{
			Repo: "camp",
			Tag:  campRelease.TagName,
			URL:  campRelease.URL,
			Body: campRelease.Body,
		},
	})
	if err != nil {
		return err
	}

	absOutput := *outputPath
	if !filepath.IsAbs(absOutput) {
		absOutput = filepath.Join(absRoot, absOutput)
	}
	if err := os.MkdirAll(filepath.Dir(absOutput), 0o755); err != nil {
		return fmt.Errorf("create output directory: %w", err)
	}
	if err := os.WriteFile(absOutput, []byte(rendered), 0o644); err != nil {
		return fmt.Errorf("write release notes: %w", err)
	}

	fmt.Printf("Wrote release notes to %s\n", absOutput)
	fmt.Printf("Included fest %s and camp %s\n", festRelease.TagName, campRelease.TagName)
	return nil
}

func exactTag(dir string) (string, error) {
	out, err := cmdOutput(dir, "git", "describe", "--tags", "--exact-match", "HEAD")
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(out), nil
}

func fetchRelease(repo, tag string) (releaseView, error) {
	out, err := cmdOutput("", "gh", "release", "view", tag, "--repo", repo, "--json", "tagName,url,body")
	if err != nil {
		return releaseView{}, err
	}

	var view releaseView
	if err := json.Unmarshal([]byte(out), &view); err != nil {
		return releaseView{}, fmt.Errorf("parse gh release view output: %w", err)
	}
	if view.TagName == "" || view.URL == "" {
		return releaseView{}, fmt.Errorf("release %s in %s returned incomplete metadata", tag, repo)
	}
	return view, nil
}

func cmdOutput(dir, name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	if dir != "" {
		cmd.Dir = dir
	}
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("%s %s: %w\n%s", name, strings.Join(args, " "), err, strings.TrimSpace(string(out)))
	}
	return string(out), nil
}
