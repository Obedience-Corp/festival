---
title: "Shell Setup"
weight: 13
---

# Shell Setup

Enable shell integration for directory navigation and tab completion.

## Setup

If your installer created Festival helper files, source the helper for your
shell from your shell config.

```bash
# install.sh default location
source ~/.local/share/festival/shell/festival.zsh

# Homebrew
source "$(brew --prefix)/share/festival/shell/festival.zsh"

# Linux packages
source /usr/share/festival/shell/festival.zsh
```

For bash, use `festival.bash`. For fish, use `festival.fish`.

If you do not have an installed helper file, use the dynamic fallback:

```bash
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```

For bash, replace `zsh` with `bash`. For fish, use:

```fish
camp shell-init fish | source
fest shell-init fish | source
```

## Shell Functions

### fest shell functions

- `fgo` - Navigate to festival directories
- `fls` - List festivals

### camp shell functions

- `cgo` - Navigate between campaign projects with fuzzy finding
