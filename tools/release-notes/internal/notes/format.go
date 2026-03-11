package notes

import (
	"fmt"
	"strings"
)

type ReleaseInfo struct {
	Repo string
	Tag  string
	URL  string
	Body string
}

type ReleaseNotesInput struct {
	FestivalTag string
	Fest        ReleaseInfo
	Camp        ReleaseInfo
}

func Render(in ReleaseNotesInput) (string, error) {
	if in.FestivalTag == "" {
		return "", fmt.Errorf("festival tag is required")
	}
	if in.Fest.Tag == "" || in.Fest.URL == "" {
		return "", fmt.Errorf("fest release info is incomplete")
	}
	if in.Camp.Tag == "" || in.Camp.URL == "" {
		return "", fmt.Errorf("camp release info is incomplete")
	}

	festBody := normalizeBody(in.Fest.Body, in.Fest.Repo, in.Fest.Tag)
	campBody := normalizeBody(in.Camp.Body, in.Camp.Repo, in.Camp.Tag)

	var b strings.Builder
	writeLine := func(s string) {
		b.WriteString(s)
		b.WriteByte('\n')
	}

	writeLine("## Festival " + in.FestivalTag)
	writeLine("")
	writeLine("Festival Methodology CLI suite release.")
	writeLine("")
	writeLine("This release installs:")
	writeLine(fmt.Sprintf("- `fest` %s ([release](%s))", in.Fest.Tag, in.Fest.URL))
	writeLine(fmt.Sprintf("- `camp` %s ([release](%s))", in.Camp.Tag, in.Camp.URL))
	writeLine("")
	writeLine("The component release notes below describe the actual CLI changes in this bundle.")
	writeLine("")
	writeLine("## fest " + in.Fest.Tag)
	writeLine("")
	writeLine(festBody)
	writeLine("")
	writeLine("## camp " + in.Camp.Tag)
	writeLine("")
	writeLine(campBody)
	writeLine("")
	writeLine("## Festival Packaging Notes")
	writeLine("")
	writeLine("`festival` is the distribution and documentation hub for the bundled `fest` and `camp` CLIs.")
	writeLine("")
	writeLine("## Installation")
	writeLine("")
	writeLine("See [full installation guide](https://fest.build/install/) for all platforms.")
	writeLine("")
	writeLine("| Platform | Command |")
	writeLine("|----------|---------|")
	writeLine("| macOS | `brew install --cask Obedience-Corp/tap/festival` |")
	writeLine("| Arch Linux | `yay -S festival-bin` |")
	writeLine("| Debian/Ubuntu | Download `.deb` from assets below |")
	writeLine("| Fedora/RHEL | Download `.rpm` from assets below |")
	writeLine("| Windows | Temporarily paused while Windows support is stabilized |")

	return strings.TrimSpace(b.String()) + "\n", nil
}

func normalizeBody(body, repo, tag string) string {
	trimmed := strings.TrimSpace(body)
	if trimmed != "" {
		return trimmed
	}
	if repo == "" {
		repo = "component"
	}
	return fmt.Sprintf("_No published release notes found for %s %s._", repo, tag)
}
