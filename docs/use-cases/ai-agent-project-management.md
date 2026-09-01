---
title: "AI Agent Project Management"
description: "Use Festival as a project management layer for AI agents: goals, phases, tasks, context, progress, and verification stored in your workspace."
weight: 35
---

# AI Agent Project Management

AI agents can write code, investigate bugs, draft plans, and edit docs quickly. The hard part is keeping that work organized once it spans multiple sessions, repositories, decisions, and review steps.

Festival is a project management layer for AI-assisted work. It does not replace your coding agent. It gives the agent a structured workspace it can read and update.

## The Problem

Most AI coding work starts in a chat:

1. Explain the goal.
2. Add context about the repo.
3. Ask for a plan.
4. Execute part of the plan.
5. Run out of context or stop for the day.
6. Re-explain everything in the next session.

That loop breaks down on real projects. The agent forgets prior decisions, duplicates work, misses verification steps, or implements an old version of the plan.

## The Festival Model

Festival turns project work into a filesystem-backed plan:

- **Camps** hold related repos, docs, plans, and research.
- **Festivals** define a goal and the work needed to reach it.
- **Phases** group work by stage, such as ingest, plan, implement, review, or release.
- **Sequences** group related tasks.
- **Tasks** describe executable units of work with acceptance criteria and verification.

The agent does not need a database or proprietary integration. It needs shell access and file access.

## The Agent Loop

The core loop is intentionally small:

```bash
fest next
# agent reads the task, edits files, runs checks
fest task completed
fest commit -m "implement feature step"
fest next
```

`fest next` gives the agent the next incomplete task with surrounding context. `fest status` and `fest progress` show what is done, what is in flight, and what remains.

## Why This Is Different From a Task List

A normal task list says what should happen. Festival also captures the structure around why it should happen and how to verify it:

- the overall goal
- phase context
- task acceptance criteria
- quality gates
- command-line workflow
- commit traceability
- handoff notes and status

That extra structure matters when a different AI session, a different model, or a human reviewer picks up the work later.

## Good Fits

Use Festival for:

- multi-step coding tasks
- cross-repository changes
- refactors with staged verification
- launch readiness work
- documentation and release workflows
- agent-led cleanup efforts
- human-reviewed implementation plans

Do not reach for Festival for every tiny edit. It is most useful when work has enough shape that losing context would be expensive.

## Start With a Campaign

```bash
camp init my-product
cd my-product
camp project add https://github.com/you/api
fest create festival --name auth-system --type standard
fest next
```

Next: follow the [Quick Start]({{< ref "/getting-started/quickstart" >}}) or read [Agent Workflows]({{< ref "/guides/agent-workflows" >}}).
