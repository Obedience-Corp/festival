---
name: campaign-structure
description: Orient within campaign directory structure. Use when deciding where work belongs (intents vs festivals vs design vs docs vs dungeon), especially when a task is not yet planned or folder ownership is unclear.
---

# Campaign Structure

## Placement Rules

- Raw idea / bug / future work: `workflow/intents/`
- Structured execution plan: `festivals/`
- Internal design/spec: `workflow/design/`
- User-facing docs: `docs/`
- AI-generated analysis/research: `ai_docs/`
- Archive/defer: local `dungeon/` or campaign `dungeon/`

## Critical Distinctions

- `workflow/intents/` is idea capture.
- `festivals/dungeon/` is for already-planned festivals in terminal states.
- `docs/` and `workflow/design/` serve different audiences.

## Layout

```text
.campaign/
projects/
festivals/
workflow/
ai_docs/
docs/
dungeon/
```

## Common Mistakes

- Putting unplanned ideas directly into festival dungeons.
- Treating all documentation as `docs/`.
- Creating new top-level directories instead of using campaign taxonomy.
