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

Keep those answers in the work record so a later session can check them against the repository and continue the approved plan.

## Add Festival To The Session Instructions

Follow the [Claude Code setup guide]({{< ref "/getting-started/agents/claude-code" >}}) first. In a repo with an approved festival, give the agent its location and operating boundaries:

{{< agent-prompt >}}
Work on the approved festival at [path]. Run fest intro on first contact. From that festival or its linked project, use fest next to get the next task.

Read the referenced files and follow the acceptance criteria. Run the requested checks, record their results, and mark only finished tasks complete. Use fest commit for scoped festival changes. Stop at approval gates or when continuing needs new access, spending, deployment, or a change in scope.
{{< /agent-prompt >}}

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

1. Start the session in the active festival directory or its linked project.
2. Run `fest intro` if this is the first Festival session.
3. Run `fest next`.
4. Let Claude Code execute the approved task while you focus on other work.
5. Run the task's validation commands.
6. Mark the task complete.
7. Commit with `fest commit`.
8. Run `fest next` again, stopping at approval gates and recording blockers when work cannot continue.

## Use Festival With Other Agents Too

This pattern is not Claude-specific. Festival works with agents that can run shell commands and read files, including Grok build, Codex, OpenCode, Crush, Cursor Agents, and custom automation. Each tool still has its own permissions, runtime, and session limits. Festival keeps the work record available across those sessions; it does not host the agent process.

Next: read [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) or start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}).
