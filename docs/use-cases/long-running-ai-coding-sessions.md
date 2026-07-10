---
title: "Long-Running AI Coding Sessions"
description: "Use Festival to keep long-running AI coding sessions coherent across context windows, interruptions, handoffs, and verification steps."
weight: 36
---

# Long-Running AI Coding Sessions

AI coding agents are strongest when the next step is clear. They are weakest when every session starts by rediscovering the project, reconstructing the plan, and guessing what already happened.

Festival is designed for coding work that lasts longer than one prompt or one chat window.

## Why Long-Running Sessions Fail

Long-running AI-assisted work usually fails for practical reasons:

- the plan lives in chat history instead of the repo
- the next task is ambiguous
- acceptance criteria are missing
- prior decisions are not written down
- verification commands are forgotten
- commits are not tied back to the plan
- a new agent session has to rebuild context from scratch

The result is friction. The agent spends too much time orienting and too little time executing.

## Festival Stores the Work Where Agents Can Read It

Festival keeps work state in files:

```text
festivals/
  active/
    release-readiness-RR0001/
      FESTIVAL_GOAL.md
      FESTIVAL_OVERVIEW.md
      TODO.md
      001_INGEST/
      002_PLAN/
      003_IMPLEMENT/
```

That structure survives tool changes, session resets, model changes, and context limits.

## Resume With One Command

When a session starts, the agent can run:

```bash
fest next
```

The response tells it what to do next and includes the context needed to start. The agent does not need to load the whole workspace or ask the human to summarize everything again.

## Keep Verification Attached To The Work

Long-running work needs more than a checklist. Each task can specify:

- files to inspect or modify
- acceptance criteria
- commands to run
- expected outputs
- review notes
- cleanup requirements

That makes the final work easier to review because the task and the commit history tell the same story.

## Example Workflow

```bash
fest create festival --name docs-launch --type standard
fest validate
fest next

# agent works the current task
just docs build
fest task completed
fest commit -m "add launch docs"

fest next
```

When you stop, the state is still in the festival. When you return, `fest next` resumes the loop.

## When To Use This Pattern

Use Festival when the work has:

- more than one meaningful step
- multiple files or repos
- a plan that may change
- verification requirements
- a handoff between sessions, humans, or tools

For the complete loop, read [Agent Workflows]({{< ref "/guides/agent-workflows" >}}).
