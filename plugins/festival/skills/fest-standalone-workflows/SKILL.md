---
name: fest-standalone-workflows
description: Create and run lightweight standalone `WORKFLOW.md` loops with `fest create workflow`, `fest next`, and `fest workflow advance`. Use when a user wants step-by-step workflow guidance inside any ordinary directory, explore/design work item, project folder, or thin-start workflow.
---

# Fest Standalone Workflows

Use a standalone `WORKFLOW.md` when work needs a guided step loop in an ordinary
directory, without setting up a full festival (phases/sequences/tasks).

Thin-start loop:

```text
WORKFLOW.md -> fest next -> do step -> fest workflow advance -> repeat
```

## When to Use This vs. a Full Festival

- **Standalone workflow**: a short, repeatable checklist that can live in any
  directory: a code-review checklist, a release-cut runbook, a one-off
  investigation. Minimal ceremony, no phases/sequences.
- **Full festival**: multi-phase work that needs planning, sequencing, and
  quality gates over an extended effort. Use `fest create festival` instead
  (see the `fest-planning` skill).

## Create

Run from the directory that should own the workflow:

```bash
mkdir -p my-workflow && cd my-workflow

fest create workflow my-workflow --steps '{
  "title": "My Workflow",
  "description": "A lightweight guided loop.",
  "steps": [
    {
      "name": "PLAN",
      "goal": "Decide what needs to happen.",
      "actions": ["Write the goal.", "List the unknowns."],
      "checkpoint": "none"
    },
    {
      "name": "DO",
      "goal": "Do the work.",
      "actions": ["Make the change.", "Validate it."],
      "checkpoint": "verification"
    }
  ]
}'

fest next
```

This scaffolds `WORKFLOW.md`, initializes `.workflow/` runtime state, and
starts a tracked run, so `fest next` works immediately.

`fest workflow create <name>` is an alias of `fest create workflow <name>`
and accepts the same flags. Use whichever noun you reach for first.

For human interactive creation, run the command without `--steps` from a TTY:

```bash
fest create workflow my-workflow
```

It prompts for title, intent, and step lines in `Name|Goal` form.

## Flags

- `--steps '<json>'` / `--steps-file <file>`: agent mode, inline JSON or a
  JSON file. See the step schema below.
- `--agent`: strict agent mode (implies `--json`).
- `--type <type>`: standalone workflow type (default `task`).
- `--no-init`: advanced mode. Writes `WORKFLOW.md` only, without initializing
  `.workflow/` runtime state or starting a run. `fest next` still works in
  this mode, but reports the workflow as not-started; the first mutating
  command (`fest workflow advance`) bootstraps a tracked run lazily. Use this
  when you want to author the document before committing to a tracked run.
- `--path <dir>` / `--festival <root>`: target a festival phase instead of
  standalone mode. Inside a festival phase, or with either of these flags
  set, the command writes the phase's `WORKFLOW.md` with no standalone
  runtime, so do not pass these when you want a standalone workflow.

## Step JSON Contract

Workflow-level fields:

- `title` (required)
- `description` (optional)
- `steps` (required, non-empty)

Each step needs:

- `name`
- `goal`

Useful optional step fields:

- `actions`
- `output`
- `checkpoint`

Valid checkpoint values:

- `none`
- `verification`
- `documentation`
- `approval_required`

## Execution Loop

```bash
fest next
# do the visible step
fest workflow advance
fest next
```

## Common Mistakes

- Passing `--path` or `--festival` when creating a standalone workflow;
  those target a festival phase instead.
- Using `title` inside each step object. Step objects require `name` and
  `goal`, not `title`.
- Assuming `--no-init` is required before `fest next` will work. It is not:
  the default (no flag) already initializes runtime state and starts a
  tracked run in one step.
