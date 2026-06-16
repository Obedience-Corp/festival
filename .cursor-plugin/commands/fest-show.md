---
name: fest-show
description: Show festival progression — in-progress tasks, roadmap, and dependency view
arguments:
  - name: view
    description: "View mode: inprogress, roadmap, or deps (default: inprogress)"
    required: false
---

# Show Festival Progression

Display the current festival's execution state.

Based on the requested view:

### In-Progress (default)
```bash
fest show --inprogress
```

### Roadmap
```bash
fest show --roadmap
```

### Dependencies
```bash
fest deps
```

Present the output clearly so the user can see exactly where execution stands.
