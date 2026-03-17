---
name: fest-commit
description: Commit changes with festival traceability metadata
arguments:
  - name: message
    description: "Commit message"
    required: false
---

# Festival Commit

Commit with festival task traceability. Always prefer this over raw `git commit` when working inside a festival.

If no message argument provided, ask the user for one. Then:

```bash
fest commit -m "<message>"
```

If not currently inside a festival context, fall back to suggesting `camp p commit` for project submodule work or standard `git commit` for campaign root changes.
