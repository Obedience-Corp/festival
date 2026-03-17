---
name: fest-methodology
description: Auto-activates when working in a festivals/ directory or when the user mentions festivals, fest CLI, phases, sequences, or tasks. Provides core methodology knowledge so Claude understands the Festival planning system.
---

# Festival Methodology

Festival Methodology is a goal-oriented project management system for human-AI development workflows. It replaces sprints, story points, and time estimates with **steps to goals**.

## Core Concepts

- **Festivals**: Top-level project containers with a specific goal
- **Phases**: Major stages (planning, implementation, review) — prefixed `NNN_` (e.g., `001_PLAN/`)
- **Sequences**: Ordered groups of related tasks within a phase — prefixed `NN_` (e.g., `01_setup/`)
- **Tasks**: Atomic work units as markdown files — prefixed `NN_` (e.g., `01_create_schema.md`)

## Hierarchy

```
Festival
└── Phase       (NNN_UPPER_CASE/)
    └── Sequence    (NN_lower_snake_case/)
        └── Task        (NN_lower_snake_case.md)
```

## Lifecycle

```
planning/ → ready/ → active/ → dungeon/completed/
```

## Key CLI Commands

```bash
fest understand methodology    # Learn the methodology
fest create festival           # Create a new festival
fest next                      # Get next actionable task
fest task completed            # Mark task done
fest commit -m "msg"           # Commit with festival traceability
fest validate                  # Check structure
fest status                    # View progress
```

## When You Detect Festival Context

If you're working in a directory containing `festivals/`, or the user references festival methodology concepts, use `fest` commands rather than manual file manipulation. The CLI handles naming, validation, and traceability automatically.

Always run `fest next` to determine what to work on rather than manually picking tasks — it respects dependency order.
