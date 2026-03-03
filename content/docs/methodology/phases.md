---
title: "Phases"
weight: 24
---

# Phases

Phases are the top-level organizational unit within a festival. They group related work together and execute in order. A festival with three phases runs phase 1, then phase 2, then phase 3.

## Numbering

Phases use 3-digit zero-padded prefixes: `001_`, `002_`, `003_`. This supports up to 999 phases per festival, which is far more than any real project needs but keeps sorting clean.

Standard festivals auto-scaffold INGEST and PLAN phases. The PLAN phase's WORKFLOW.md guides agents through decomposing the work into whatever additional phases, sequences, and tasks are needed. Implementation festivals skip planning and start with a single IMPLEMENT phase. Either way, the phase structure emerges from structured thinking, not guesswork.

## Phase Types

| Phase Type | Purpose | Structural Conventions |
|---|---|---|
| **planning** | Design, architecture, requirements | Uses `inputs/` and WORKFLOW.md. No numbered sequences. Contains decisions, plans, references. |
| **implementation** | Writing code, building features | Numbered sequences with task files. Quality gates auto-appended. This is where agents work autonomously. |
| **research** | Investigation, exploration, auditing | Uses WORKFLOW.md with `sources/`, `findings/` directories. No numbered sequences. |
| **review** | Code review, integration testing | Freeform. PHASE_GOAL.md with review criteria and checklists. |
| **ingest** | Absorbing external content | Uses WORKFLOW.md with `input_specs/`, `output_specs/` directories. |
| **non_coding_action** | Documentation, process changes | Freeform. PHASE_GOAL.md with action items and checklists. |

Create a phase with the `fest` CLI:

```bash
fest create phase --name "001_RESEARCH" --type research
```

## Directory Structure per Phase Type

Each phase type has a different internal structure optimized for the kind of work it contains.

### Planning

```
001_PLAN/
├── PHASE_GOAL.md
├── WORKFLOW.md
├── inputs/
│   └── requirements.md
├── decisions/
│   └── architecture_decision.md
└── plan/
    └── implementation_plan.md
```

Planning phases are freeform. No numbered sequences. The `WORKFLOW.md` describes how to work through the planning process, `inputs/` holds source material, and output goes into `decisions/` and `plan/`.

### Implementation

```
002_IMPLEMENT/
├── PHASE_GOAL.md
├── 01_backend_foundation/
│   ├── 01_database_setup.md
│   ├── 02_api_endpoints.md
│   ├── 03_testing.md           ← Quality gate
│   ├── 04_review.md            ← Quality gate
│   └── 05_iterate.md           ← Quality gate
└── completed/
```

Implementation phases use numbered sequences containing numbered task files. Quality gate tasks (testing, review, iterate) are auto-appended to each sequence. Completed sequences move to `completed/`.

### Research

```
001_RESEARCH/
├── PHASE_GOAL.md
├── WORKFLOW.md
├── sources/
└── findings/
```

Research phases follow a workflow-driven structure. `sources/` holds reference material. `findings/` holds what you discovered. No numbered sequences.

### Ingest

```
001_INGEST/
├── PHASE_GOAL.md
├── WORKFLOW.md
├── input_specs/
└── output_specs/
```

Ingest phases absorb external content into the festival. `input_specs/` defines what to consume. `output_specs/` defines the expected output format.

### Review

Review phases are freeform. They contain a `PHASE_GOAL.md` with review criteria and checklists, plus whatever supporting content the review requires. No prescribed directory structure.

### Non-Coding Action

Same as review - freeform. `PHASE_GOAL.md` with action items and checklists. Use this for documentation work, process changes, or anything that isn't code.

## PHASE_GOAL.md

Every phase has a `PHASE_GOAL.md` at its root. This file defines what the phase is trying to accomplish, its success criteria, and any constraints. Agents read this first when entering a phase.

## Workflow Files

`WORKFLOW.md` is a markdown document describing the process for a phase. It tells agents (or humans) how to work through the phase step by step.

Workflow files are used in planning, ingest, and research phases. They can be the sole structural element in a phase, or they can coexist with numbered sequences in hybrid phases.

## Hybrid Phases

A phase can contain both workflow files and numbered sequences. This is useful when a phase has some freeform process work alongside structured implementation tasks.

```
001_RESEARCH_AND_PROTOTYPE/
├── PHASE_GOAL.md
├── WORKFLOW.md
├── sources/
├── findings/
├── 01_prototype_api/
│   ├── 01_spike_design.md
│   └── 02_build_prototype.md
└── 02_evaluate_results/
    ├── 01_benchmark.md
    └── 02_decision.md
```

The workflow file guides the overall process. The sequences handle the structured parts.

## Common Phase Patterns

Most festivals follow one of these patterns. Pick the simplest one that fits your situation.

**Implementation Only** (requirements already provided):
`001_IMPLEMENT`

**Research + Implementation**:
`001_RESEARCH` → `002_IMPLEMENT`

**Standard with Planning**:
`001_INGEST` → `002_PLAN` → `003_IMPLEMENT`

**Full Lifecycle**:
`001_INGEST` → `002_PLAN` → `003_IMPLEMENT` → `004_VALIDATE`

**Multiple Implementation Phases**:
`001_PLAN` → `002_IMPLEMENT_CORE` → `003_IMPLEMENT_FEATURES` → `004_IMPLEMENT_UI`

**Research Festival**:
`001_INGEST` → `002_RESEARCH` → `003_SYNTHESIZE`

These are starting points, not rigid templates. Add custom phases as the work demands - `005_SECURITY_AUDIT/`, `006_PERFORMANCE_OPTIMIZATION/`, whatever the festival needs. Phase types exist to give you sensible defaults, not to constrain you.
