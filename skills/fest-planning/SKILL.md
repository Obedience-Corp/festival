---
name: fest-planning
description: Plan and scaffold festivals. Use when creating festival/phase/sequence/task structure, enforcing naming rules, linking festivals to projects, and promoting lifecycle states.
version: "1.3.0"
author: Obedience Corp
license: MIT
metadata:
  hermes:
    tags:
      - fest
      - festival
      - planning
      - scaffolding
    category: festival
---

# Festival Planning

## Start Here

```bash
fest understand methodology
fest understand structure
fest understand tasks
fest understand rules
fest types festival
```

## Naming Rules (Automation-Critical)

- Phase dir: `NNN_UPPER_CASE/` (e.g., `001_IMPLEMENT/`)
- Sequence dir: `NN_lower_snake_case/` (e.g., `01_auth_module/`)
- Task file: `NN_lower_snake_case.md` (e.g., `01_create_handler.md`)

Every sequence should include `SEQUENCE_GOAL.md`.

## Festival Types (Choose Before Scaffolding)

Use `fest types festival` / `fest types festival show <type>` as source of truth.

- `standard`: Full planning + implementation (recommended for most work)
- `implementation`: Execution-only (use when requirements already exist)
- `research`: Investigation and exploration
- `ritual`: Recurring processes

```bash
fest create festival --name "<name>" --type standard
fest create festival --name "<name>" --type implementation
fest create festival --name "<name>" --type research
fest create festival --name "<name>" --type ritual --dest ritual
```

## Phase Types

- `planning`: Workflow phase for architecture/decisions (`WORKFLOW.md`, no numbered sequences)
- `research`: Investigation and findings
- `ingest`: Normalizing incoming context/specs
- `implementation`: Sequence-driven coding (numbered sequences/tasks, quality gates)
- `review`: Freeform acceptance/signoff
- `non_coding_action`: Operational actions

```bash
fest create phase --name "001_IMPLEMENT" --type implementation
```

## Create / Promote

```bash
fest create festival
fest create phase
fest create sequence
fest create task

fest promote
fest validate
```

## Link + Navigation

```bash
fest link [path]
fest link --show
fest links
fest unlink

# Shell helper after eval "$(fest shell-init zsh)"
fgo
fgo project
fgo fest
```

## Scaffolding from Plan

```bash
fest scaffold from-plan --plan STRUCTURE.md --name my-festival
```

## Standalone WORKFLOW.md (Outside a Festival)

For a short, repeatable step checklist that does not need a full festival
(phases/sequences/tasks), scaffold a standalone `WORKFLOW.md` instead:

```bash
fest create workflow <name>
# or, equivalently:
fest workflow create <name>
```

Both accept `--steps '<json>'` / `--steps-file <file>` for agent mode,
`--type` for the standalone workflow type, and `--no-init` for advanced mode
(skip runtime init and lazily bootstrap a tracked run on first
`fest workflow advance`). See the `fest-standalone-workflows` skill for the
full step-JSON schema and execution loop. Reach for a full festival instead
when the work needs multi-phase planning, sequencing, or quality gates.

## Common Mistakes

- Using `fest link --project ...` (invalid flag).
- Picking `implementation` type when requirements are still unclear.
- Using noncompliant naming patterns (`P1-...`, `S1-...`).
- Treating `fest scaffold` base command as if it performs generation by itself.
