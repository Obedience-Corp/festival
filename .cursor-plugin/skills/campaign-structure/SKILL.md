---
name: campaign-structure
description: Orient within a camp's directory structure. Use when deciding where work belongs (intents vs festivals vs design vs docs vs dungeon), especially when a task is not yet planned or folder ownership is unclear.
---

# Camp Structure

A camp was previously called a campaign; the layout below is the same either way.

## Placement Rules

- Raw idea / bug / future work / quick capture: `.campaign/intents/inbox/` (use `camp intent add`)
- Enriching or preparing for execution: `.campaign/intents/active/`
- Ready for structured work: `.campaign/intents/ready/` → promote to festival
- Structured multi-phase execution: `festivals/`
- Internal design, architecture, or deep exploration: `workflow/design/`
- User-facing documentation: `docs/`
- Research, analysis, and exploration notes: `workflow/explore/`
- Archive / defer / killed: `.campaign/intents/dungeon/` or top-level `dungeon/`

## Critical Distinctions

- `.campaign/intents/` (especially `inbox/`) is the primary capture surface for new ideas, bugs, and tasks.
- `workflow/design/` is for thoughtful internal design documents and specs.
- `festivals/` is for planned, phased execution (not raw ideas).
- `docs/` is user-facing; `workflow/explore/` is internal.

Canonical reference: `.campaign/intents/OBEY.md`

## Layout Snapshot (Current)

```text
.campaign/
├── intents/          # Idea capture (inbox / active / ready / dungeon)
│   └── OBEY.md       # Authoritative intent guide
├── quests/           # Long-lived working contexts
└── skills/           # Camp-specific agent skills (loaded at runtime)

projects/             # Git submodules (the actual codebases)
workflow/
├── code_reviews/
├── pipelines/
├── design/           # Design documents & specs
└── explore/          # Historical research notes

festivals/            # Festival methodology (planning + active)
docs/                 # User-facing documentation
dungeon/              # Top-level archive
```

## Common Mistakes

- Putting raw ideas directly into `festivals/` or `workflow/design/` without going through intents first.
- Treating `docs/` as the place for internal specs (use `workflow/design/` or `.campaign/intents/`).
- Creating ad-hoc top-level directories instead of using the established taxonomy.
- Forgetting that `cgo i` now navigates to `.campaign/intents/`.
