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

When the festival or its sequence has a linked project, this one command covers
both sides: it makes a project commit for the project's changes (skipped when the
project is clean) and a camp root commit for the festival-scoped files. Do not
run `camp p commit` first and `fest commit` after.

If not currently inside a festival context, fall back to suggesting `camp p commit`
for project submodule work or `camp commit` for camp root changes. Raw
`git commit` is forbidden inside a camp.
