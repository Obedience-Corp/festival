# Festival

[![Release](https://img.shields.io/github/v/release/Obedience-Corp/festival?display_name=tag)](https://github.com/Obedience-Corp/festival/releases/latest)
[![Docs](https://img.shields.io/badge/docs-docs.fest.build-1f6feb)](https://docs.fest.build)
[![License](https://img.shields.io/github/license/Obedience-Corp/festival)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Obedience-Corp/festival?style=social)](https://github.com/Obedience-Corp/festival/stargazers)

![Festival Banner](docs/images/festival_banner.png)

**Long-running AI coding work you can trust.**

Festival is a system for running AI coding missions end-to-end: intents become specs, specs become plans, plans break into tasks with explicit done criteria, and every commit ties back to the task it satisfies. One workspace holds every repo, doc, and decision the mission touches, so any agent can resume with `fest next` and any human can audit what shipped and why.

- specs, plans, and tasks live in local files — never chat, never a dashboard
- every task has explicit done criteria before work starts
- every commit traces back to the plan it satisfies
- any session resumes exactly where the last one left off
- all related repos sit inside one auditable workspace

Use it with Claude Code, Codex, Cursor, OpenCode, Aider, Gemini CLI, or any agent that can read files and run shell commands.

**One install. Two command groups.**

`camp` organizes the mission workspace.

`fest` runs the execution plan.

## Contents

- [60-second example](#60-second-example)
- [Why Festival](#why-festival)
- [Who Festival Is For](#who-festival-is-for)
- [What Festival Is Not](#what-festival-is-not)
- [Real Example](#real-example)
- [Install](#install)
- [How Festival Works](#how-festival-works)
- [Claude Code Plugin](#claude-code-plugin)
- [Documentation](#documentation)

## 60-second example

```bash
# Create a mission workspace
camp init billing-redesign
cd billing-redesign

# Add the repos involved in the work
camp project add https://github.com/acme/api
camp project add https://github.com/acme/web
camp intent add "Redesign billing flow across API and web"

# Create an execution plan
fest create festival --name billing-redesign --type standard
fest validate

# Work the plan
fest next
fest task completed
fest commit -m "implement billing session creation"
fest next
```

`fest next` is the magic moment. It gives the agent the next task, surrounding context, workflow order, and completion criteria:

```text
$ fest next

Next task: Implement billing session creation
Phase: 002-api-contract
Sequence: 001-session-lifecycle
Linked project: projects/api
Why: Web checkout cannot proceed until the API creates durable billing sessions.

Done when:
  - POST /billing/session exists
  - expired sessions are covered by tests
  - duplicate session creation is idempotent
  - commit references this festival task

Relevant context:
  - docs/billing/stripe-contract.md
  - festivals/active/billing-redesign/decisions/session-ids.md
  - prior task: 001-session-schema
```

The loop is simple:

```text
fest next -> do the work -> fest task completed -> fest commit -> fest next
```

Tomorrow, the next agent starts there instead of reconstructing the mission from chat.

## Why Festival

Autonomous AI execution only earns trust when there's a real audit trail.

Without one, long-running AI work falls apart in predictable ways:

- specs live in chat and get lost between sessions
- tasks complete without explicit done criteria, so "done" is whatever the agent decided
- commits ship with no durable link back to the spec that asked for them
- multi-repo work scatters across folders with no shared mission state
- new sessions reconstruct goals and decisions from half-remembered context

Festival makes the whole loop explicit and auditable. Specs, plans, tasks, done criteria, reviews, and commits all sit on disk, ordered, validated, and tied together — so humans can verify what shipped against which spec, and agents can resume without guessing.

## Who Festival Is For

Festival is built for teams that need AI coding work to be:

- **trustworthy** — every task has done criteria before work starts
- **auditable** — every commit traces back to the plan it satisfies
- **resumable** — any agent picks up with `fest next` across sessions and repos
- **spec-driven** — intents and design docs drive execution, not chat threads
- **local-first** — files and Git, not a hosted dashboard
- **multi-repo** — one mission holds every repo, doc, and decision it touches

## What Festival Is Not

Festival is not:

- a hosted dashboard
- an agent runtime or orchestrator
- a prompt pack
- a Jira replacement
- a generic todo list
- a Claude-only tool

Use an orchestrator if you want to supervise parallel agents. Use Festival when those agents need durable mission context and an execution plan they can actually resume.

## Real Example

This is a real Obedience Corp campaign workspace for a multi-repo platform and product stack:

```text
obey-campaign/
├── projects/                     # 19 project submodules
│   ├── camp/                     # Campaign CLI
│   ├── fest/                     # Festival planning CLI
│   ├── festival/                 # Distribution repo
│   ├── obey-platform-monorepo/   # Core platform
│   ├── obey-chat/                # Chat client
│   ├── guild-core/               # Reference implementation
│   ├── obediencecorp.com/        # Company website
│   ├── prototypes/               # Experiment sandbox
│   └── ...                       # 11 more projects
├── festivals/                    # Execution plans
│   ├── planning/
│   ├── active/
│   ├── ready/
│   ├── ritual/
│   └── dungeon/
├── workflow/                     # Intents, reviews, pipelines
├── ai_docs/                      # AI research and documentation
├── docs/                         # Human-authored documentation
└── CLAUDE.md                     # Agent instructions
```

Every project, plan, and piece of context for the mission lives in one local workspace.

## Install

**macOS**

```bash
brew install --cask Obedience-Corp/tap/festival
```

**Arch Linux**

```bash
yay -S festival-bin
```

**Debian/Ubuntu**: download the `.deb` from [releases](https://github.com/Obedience-Corp/festival/releases/latest)

**Windows**: use WSL2 while native package support is being hardened

## Requirements

- `git` is required because `camp` and `fest` use it for workspace init, project management, template sync, and commit-aware workflows
- `scc` is recommended but optional; without it, `camp leverage` features will not work

After installing, start with the [quick start guide](https://docs.fest.build/getting-started/quickstart/) and get to your first `fest next` in a few minutes.

## How Festival Works

Festival is one product with two command groups.

### `camp`: organize the mission workspace

`camp` manages campaigns: isolated workspaces that hold all the projects, docs, research, and planning for a single mission.

- create a workspace
- add related repos as projects
- capture intents before planning
- jump across repos and workspace folders without path hunting

### `fest`: run the execution plan

`fest` manages festivals: structured plans that break work into phases, sequences, and tasks.

- turn goals into execution-ready work
- give agents the next scoped task with context
- validate plans before execution
- mark tasks complete
- commit work with task traceability

Festival is a planning and context layer, not a runtime orchestrator. It does not spawn agents or manage their processes. It gives agents and humans the structure, context, done criteria, and durable state needed to keep long-running work coherent.

Festival is designed for agentic coding workflows with Claude Code, Codex, Cursor, OpenCode, Aider, and other AI coding agents. It uses local files, Markdown, Git, and CLI commands to preserve persistent context, task state, project memory, specs, docs, and audit trails across multi-repo software projects.

## Claude Code Plugin

Install the Festival plugin for Claude Code to get `fest` and `camp` CLI tools, slash commands, methodology skills, and specialized agents in one step:

```bash
claude plugin add --source git-subdir --url Obedience-Corp/festival --path claude-plugin
```

If `fest` and `camp` are not already installed, the plugin installs them automatically on first session. It also checks for updates once per day and notifies you when a new release is available.

### What you get

| Component | Examples |
|---|---|
| Slash commands | `/fest-next`, `/fest-create`, `/fest-commit`, `/fest-validate`, `/fest-status`, `/fest-show`, `/fest-understand`, `/camp-intent`, `/camp-init` |
| Skills | Auto-activating methodology knowledge, execution workflows, planning guidance |
| Agents | `fest-planner` for designing festivals, `fest-executor` for working through tasks |

## Documentation

Full documentation lives at **[docs.fest.build](https://docs.fest.build)**.

- [Quick Start](https://docs.fest.build/getting-started/quickstart/)
- [Methodology Overview](https://docs.fest.build/methodology/overview/)
- [Agent Workflows](https://docs.fest.build/guides/agent-workflows/)
- [Using Festival with Claude Code](https://docs.fest.build/guides/using-festival-with-claude-code/)
- [Using Festival with Codex](https://docs.fest.build/guides/using-festival-with-codex/)

## License

[Functional Source License 1.1 (FSL-1.1-ALv2)](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com). AI that does what you want, the way you want it done.
