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
	Festival    ReleaseInfo
	// Components are the bundled CLI binaries with their own repos and
	// release pages: fest, camp, and the festival hub itself. Order here is
	// the order they appear in the body.
	Components []ReleaseInfo
}

func Render(in ReleaseNotesInput) (string, error) {
	if in.FestivalTag == "" {
		return "", fmt.Errorf("festival tag is required")
	}
	if len(in.Components) == 0 {
		return "", fmt.Errorf("at least one component release is required")
	}
	for _, c := range in.Components {
		if c.Tag == "" || c.URL == "" {
			name := c.Repo
			if name == "" {
				name = "component"
			}
			return "", fmt.Errorf("%s release info is incomplete", name)
		}
	}

	festivalBody := normalizeGeneratedNotes(in.Festival.Body)

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
	for _, c := range in.Components {
		writeLine(fmt.Sprintf("- `%s` %s ([release](%s))", c.Repo, c.Tag, c.URL))
	}
	writeLine("")
	writeLine("This release also includes Festival distribution, packaging, documentation, and plugin changes.")
	writeLine("")
	writeLine("## Festival Changes")
	writeLine("")
	writeLine(festivalBody)
	writeLine("")
	writeLine("The component release notes below describe the bundled CLI changes.")
	writeLine("")
	for _, c := range in.Components {
		writeLine("## " + c.Repo + " " + c.Tag)
		writeLine("")
		writeLine(normalizeBody(c.Body, c.Repo, c.Tag))
		writeLine("")
	}
	writeLine("## Festival Packaging Notes")
	writeLine("")
	writeLine("This release bundles the `camp` and `fest` CLIs together with `festival`, the installer and launcher for the suite.")
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

func normalizeGeneratedNotes(body string) string {
	trimmed := strings.TrimSpace(body)
	if trimmed == "" {
		return "_No Festival repository changes were reported for this release._"
	}
	return demoteMarkdownHeadings(trimmed)
}

func demoteMarkdownHeadings(markdown string) string {
	lines := strings.Split(markdown, "\n")
	for i, line := range lines {
		if strings.HasPrefix(line, "#") {
			lines[i] = "#" + line
		}
	}
	return strings.Join(lines, "\n")
}
