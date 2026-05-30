---
title: "Workflows & Gates"
weight: 28
---

# Workflows & Gates

## When a Phase Is a Process, Not a Task List

Implementation phases break into numbered sequences and tasks. But some phases are not
task lists at all. A planning phase, an ingest phase, or a research phase is a guided
process: read the input, extract the requirements, make the decisions, produce the
output. There is no clean way to pre-write that as a list of atomic tasks, because each
step depends on the thinking done in the step before it.

Workflows handle those phases. A workflow drives an agent through a phase one step at a
time, with checkpoints where a human approves the work before the agent continues.
Gates handle the other half: a quality check that runs at the end of a phase to confirm
the phase actually achieved its goal before anything moves forward.

Together they are how `fest` keeps an autonomous agent honest through the parts of the
work that cannot be reduced to a checklist.

## WORKFLOW.md: Step-Based Phase Guidance

Workflow phases (planning, ingest, research) use a `WORKFLOW.md` file instead of
numbered sequences. The document is the structure. Each step has four parts:

- **Goal** what the step accomplishes.
- **Actions** the ordered list of things to do.
- **Output** the expected result.
- **Checkpoint** an optional approval gate before the next step.

A step looks like this:

```markdown
## Step 1: SCOPE

**Goal:** Establish clear research objectives.

**Actions:**
1. Review inputs from previous phases
2. Identify the key questions that need answering
3. Decide what "good enough" looks like

**Output:** Research questions and a source plan

**Checkpoint:** None, proceed to Step 2
```

Standard festivals auto-scaffold their INGEST and PLAN phases with these files, so the
planning process is guided out of the box. See
[Phases]({{< ref "/methodology/phases" >}}) for where WORKFLOW.md sits in the phase
structure.

## Driving a Workflow

`fest next` surfaces the current step the same way it surfaces the next task, so an
agent always has one clear thing to do. The `fest workflow` commands move through the
steps:

```bash
fest workflow status     # show progress through the workflow
fest workflow show       # display the current step in full
fest workflow advance    # complete the current step and move to the next
fest workflow reset      # return to step 1
fest workflow validate   # check that step numbering is well-formed
```

Progress is recorded in `<festival>/.fest/progress_events.jsonl`, an append-only event
log. Current state is rebuilt by replaying the events, so the history of how a phase
was worked through is never overwritten.

## Checkpoints and Approval

A step can require explicit human approval before the agent continues. When a step has
a blocking checkpoint, the agent completes its actions, presents the output, and stops.
Nothing advances until a person responds:

```bash
fest workflow approve                       # accept the work and move on
fest workflow reject --reason "missing the error-handling cases"
```

`approve` marks the step complete and advances. `reject` sends the step back: it
becomes blocked, the reason is recorded, and the agent revises in place. When the
revision is ready, `fest workflow advance` resubmits it. This is the loop that lets an
agent run autonomously through the routine steps while a human stays in control of the
decisions that matter.

## GATES.md: Phase-Level Quality Gates

A gate verifies that a phase achieved its goal before the festival moves on. Gates live
in a `GATES.md` file, and every gate step is itself an approval checkpoint. Instead of
producing work, a gate step poses a quality or compliance question that must be answered
and approved:

```markdown
## Step 1: PHASE GOAL

**Question:** Does the implementation satisfy the phase goal? Were all required
deliverables produced?

**Actions:**
1. Re-read PHASE_GOAL.md and compare objectives against actual results
2. Verify each required deliverable exists and is functional
3. Confirm the work solves the problem the phase was created for

**Checkpoint:** Approval required, confirm the phase goal is met
```

Gates are available for all phase types. When `fest` navigates a phase, it routes
automatically: the WORKFLOW.md runs first if it is incomplete, and the GATES.md runs
once phase work is done. You do not pick the document; `fest workflow status` and
`fest next` target the right one for where the phase is.

## Reject, Skip, and Failed-Gate Remediation

Three operator actions look similar but record different audit trails. Pick the one
that matches what actually happened:

| Action | Meaning | Use when |
| ------ | ------- | -------- |
| `fest workflow reject --reason "..."` | The checkpoint was reviewed and rejected. The step is blocked and waits for a revision. | The work needs to be redone in place. |
| `fest workflow skip --reason "..."` | The step was completed by other means. It is treated as terminal. | The work is genuinely already done elsewhere and needs no revision loop. |
| `fest workflow reject --reason "..." --remediation-phase <PHASE>` | A gate did not pass; a remediation phase is linked to fix the underlying issues. The gate is logged as failed, not approved and not skipped. | A review gate found real blockers and a new phase was added to correct them. |

The remediation form keeps the trail honest. `fest next` routes into the remediation
phase, and once that phase completes, routes back to the failed gate for
re-evaluation, instead of silently passing it.

## Structured Feedback

Not every observation should block a step. `fest feedback` lets an agent record
observations against named criteria during execution, for a human to aggregate and
review afterward rather than in the middle of a checkpoint:

```bash
fest feedback init --criteria "Code quality" --criteria "Performance"
fest feedback add --criteria "Code quality" --observation "Found duplication in the parser"
fest feedback view
fest feedback export --format markdown
```

This separates "here is something worth noting" from "stop and approve this," so the
execution flow stays clean while quality signal still gets captured.

## Standalone Workflows

WORKFLOW.md is useful outside a festival too. A standalone workflow is a WORKFLOW.md in
any directory, with its own runtime so you can track repeated runs of the same process:

```bash
fest create workflow my-process   # scaffold a WORKFLOW.md and its runtime
fest workflow start               # begin a tracked run
fest workflow runs                # list runs
fest next                         # get the next step in the run
```

Each run records its own progress events, so a recurring process (a release checklist,
a review routine) keeps a clean history per execution.

## Why It Matters

Tasks cover the work that can be written down in advance. Workflows and gates cover the
work that cannot: the thinking-heavy phases and the quality checks that decide whether
work is actually done. They are what let you hand a phase to an agent, walk away, and
trust that it either reaches the goal or stops at a checkpoint and asks.
