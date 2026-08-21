---
title: "Installation"
weight: 11
---

# Installation

Festival ships as a three-binary suite: **fest** (festival planning), **camp**
(campaign management), and **festival** (the suite installer and updater).
All installation methods below install all three.

`festival` installs, updates, and launches `camp` and `fest`. It verifies
signed package metadata against a compiled-in key and refuses unsigned
content by default.

```bash
festival install festival  # install the suite (camp, fest, and festival)
festival update            # keep camp, fest, and festival in sync
festival browse            # see what is available
festival doctor            # check the install
```

## Requirements

- `git` is required. Festival depends on it for campaign init, project management, template sync, and commit-aware workflows.
- `scc` is recommended but optional. Without it, `camp leverage` features will not work.

## npm / pnpm / bun

```bash
npm install -g @obedience-corp/festival
```

The npm package downloads the matching Festival GitHub release archive for your
platform, verifies it against the release checksums, and exposes `fest`,
`camp`, and `festival`. It also keeps the release completion and shell-helper
assets inside the installed package, but it does not edit your shell startup
files.

{{< tabs names="macOS, Linux, Windows (Temporarily Paused)" >}}

### Homebrew (Recommended)

```bash
brew install --cask Obedience-Corp/tap/festival
```

### Direct Download

Download the latest `.tar.gz` for your Mac from
[GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest),
extract, and move to your PATH:

```bash
tar xzf festival-*-macOS-*.tar.gz
sudo mv fest camp festival /usr/local/bin/
```

<!-- tab -->

### Debian / Ubuntu

Download the `.deb` package from
[GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest):

```bash
sudo dpkg -i festival_*_amd64.deb
```

### Fedora / RHEL

```bash
sudo rpm -i festival-*.x86_64.rpm
```

### Arch Linux (AUR)

```bash
yay -S festival-bin
```

### Alpine

```bash
sudo apk add --allow-untrusted festival_*.apk
```

### Direct Download

```bash
tar xzf festival-*-linux-*.tar.gz
sudo mv fest camp festival /usr/local/bin/
```

<!-- tab -->

Stable Windows packages are temporarily paused while Windows support is being hardened.

For now, use WSL2 and follow the Linux installation methods above.

Scoop and direct `.zip` downloads will return once Windows support is marked stable.

{{< /tabs >}}

## Other Methods

### Shell Script

A convenience script is available for macOS and Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

{{< note >}}
This downloads pre-built binaries to `~/.local/bin`.
The installer checks for `git` and stops early if it is missing. If `scc` is not installed, the installer continues and warns that `camp leverage` features will be unavailable until you add it.
It also installs completion files and shell-helper source files under `~/.local/share/festival/`.
When run from an interactive terminal, it asks whether to add the helper source line to your detected shell config; the default answer is yes.
[Review the script source](https://github.com/Obedience-Corp/festival/blob/main/install.sh) before running.
{{< /note >}}

### From Source

{{< note >}}
The `fest` and `camp` source repositories are public. The `festival` source
repository is not public yet, so there is no `go install` line for it below;
use the package manager or binary download methods above to get `festival`.
{{< /note >}}

Requires Go 1.25+:

```bash
go install github.com/Obedience-Corp/fest/cmd/fest@latest
go install github.com/Obedience-Corp/camp/cmd/camp@latest
```

## Verify Installation

```bash
fest --version
camp --version
festival --version
```

## Upgrading

How you upgrade depends on how you installed Festival.

### Homebrew

```bash
brew update
brew upgrade --cask festival
```

`brew outdated --cask` will surface a new festival release when one is available.

### npm / pnpm / bun

```bash
npm install -g @obedience-corp/festival@latest
```

### Debian / Ubuntu, Fedora / RHEL, Alpine

Download the latest package from [GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest) and reinstall using the same `dpkg -i`, `rpm -i`, or `apk add` command from the install steps above.

### Arch Linux (AUR)

```bash
yay -Syu festival-bin
```

### Shell Script

Re-run the installer. It will replace the binaries in `~/.local/bin` with the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

### From Source

```bash
go install github.com/Obedience-Corp/fest/cmd/fest@latest
go install github.com/Obedience-Corp/camp/cmd/camp@latest
```

## Shell Integration

Package installs include sourceable helper files for shell functions such as
`cgo`, `cr`, `csw`, `cint`, `fgo`, and `fls`, and they also register tab
completion for `camp`, `fest`, and `festival`. Add the line for your install
method and shell:

```bash
# install.sh default location
source ~/.local/share/festival/shell/festival.zsh

# Homebrew
source "$(brew --prefix)/share/festival/shell/festival.zsh"

# Linux packages
source /usr/share/festival/shell/festival.zsh
```

For bash, use `festival.bash`; for fish, use `festival.fish`.
The portable fallback is still:

```bash
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```

Replace `zsh` with `bash` or `sh` for those shells, or pipe the `fish` output to
`source`. Use `sh` for dash, busybox ash, and any other Bourne shell that is
neither bash nor zsh; it has no packaged helper file and installs no tab
completion.

See [Shell Setup]({{< ref "/getting-started/shell-setup" >}}) for details.
Then continue with the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to follow the validated beginner path through first `fest next`.
