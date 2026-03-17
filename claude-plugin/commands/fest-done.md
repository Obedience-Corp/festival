---
name: fest-done
description: Mark the current festival task as completed and optionally commit
---

# Complete Current Task

Mark the current task as completed and optionally commit the work.

## Step 1: Mark Complete

```bash
fest task completed
```

## Step 2: Commit (if there are changes)

Ask the user for a commit message, then:

```bash
fest commit -m "<message>"
```

`fest commit` wraps git commit with festival traceability metadata. Always prefer it over raw `git commit` when working inside a festival.

## Step 3: Next Task

After completing, offer to show the next task:

```bash
fest next
```
