---
title: "Using Festival with Claude Code"
weight: 34
---

# Using Festival with Claude Code

Festival works well with Claude Code because it keeps the mission state in local files instead of in chat history.

Claude Code is strong inside a session. Festival helps when the work spans multiple repos, multiple days, and multiple handoffs.

## Fastest path

1. Install Festival.
2. Add the Festival Claude Code plugin.
3. Create a workspace with `camp init`.
4. Create a plan with `fest create festival`.
5. Work the loop: `fest next`, do the work, `fest task completed`, `fest commit`.

## Install the plugin

```bash
claude plugin add --source git-subdir --url Obedience-Corp/festival --path claude-plugin
```

The plugin adds Festival commands, skills, and agents to Claude Code. If `camp` and `fest` are not already installed, the plugin installs them automatically on first session.

## Recommended Claude Code loop

```bash
fest intro
fest next
fest task completed
fest commit -m "finish the current task"
```

Use `fest intro` the first time an agent enters a Festival workspace. After that, `fest next` is usually enough to keep the work moving.

## Recommended commands

- `fest next`: get the next actionable task with context
- `fest context`: load more context for the current location
- `fest understand workflow`: teach the agent the workflow on demand
- `fest status`: orient a new session quickly
- `fest commit`: keep the commit tied to the plan

## Why this pairing works

Claude Code provides a strong editing and tool-use environment. Festival provides the persistent project memory layer Claude Code sessions can resume from.

That means less time re-explaining:

- what the mission is
- which repo matters next
- what "done" means for the current task
- what already happened in the previous session

For broader patterns, see [Agent Workflows]({{< ref "/guides/agent-workflows" >}}).
