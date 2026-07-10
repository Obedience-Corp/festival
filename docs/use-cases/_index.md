---
title: "Use Cases"
description: "Practical ways to use Festival for AI agent project management, long-running coding sessions, handoffs, and structured AI-assisted software work."
weight: 35
---

Festival is for AI-assisted software work that needs more structure than a chat thread, a task list, or a one-off prompt.

These pages describe the common situations where Festival helps: keeping agent sessions coherent, handing work between tools, tracking progress across repos, and turning broad goals into executable steps.

<div class="doc-index__list">
  <a class="doc-index__item" href="/use-cases/ai-agent-project-management/">
    <strong>AI Agent Project Management</strong>
    <span>Plan, execute, and resume AI-assisted work without losing project state.</span>
  </a>
  <a class="doc-index__item" href="/use-cases/long-running-ai-coding-sessions/">
    <strong>Long-Running AI Coding Sessions</strong>
    <span>Keep multi-day or multi-week coding work coherent across context windows.</span>
  </a>
  <a class="doc-index__item" href="/use-cases/claude-code-project-management/">
    <strong>Claude Code Project Management</strong>
    <span>Use Festival with Claude Code while keeping plans, tasks, and commits traceable.</span>
  </a>
  <a class="doc-index__item" href="/use-cases/ai-agent-handoff/">
    <strong>AI Agent Handoff</strong>
    <span>Let a new agent session pick up the next task without reconstructing the whole project.</span>
  </a>
</div>

## When Festival Fits

Festival fits best when the work has more than one step and correctness depends on remembering decisions:

- a feature that touches multiple files or repos
- a refactor that needs planning, staged execution, and verification
- a launch checklist with docs, release, and follow-up tasks
- a codebase cleanup that should not be rediscovered every session
- a research or design effort that needs to become implementation work

If the task is a single prompt or a quick edit, you may not need Festival. If the work will outlive one chat window, Festival gives it a durable home.

## Start Here

Install Festival, create a campaign workspace, then create your first festival:

```bash
brew install --cask Obedience-Corp/tap/festival
camp init my-project
cd my-project
fest create festival --name first-feature --type standard
fest next
```

For the full path, read the [Quick Start]({{< ref "/getting-started/quickstart" >}}).
