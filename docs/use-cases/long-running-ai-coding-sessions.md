---
title: "Long-Running AI Coding Sessions"
description: "Hand off a multi-session goal to an AI agent, review durable progress, and resume work from the saved Festival record."
weight: 36
---

# Long-Running AI Coding Sessions

Some goals take several sessions: refactors, release preparation, or features
that need review. Hand the agent a bounded
piece of the goal, return to your other work, then review or resume from the
written record. Festival keeps that record in the camp. It does not run agents,
schedule work, or control permissions.

Begin with the [Quick Start]({{< ref "/getting-started/quickstart" >}}) to
create the camp, set up the agent, and review a festival plan.

## Make a handoff that can survive a pause

After you approve the plan, tell the agent to work from the festival's linked
project or worktree, follow the next recorded task, and stop at a human decision
or authority boundary.

{{< agent-prompt >}}
Work on the approved festival for [goal] from its linked project or worktree.
Start by reading the current festival state and run `fest next` to get the next
task. Complete only work covered by the task and its acceptance criteria. Run
the planned checks, record results and blockers in the festival, and use the
project's review and commit process.

Stop and ask me before a scope change, a destructive action, an external
message, a production change, or any approval gate. At the end of this session,
leave the task state accurate so another session can continue.
{{< /agent-prompt >}}

You can leave the agent to work within that boundary, then review when it
returns with a completed task, a failed check, or a question. The runtime that
hosts the agent decides how long it runs and which commands, repositories,
networks, or credentials it can access. Festival records the work and supplies
the next task, but it does not grant access or keep work running after the agent
session ends.

## Resume the goal, not the old conversation

Open the active festival or its linked project or worktree and review the state:

```bash
fest status
fest next
```

`fest next` is context-aware in an active festival and its linked working
directory. It returns the next planned task after the earlier task state has
been recorded. If the agent stopped partway through a task, inspect the task,
the changed files, the check output, and any context notes before deciding
whether to continue, revise the plan, or mark a blocker.

The durable record includes the festival goal, phase and task files, decisions,
verification evidence, and `FESTIVAL_TODO.md`. Keep open questions and failed
checks there or in the relevant task instead of relying on chat history. A new
agent session can then work from the same evidence without inheriting the old
conversation.

## Review at meaningful boundaries

Review after a planned phase, a risky change, or a result that changes the
original decision. Compare the work against the approved outcome and acceptance
criteria, inspect the verification evidence, and decide whether to approve the
next phase. If the goal no longer makes sense, stop or revise the festival
instead of asking the agent to continue on an obsolete plan.

[Agent Workflows]({{< ref "/guides/agent-workflows" >}}) explains the task
loop. [AI Agent Handoff]({{< ref "/use-cases/ai-agent-handoff" >}}) covers
what to capture when a person or tool changes mid-goal.
