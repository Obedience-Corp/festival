---
name: camp-init
description: Initialize a new campaign workspace
arguments:
  - name: name
    description: "Name for the new campaign"
    required: true
---

# Initialize Campaign

Create a new campaign workspace with the standard directory structure.

```bash
camp init {{name}}
```

This creates:
- `projects/` — git submodule project directory
- `festivals/` — festival methodology workspace
- `workflow/` — intents, design docs, code reviews
- `docs/` — human-authored documentation
- `.campaign/` — workspace configuration

After init, remind the user to set up shell integration:

```bash
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"
```
