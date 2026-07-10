---
title: "AI Agent Handoff"
description: "Use Festival to hand off AI coding work between sessions, tools, and humans without losing plan context or next actions."
weight: 38
---

# AI Agent Handoff

AI agent handoff is the moment when one session stops and another session needs to continue the work. Without a durable handoff, the next agent spends time reconstructing what happened instead of moving the project forward.

Festival makes handoff explicit.

## The Handoff Problem

An AI coding session can end for many normal reasons:

- the context window fills up
- the human pauses work
- a different model or tool is needed
- a review finds new issues
- the work moves from planning to implementation

If the state only exists in conversation, the next session has to ask: what was the goal, what changed, what failed, what remains, and what should I do next?

## The Festival Handoff

Festival keeps handoff state in the workspace:

- `FESTIVAL_GOAL.md` describes the outcome.
- phase and sequence files describe where the work is.
- task files describe executable next steps.
- status commands show progress.
- commits preserve traceability.
- context notes capture decisions and open questions.

The next agent can start with:

```bash
fest status
fest next
```

That is enough to understand where the work stands and what to do next.

## What To Capture Before Ending A Session

Before stopping a long-running session, capture:

- decisions made
- rejected alternatives
- files changed
- checks run
- known failures
- unresolved questions
- the exact next task if it is not already represented

Put that context in the festival files instead of only in chat. The next session can then resume without a verbal briefing.

## Handoff Between Tools

Festival is not tied to one AI product. A task can be started by one tool and finished by another because the state is stored in the filesystem.

Example:

1. A planning session creates the festival.
2. Claude Code implements the first task.
3. Codex reviews the diff and updates tests.
4. A human validates the result.
5. The next agent runs `fest next`.

No tool owns the project state. The workspace does.

## A Good Handoff Checklist

Run these before you stop:

```bash
fest status
git status --short
```

Then make sure the task state matches reality:

- mark completed work with `fest task completed`
- leave incomplete work as incomplete
- record blockers in the task or context notes
- commit finished work with `fest commit`

Next: read [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) and [Workflows & Gates]({{< ref "/methodology/workflows-and-gates" >}}).
