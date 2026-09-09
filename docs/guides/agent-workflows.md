---
title: "Agent Workflows"
description: "Give an agent a goal, run the fest next loop, verify its work, and preserve decisions for the next session or tool."
weight: 31
---

# Agent Workflows

How to use Festival Methodology with AI agents for autonomous development sessions.

---

## Why Festival for AI Agents

Hand off an approved goal, let the agent work, and return to a result you can inspect. Festival keeps the plan, decisions, progress, and checks alongside the work, so that handoff can extend across sessions and tools.

Plans and context are Markdown files; the CLI records progress in the workspace. An agent with shell and file access can use that record without a Festival API integration. For a first handoff, follow the [Quick Start]({{< ref "/getting-started/quickstart" >}}).

The key properties that make this work:

- **Context management** - Break work into scoped tasks with relevant instructions and references.
- **Resumable sessions** - `fest next` supplies the next recorded step and its planning context.
- **Just-in-time context** - Agents load only what they need for the current task. Phase goals, sequence context, and task documents are served on demand.
- **Progress tracking** - `fest status` shows recorded completion and remaining work. Keep it aligned with the actual results.
- **Methodology on demand** - `fest intro` and `fest understand` teach agents the system without upfront context dumps. The agent learns what it needs, when it needs it.

---

## The Agent Loop

The typical agent workflow is a tight loop:

```text
fest next → agent reads and executes → checks and review → record progress → repeat
```

Run this loop from the active festival directory or a project linked to it. `fest next` supplies guidance; your agent and its tools execute the work. The task document describes the deliverable and checks. The agent reads the relevant files, completes the work, follows the completion instructions, records progress, and requests the next step.

On first contact, run `fest intro`. Review the plan and permissions before execution, and stop at approval gates or when scope changes. Agent runtime limits, credentials, and background execution belong to the agent tool, not `fest next`.

Use `fest watch` to see recorded task progress. This CLI recording demonstrates the display with scripted sample progress:

{{< terminal-demo src="/images/demos/tui-fest-watch.gif" poster="/images/demos/tui-fest-watch-poster.png" title="fest watch" alt="The fest watch TUI updating as scripted sample tasks are marked complete" max="640" >}}

Separate agent sessions can work on different festivals and worktrees in parallel. Use `fest show` to inspect the work graph. See [Loops & Orchestration]({{< ref "/guides/loops-and-orchestration" >}}) for the agent's outer loop, recurring workflows, and review gates.

---

## fest as a Guidance System

These are the commands agents use most. They are designed to return agent-readable output - structured markdown that can be consumed directly as context.

| Command | Purpose |
|---|---|
| `fest intro` | Getting started guide. First thing any agent should run in a new festival. |
| `fest understand [topic]` | Deep dive into methodology concepts: `methodology`, `structure`, `tasks`, `workflow`, etc. |
| `fest context` | Get context for current location - phase, sequence, or task. |
| `fest next` | Get the next incomplete task with full inline context: task document, phase goal, festival goal. |
| `fest status` | Overview of festival progress - phases, sequences, completion percentages. |
| `fest progress` | Detailed progress breakdown across the entire festival. |
| `fest task completed` | Mark the current task as done. |
| `fest commit -m "msg"` | Git commit with festival metadata for traceability. |

`fest next` brings the task and surrounding goals into the agent's context. The agent still reads referenced code, project instructions, evidence, and other files needed to do the task correctly.

---

## Working with Claude Code

The [Claude Code setup guide]({{< ref "/getting-started/agents/claude-code" >}}) covers integration. Once configured:

**Add festival instructions to CLAUDE.md.** Tell the agent where the festival is, to run `fest intro` on first contact, and to use `fest next` for task guidance. Include the review and permission boundaries.

**Use `fest next` output directly.** The output is structured markdown designed for agent consumption. It includes the task document, acceptance criteria, and surrounding context. Paste it into the conversation or let the agent run the command itself.

**Use `fest commit` for festival work.** Its metadata ties the change to the plan. Inspect the diff and stage only the intended files; use the [commit options]({{< ref "/cli-reference/fest/fest_commit" >}}) to control staging and synchronization in a shared working tree.

**Use `fest understand` for focused guidance.** Commands such as `fest understand workflow` or `fest understand tasks` explain the relevant methodology without requiring the whole manual.

**Capture session state in CONTEXT.md.** Before ending a session, record decisions, open questions, failed checks, and partial progress. Tell the next session where to find those notes.

---

## Working with Other Agents

Festival is tool-agnostic. Any agent that can run bash commands can use it.

There is no API integration required. Everything is bash commands and markdown files:

- `fest next` returns a task. The agent reads it and works.
- `fest task completed` marks progress. The agent moves on.
- `fest status` shows the state of the world. The agent orients itself.

The filesystem IS the state. Task documents are markdown files. Progress is tracked by file location and status markers. An agent reads task documents, writes code, and records completion - all through standard file operations and CLI commands.

The shared work record stays available when you switch tools. The receiving agent still needs compatible file access, project instructions, and permission to run the required checks. See [agent setup]({{< ref "/getting-started/agents" >}}) for the supported integration paths.

---

## Session Handoff

The hardest problem in agent workflows is handoff - when one session ends and another begins. Festival makes this explicit rather than hoping context survives.

**`fest status`** reports phase, sequence, and task progress. Check that the recorded status matches the working tree and latest verification results.

**`fest next`** identifies the next incomplete step and supplies its planning context. Read the task and referenced files before continuing.

**`fest context`** provides full context for the current location. If an agent needs to understand where it is in the festival hierarchy - what phase, what sequence, what the goals are - this command delivers it.

**CONTEXT.md files** capture decisions and rationale across sessions. Why was this approach chosen? What alternatives were considered? What gotchas were discovered? This is the institutional memory that prevents the next session from re-learning hard-won lessons.

Festival preserves what you record. Leave incomplete work marked incomplete, capture blockers, and note the next action before stopping. The [handoff checklist]({{< ref "/use-cases/ai-agent-handoff" >}}) is a useful final check for both the outgoing agent and the reviewer.

---

## Customizing Templates

When `fest create` scaffolds a festival, phase, sequence, or task, it copies markdown templates from the `.festival/templates/` directory inside your festivals workspace.

```
festivals/.festival/templates/
├── festival/              # Festival-level documents
│   ├── GOAL.md            # FESTIVAL_GOAL.md template
│   ├── OVERVIEW.md        # FESTIVAL_OVERVIEW.md template
│   ├── RULES.md           # FESTIVAL_RULES.md template
│   └── TODO.md            # FESTIVAL_TODO.md template
├── phases/                # Phase templates by type
│   ├── implementation/
│   ├── planning/
│   ├── research/
│   ├── review/
│   ├── ingest/
│   └── non_coding_action/
├── sequences/             # Sequence goal templates
│   ├── GOAL.md
│   └── GOAL_MINIMAL.md
└── tasks/                 # Task document template
    └── TASK.md
```

These are your templates. Edit them to match your workflow, coding standards, and team conventions. Changes apply to every new festival, phase, sequence, or task created after the edit.

**Common customizations:**

- **FESTIVAL_RULES.md** - Add your team's coding standards, test coverage requirements, and review criteria so every new festival inherits them automatically.
- **TASK.md** - Add sections your agents need (e.g., "Files to modify", "Commands to verify", "Dependencies") so task authors fill them in consistently.
- **Phase templates** - Adjust the default gate structure or add phase-specific sections for your domain (security review gates, performance benchmarks, etc.).

Templates use `[REPLACE: hint]` markers for values that must be filled in during creation. `fest` processes these markers interactively or via `--markers` flags. See `fest understand templates` for the full marker system.
