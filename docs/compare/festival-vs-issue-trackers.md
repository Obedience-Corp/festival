---
title: "Festival vs Issue Trackers"
description: "Compare Festival with GitHub Issues, Linear, Jira, and task lists for AI-assisted software work."
weight: 39
---

# Festival vs Issue Trackers

Issue trackers are good at recording what a team intends to do. Festival is built for turning a goal into executable work that an AI agent can pick up, verify, commit, and resume.

You may still use GitHub Issues, Linear, Jira, or a task list. Festival fills a different gap.

## Short Version

Use an issue tracker for prioritization, discussion, assignment, and team visibility.

Use Festival when the work needs structured execution:

- project-local context
- phase and task hierarchy
- agent-readable next steps
- acceptance criteria
- quality gates
- handoff notes
- commit traceability

## Comparison

| Need | Issue tracker | Festival |
|---|---|---|
| Team backlog | Strong | Not the primary job |
| Project discussion | Strong | Supported through docs, but not a comment system |
| AI agent next task | Usually ambiguous | `fest next` returns the next executable task |
| Context across sessions | Often scattered | Stored in the workspace |
| Multi-step execution | Manual coordination | Phases, sequences, and tasks |
| Verification | Usually checklist text | Task criteria plus gates and commands |
| Commit traceability | Manual conventions | `fest commit` ties work to the plan |
| Works without a hosted service | Usually no | Yes, filesystem plus git |

## Where Issue Trackers Break Down For Agents

An issue often describes a desired outcome, but an agent still needs to infer:

- which files matter
- what order to do the work in
- what prior decisions constrain the implementation
- how to verify each step
- what to do after the first subtask is complete

That inference burns context and creates risk. Festival makes the execution plan explicit.

## How They Work Together

A practical setup is:

1. Use GitHub Issues, Linear, or Jira for product backlog and team discussion.
2. Promote selected work into a Festival when it becomes AI-executable.
3. Use Festival to plan phases, sequences, tasks, gates, and verification.
4. Link commits and PRs back to the issue if needed.

The issue remains the team-level artifact. The festival becomes the execution artifact.

## When Festival Is Overkill

Do not create a festival for every tiny task. A one-line typo fix or a small isolated edit does not need the full structure.

Festival pays for itself when the work is large enough that losing context would cost more than writing the plan.

## Try It

```bash
camp init my-workspace
cd my-workspace
fest create festival --name issue-123-auth-refactor --type standard
fest next
```

Next: read [AI Agent Project Management]({{< ref "/use-cases/ai-agent-project-management" >}}) or start with the [Quick Start]({{< ref "/getting-started/quickstart" >}}).
