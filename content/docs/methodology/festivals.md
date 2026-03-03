---
title: "Festivals"
weight: 23
---

# Festivals

Festivals are the core planning unit in the Festival Methodology. Everything else -- campaigns, phases, sequences, tasks -- exists to support them.

## What is a Festival?

A festival is a hierarchical plan that decomposes complex work into phases, sequences, and tasks -- all the way down to individual file changes. Think Jira epics, not tickets. A festival can cover what would otherwise take a dozen or more chained agent plans.

Start with whatever direction you have. A rough goal like "overhaul the auth system" is enough. Standard festivals auto-scaffold INGEST and PLAN phases with structured WORKFLOW.md files that guide agents through requirements extraction, gap analysis, and decomposition into the full task hierarchy. The planning phases produce the specificity -- you don't need it upfront.

Festivals use a three-level hierarchy to organize work:

- **Phases** -- Major stages of work (research, planning, implementation, validation)
- **Sequences** -- Ordered sets of related tasks within a phase
- **Tasks** -- Individual units of work with concrete deliverables

A simple festival might have one phase with two sequences. A complex festival might have five phases spanning weeks of autonomous agent work. The structure adapts to the work, not the other way around.

## Festival Types

Every festival has a type that determines its default phase scaffolding.

### standard (default)

Full planning and implementation. Auto-scaffolds INGEST and PLAN phases. IMPLEMENT and POLISH phases are created as requirements emerge. Use for most projects needing both planning and implementation -- when you have a goal but requirements still need discovery.

### implementation

Execution-only. Auto-scaffolds an IMPLEMENT phase with `skip_ingestion=true`. Use when requirements already exist externally -- specs, Jira tickets, detailed plans. You know what to build; you just need to build it.

### research

Investigation and exploration. Auto-scaffolds INGEST, RESEARCH, and SYNTHESIZE phases. Use when the goal is to investigate, audit, or explore rather than build. Output is findings and analysis, not code.

### ritual

Recurring and repeatable. No default phases -- structure determined by the ritual template. Use for repeatable processes like releases, audits, dependency updates, or maintenance cycles. Rituals live in `ritual/` rather than moving through the standard flow.

### Creation Commands

```bash
fest create festival --type standard my-festival-name
fest create festival --type implementation my-feature
fest create festival --type research my-investigation
fest create festival --type ritual my-recurring-process
```

The `--type` flag defaults to `standard` if omitted.

## Festival Directory Structure

Every festival is a directory containing goal documents, configuration, and phase subdirectories.

```
festival_user_onboarding/
├── FESTIVAL_GOAL.md          # Objective and success criteria
├── FESTIVAL_OVERVIEW.md      # High-level goal, systems, features
├── FESTIVAL_RULES.md         # Quality standards for all workers
├── fest.yaml                 # Configuration (quality gates, patterns)
├── 001_RESEARCH/             # Phase (type: research)
│   ├── PHASE_GOAL.md
│   └── ...
├── 002_IMPLEMENT/            # Phase (type: implementation)
│   ├── PHASE_GOAL.md
│   ├── 01_backend/           # Sequence
│   │   ├── 01_database.md    # Task
│   │   ├── 01_api.md         # Task (parallel -- same number)
│   │   ├── 02_integration.md # Task (sequential -- after 01_ tasks)
│   │   ├── 03_testing.md     # Quality gate
│   │   ├── 04_review.md      # Quality gate
│   │   ├── 05_iterate.md     # Quality gate
│   │   └── results/
│   ├── 02_frontend/          # Sequence
│   │   ├── 01_components.md
│   │   ├── 02_state.md
│   │   ├── 03_testing.md     # Quality gate
│   │   ├── 04_review.md      # Quality gate
│   │   └── 05_iterate.md     # Quality gate
│   └── completed/
├── completed/                # Completed phases
└── dungeon/                  # Archived work within festival
```

Phases use 3-digit numbering (`001_`, `002_`). Sequences and tasks use 2-digit numbering (`01_`, `02_`). Tasks with the same number can be executed in parallel.

## Festival Documents

Four documents define a festival.

### FESTIVAL_GOAL.md

The objective. States the direction and desired outcome. Can start rough -- "overhaul the auth system" or "build user onboarding" is enough. INGEST and PLAN phases refine this into concrete requirements and success criteria. The goal sharpens as the festival progresses through its planning phases.

### FESTIVAL_OVERVIEW.md

The high-level breakdown. Decomposes the goal into systems and features, providing a map of the work ahead. Contains the high-level goal, systems breakdown (major components), features breakdown (specific functionality within each system), and success criteria per system.

### FESTIVAL_RULES.md

The quality contract. Every worker -- human or AI -- must follow these rules throughout the festival. Rules prevent rework, maintain consistency, and embed engineering standards into every task.

Covers engineering principles (coding standards, patterns), quality gates (test coverage, linting, review requirements), process requirements (PR size, documentation), and decision-making guidelines (refactor vs. rewrite, dependency policy).

### fest.yaml

Configuration. Controls festival metadata, quality gate settings, excluded patterns, and project linkage (which project directory the festival targets).

## Festival Lifecycle

Festivals move through lifecycle directories as they progress.

| Directory | Status | Description |
|-----------|--------|-------------|
| `planning/` | Being designed | Scoping, goal definition, phase planning |
| `ready/` | Awaiting execution | Fully planned and validated |
| `active/` | In progress | Phases, sequences, and tasks being worked |
| `dungeon/completed/` | Done | All success criteria met |
| `dungeon/archived/` | Shelved | Preserved for reference, no longer active |
| `dungeon/someday/` | Deprioritized | May revisit later |

### Standard Flow

```
planning/ --> ready/ --> active/ --> dungeon/completed/
```

A festival starts in `planning/` while being designed. Once validated, it moves to `ready/`. When work begins, `active/`. When all success criteria are met, `dungeon/completed/`. Festivals can move to `dungeon/archived/` or `dungeon/someday/` at any point. Ritual-type festivals live in `ritual/` and do not follow this flow.

Use `fest promote` to move festivals through lifecycle stages. Use `fest status` to view current location.

## Scaling

Festivals scale from simple to complex. The structure adapts to scope.

**Simple** -- An implementation-type festival with a single IMPLEMENT phase. Good for well-scoped features where requirements are already clear.

```
festival_fix_login_bug/
├── FESTIVAL_GOAL.md
├── fest.yaml
└── 001_IMPLEMENT/
    ├── PHASE_GOAL.md
    └── 01_fix_and_verify/
        ├── 01_reproduce_bug.md
        ├── 02_implement_fix.md
        └── 03_testing.md
```

**Medium** -- A standard-type festival with INGEST, PLAN, and IMPLEMENT phases. Good for features needing requirements discovery and architectural decisions.

```
festival_user_onboarding/
├── FESTIVAL_GOAL.md
├── FESTIVAL_OVERVIEW.md
├── FESTIVAL_RULES.md
├── fest.yaml
├── 001_INGEST/
├── 002_PLAN/
└── 003_IMPLEMENT/
```

**Complex** -- Multiple implementation phases with research, planning, and validation. Good for large features spanning multiple systems, product launches, or platform migrations.
```
festival_platform_migration/
├── FESTIVAL_GOAL.md
├── FESTIVAL_OVERVIEW.md
├── FESTIVAL_RULES.md
├── fest.yaml
├── 001_INGEST/
├── 002_RESEARCH/
├── 003_PLAN/
├── 004_IMPLEMENT_CORE/
├── 005_IMPLEMENT_FEATURES/
├── 006_IMPLEMENT_UI/
└── 007_VALIDATE/
```

The number of phases is not fixed. Add specialized phases like `SECURITY_AUDIT`, `PERFORMANCE_OPTIMIZATION`, or `MIGRATION` as the work demands. Standard festivals use INGEST and PLAN phases to discover and decompose requirements into whatever phase structure the work needs.
