---
title: "Claude Code Project Management"
description: "Use Festival with Claude Code to give AI coding sessions durable project state, next tasks, progress tracking, and traceable commits."
weight: 37
---

# Claude Code Project Management

Claude Code is effective at editing real codebases. Festival gives Claude Code a durable project structure so long-running work does not depend on chat memory.

The pattern is simple: use Claude Code as the coding agent and Festival as the project state.

## What Festival Adds

Festival helps Claude Code sessions answer four questions quickly:

- What is the goal?
- What has already been done?
- What is the next task?
- How do we know this task is complete?

Without that structure, each new session has to infer the plan from files, commits, and conversation history. That is slow and error-prone.

## Add Festival To The Session Instructions

In a repo that uses Festival, tell Claude Code to start with the Festival loop:

```text
Run fest intro on first contact. Use fest next to get the next task.
Follow the task acceptance criteria. When complete, run the requested checks,
mark the task completed, and commit with fest commit.
```

That instruction gives the agent a repeatable operating model.

## Use `fest next` As The Task Source

The agent should not invent the next task when the project already has a festival. It should run:

```bash
fest next
```

The task output includes the work item, surrounding context, and completion expectations. This reduces the amount of repo-wide scanning needed at the start of each session.

## Commit With Traceability

Inside an active festival, use:

```bash
fest commit -m "implement import validation"
```

Festival commits tie changes back to the plan, which makes review and status tracking easier. A future session can inspect progress without reverse-engineering intent from a loose commit history.

## Recommended Claude Code Flow

1. Start the session in the camp or project workspace.
2. Run `fest intro` if this is the first Festival session.
3. Run `fest next`.
4. Let Claude Code execute the task.
5. Run the task's validation commands.
6. Mark the task complete.
7. Commit with `fest commit`.
8. Run `fest next` again.

## Use Festival With Other Agents Too

This pattern is not Claude-specific. Festival works with any agent that can run shell commands and read files. That makes it useful when you switch between Claude Code, Codex, OpenCode, Crush, Cursor Agents, or custom automation.

Next: read [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) or start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}).
