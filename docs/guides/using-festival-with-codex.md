---
title: "Using Festival with Codex"
weight: 35
---

# Using Festival with Codex

Festival works with Codex because the state lives in files and shell commands, not in a hosted control plane.

Codex can read the workspace, run the CLI, edit code, and move forward with `fest next` just like any other AI coding agent.

## Fastest path

1. Install Festival so `camp` and `fest` are on your `PATH`.
2. Create a workspace with `camp init`.
3. Add the repos involved in the work with `camp project add`.
4. Create a plan with `fest create festival`.
5. Let Codex work from `fest next`.

## Recommended Codex loop

```bash
fest next
fest task completed
fest commit -m "finish the current task"
fest next
```

When Codex needs more context, use:

- `fest context`
- `fest status`
- `fest understand tasks`
- `fest understand workflow`

## Practical setup

Festival is especially useful in Codex sessions when:

- one goal touches more than one repo
- you want a durable next-task command instead of re-prompting
- you need handoff-ready local state between sessions

If you maintain repository instructions for Codex, tell it to use `fest next` for task pickup and `fest commit` for task-linked commits whenever it is inside a Festival workspace.

## Why this pairing works

Codex handles editing, tool use, and execution. Festival provides the durable mission state:

- workspace layout
- linked repos
- plan structure
- task context
- done criteria
- commit traceability

That makes Codex sessions easier to resume and easier to hand off.
