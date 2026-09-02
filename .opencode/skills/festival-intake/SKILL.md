---
name: festival-intake
description: Route work that is too large for a single chat into a structured plan. Use when the user describes a multi-step build, a migration, a rewrite, an audit, a refactor across many files, or a research question with several threads. Use when a goal would otherwise need step-by-step supervision across more than one session. Also use when the user says "plan this", "where do I start", "help me build X", "this is a big one", or hands over a spec, a ticket, or a document and asks what to do with it.
---

# Festival Intake

This is the front door. Every other camp skill assumes the user already
knows what a festival is. This one does not, and it must fire before they do.

When it fires, you owe the user the six steps below, in order. Do not skip
straight to creating things.

## Step 1: Size it out loud

Say which gear this is and why, in one line, before doing anything else. The
user learns the system has three gears by watching you pick one.

| Signal | Route |
| --- | --- |
| One file, one session, reversible | Answer in chat. Create nothing. |
| Linear, a handful of steps, one repo | `fest create workflow <name>` |
| Multi-phase, multi-repo, needs review gates, or outlives a session | `fest create festival` |

Most requests are the first row. Reaching for a festival on small work is a
failure mode, not thoroughness. When it is genuinely between two rows, pick the
smaller one and say you can promote it later.

## Step 2: Show the shape, then ask

Before scaffolding anything, present the proposed phases and the sequences under
each, and get a yes.

You already have everything you need to do this at that point in the
conversation, so it costs nothing. It is the user's one chance to redirect
before work gets written to disk, and it is what makes the rest of the run
trustworthy.

## Step 3: Plan through the loop, not by scaffolding

Create the festival, then drive `fest next` and answer what it asks.

Do **not** scaffold every phase and sequence up front and fill in the
`[REPLACE]` markers afterward. That path looks faster and is the single worst
thing you can do to a festival:

- Scaffolding ten sequences at once writes hundreds of unfilled markers.
- `fest validate` drops to 0 the moment they exist, and stays there.
- The pressure is then to fill markers with plausible filler to restore the
  score, which produces a green festival full of worthless tasks.

`fest next` walks you through planning one decision at a time and never opens
that window. The loop is the planning process, not just the execution process.

## Step 4: Plan the full scope

Plan the whole feature. Do not quietly trim scope to make the plan look
achievable, and do not defer the hard parts to a "phase 2" you invented.

If the work is genuinely too big, say so and plan it anyway. Scaling down is the
user's decision to make against a complete plan, not yours to make by writing a
smaller one.

## Step 5: Write tutorial-grade tasks

A task document is written for an agent that has none of this conversation's
context. Assume the reader knows the codebase and nothing else.

Every task should name the files it touches, state the expected behavior
including error paths, and cite real `file:line` anchors you have actually
opened. Do not write anchors that sound plausible; verify them.

`fest validate` scores structure, not substance. A festival full of one-line
tasks validates at 100. Nothing will catch a thin task except you.

## Step 6: Execute with traceability

- Commit with `fest commit` while executing a festival, never `camp commit`.
- One worktree per repo the festival touches.
- Mark tasks with `fest task completed` as you go, so `fest next` stays correct.

## Where to go next

| You are | Read |
| --- | --- |
| Choosing structure and types | `fest-planning` skill, `fest understand planning` |
| Running an existing festival | `fest-execution` skill, `fest understand loop` |
| Doing the linear version | `fest-standalone-workflows` skill |
| Unsure where a document belongs | `campaign-structure` skill |
| About to commit | `campaign-commit` skill |

`fest understand` is the methodology in full. Read topics as you need them
rather than all at once.
