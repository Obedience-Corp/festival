---
name: camp-navigation
description: Navigate campaign workspaces with `cgo` and `camp go`. Use when you need to move between projects/festivals/workflow directories, switch context quickly, or resolve script-safe paths with `camp go --print`.
---

# Campaign Navigation

Use `cgo` for interactive directory changes and `camp go --print` for scripts.

## Primary Commands

```bash
cgo                  # toggle campaign root ↔ last location
cgo p                # projects/
cgo f                # festivals/
cgo i                # workflow/intents/
cgo cr               # workflow/code_reviews/
cgo p camp           # projects/camp/
```

```bash
camp go p --print
camp go f --print
cd "$(camp go p --print)"
```

## Notes

- `cgo` requires shell init: `eval "$(camp shell-init zsh)"`.
- `camp go` does not change shell directory by itself.
- Shortcut source of truth: `camp shortcuts`.

## Common Mistakes

- Expecting `camp go` to behave like `cd`.
- Using raw path `cd` everywhere instead of campaign shortcuts.
- Forgetting shell init and then assuming `cgo` is broken.
