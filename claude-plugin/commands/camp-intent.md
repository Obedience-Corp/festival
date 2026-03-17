---
name: camp-intent
description: Capture an idea, list intents, or promote an intent to a festival
arguments:
  - name: action
    description: "Action to take: add, list, promote, archive, or move (default: add)"
    required: false
---

# Campaign Intents

Intents are lightweight idea capture — the entry point for work that isn't yet planned.

## Based on Action

### Add (default)
Ask the user to describe their idea, then capture it:

```bash
camp intent add "<description>"
```

### List
Show all current intents:

```bash
camp intent list
```

### Promote
Promote an intent to a festival (begins structured planning):

```bash
camp intent list  # show available intents first
camp intent promote <id>
```

### Move
Move an intent to a different status:

```bash
camp intent move <id> <status>
```

Statuses: `backlog`, `active`, `completed`, `archived`

### Archive
Archive an intent that's no longer relevant:

```bash
camp intent archive <id>
```
