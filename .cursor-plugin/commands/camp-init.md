---
name: camp-init
description: Initialize a new camp
arguments:
  - name: name
    description: "Name for the new camp"
    required: true
---

# Initialize a Camp

Create a new camp with the standard directory structure. A camp was previously called a campaign; `camp init` is the same command either way.

```bash
camp init {{name}}
```

This creates:
- `projects/`: git submodule project directory
- `festivals/`: festival methodology workspace
- `workflow/`: intents, design docs, code reviews
- `docs/`: human-authored documentation
- `.campaign/`: camp metadata directory (that path is stable; do not rename it)

After init, remind the user to set up shell integration:

```bash
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```
