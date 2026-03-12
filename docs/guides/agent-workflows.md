---
title: "Agent Workflows"
weight: 31
---

# Agent Workflows

How to use Festival Methodology with AI agents for autonomous development sessions.

---

## Why Festival for AI Agents

AI coding agents are powerful but stateless. Every session starts from zero - the agent doesn't know what was planned, what's already done, or what comes next. Without structure, you get duplicated work, missed steps, and sessions that spend half their context window figuring out where they are.

Festival solves this by putting all project state in the filesystem. Plans, progress, and context are markdown files that any agent can read. There is no external database, no API, and no proprietary format. An agent that can run bash commands and read files can use Festival immediately.

The key properties that make this work:

- **Context management** - Work is broken into tasks sized to fit within agent context windows. No task requires loading the entire project state.
- **Resumable sessions** - `fest next` tells any new agent exactly what to do next, with full context included inline.
- **Just-in-time context** - Agents load only what they need for the current task. Phase goals, sequence context, and task documents are served on demand.
- **Progress tracking** - `fest status` shows what's done, what's in flight, and what remains. No guessing.
- **Methodology on demand** - `fest intro` and `fest understand` teach agents the system without upfront context dumps. The agent learns what it needs, when it needs it.

---

## The Agent Loop

The typical agent workflow is a tight loop:

```
fest intro   → Agent learns the methodology (first session only)
fest next    → Gets next task with full context, executes it (repeat)
```

`fest next` is the entire loop. It returns the next task with full inline context, and the task document itself tells the agent what commands to run when done -- `fest task completed`, `fest commit`, quality gates, whatever the task requires. The agent reads the task, does the work, follows the completion steps, and runs `fest next` again.

On first contact, run `fest intro` once. After that, an agent can run `fest next` indefinitely across multiple sessions without losing state.

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

`fest next` is the most important command. Its output includes everything an agent needs to start working - the task document content, the phase it belongs to, and the overall festival goal. No additional file reads required.

---

## Working with Claude Code

Claude Code is the primary development environment for Festival workflows. These patterns have been tested extensively.

**Add festival instructions to CLAUDE.md.** Include a line telling the agent to run `fest intro` at the start of sessions and use `fest next` for task assignment. This eliminates the "what should I work on?" problem.

**Use `fest next` output directly.** The output is structured markdown designed for agent consumption. It includes the task document, acceptance criteria, and surrounding context. Paste it into the conversation or let the agent run the command itself.

**Use `fest commit` instead of raw `git commit`.** Festival commits include metadata that traces changes back to specific tasks and sequences. This makes progress tracking and review significantly easier. `fest commit -m "message"` handles staging and syncing automatically.

**Use `fest understand` instead of reading source docs.** Agents don't need to load methodology documentation files. `fest understand workflow` or `fest understand tasks` delivers exactly what the agent needs, formatted for consumption, without burning context on full documents.

**Capture session state in CONTEXT.md.** When ending a session, write decisions, open questions, and partial progress into the festival's CONTEXT.md file. The next session picks this up and continues without re-deriving context.

---

## Working with Other Agents

Festival is tool-agnostic. Any agent that can run bash commands can use it.

There is no API integration required. Everything is bash commands and markdown files:

- `fest next` returns a task. The agent reads it and works.
- `fest task completed` marks progress. The agent moves on.
- `fest status` shows the state of the world. The agent orients itself.

The filesystem IS the state. Task documents are markdown files. Progress is tracked by file location and status markers. An agent reads task documents, writes code, and records completion - all through standard file operations and CLI commands.

This means Festival works the same way regardless of which AI tool is driving the session. Switch tools mid-festival and nothing breaks. The state is in the files, not in any tool's memory.

---

## Session Handoff

The hardest problem in agent workflows is handoff - when one session ends and another begins. Festival makes this explicit rather than hoping context survives.

**`fest status`** shows exactly where work stands. Which phases are complete, which sequences are in progress, which tasks remain. A new agent reads this and knows the full picture in seconds.

**`fest next`** picks up the next incomplete task automatically. No manual searching through directories or reading status files. The agent gets a task with full context and starts working immediately.

**`fest context`** provides full context for the current location. If an agent needs to understand where it is in the festival hierarchy - what phase, what sequence, what the goals are - this command delivers it.

**CONTEXT.md files** capture decisions and rationale across sessions. Why was this approach chosen? What alternatives were considered? What gotchas were discovered? This is the institutional memory that prevents the next session from re-learning hard-won lessons.

Nothing is lost between sessions. The plan is in the filesystem. The progress is in the filesystem. The context is in the filesystem. A new agent session with `fest next` is fully operational in under 30 seconds.

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
