---
title: "Shell Setup"
weight: 13
---

# Shell Setup

Enable shell integration for directory navigation and tab completion.

## Setup

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
eval "$(fest shell-init zsh)"
eval "$(camp shell-init zsh)"
```

For bash, replace `zsh` with `bash`. For fish, replace with `fish`.

## Shell Functions

### fest shell functions

- `fgo` - Navigate to festival directories
- `fls` - List festivals

### camp shell functions

- `cgo` - Navigate between campaign projects with fuzzy finding
