# Festival

[![Release](https://img.shields.io/github/v/release/Obedience-Corp/festival?display_name=tag)](https://github.com/Obedience-Corp/festival/releases/latest)
[![Docs](https://img.shields.io/badge/docs-docs.fest.build-1f6feb)](https://docs.fest.build)
[![License](https://img.shields.io/github/license/Obedience-Corp/festival)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/Obedience-Corp/festival?style=social)](https://github.com/Obedience-Corp/festival/stargazers)

![Festival Banner](docs/images/festival_banner.png)

**Persistent multi-repo workspace for AI coding agents.**

AI coding tools work well inside one session. They get brittle when work spans days, repos, docs, research, plans, commits, reviews, and handoffs.

Festival keeps the mission on disk:

- all related repos in one workspace
- docs, research, and decisions beside the code
- execution plans agents can resume with `fest next`
- completion criteria and review notes for every task
- commits tied back to the plan

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
- [How Festival Compares](#how-festival-compares)
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

AI agents do not just lose context. They lose the mission.

Real software work is not one prompt and one repo. It is:

- backend, frontend, infra, docs, and scripts living in different repos
- requirements scattered across chats, notes, issues, and old decisions
- new sessions asking "what are we doing again?"
- agents completing tasks without preserving why the task mattered
- commits existing without a durable link back to the plan

Festival adds the missing project-memory layer: local files, structured execution state, and traceable commits that survive sessions and handoffs.

## Who Festival Is For

Festival is useful when:

- one goal touches multiple repos
- work spans days or weeks instead of one session
- agents need to pause, resume, or hand off cleanly
- you keep re-explaining project context to new sessions
- you want local files and Git instead of a hosted task manager
- you want completed work traceable to a plan

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

## How Festival Compares

Festival is not a prompt pack, task board, or hosted orchestrator.

- [GSD](https://github.com/gsd-build/get-shit-done) helps agents avoid context rot inside coding workflows. Festival gives the whole mission a durable filesystem workspace across repos, docs, plans, tasks, and commits.
- [Paperclip](https://github.com/paperclipai/paperclip) manages agent organizations, heartbeats, and budgets. Festival is lower level: local mission state and execution plans any agent can read.
- [Task Master](https://github.com/eyaltoledano/claude-task-master) manages tasks for AI-driven development. Festival adds workspace context: repos, docs, research, lifecycle state, and commit traceability.
- [Spec Kit](https://github.com/github/spec-kit) and [OpenSpec](https://github.com/Fission-AI/OpenSpec) help define what to build before implementation. Festival keeps the broader mission coherent during planning, execution, review, and handoff.
- [planning-with-files](https://github.com/OthmanAdi/planning-with-files), [Agent OS](https://github.com/buildermethods/agent-os), [Superpowers](https://github.com/obra/superpowers), [BMAD](https://github.com/bmad-code-org/BMAD-METHOD), and [gstack](https://github.com/garrytan/gstack) improve planning, standards, or agent behavior. Festival stores the persistent project state those workflows can operate inside.

For direct comparisons, see:

- [Festival vs GSD](https://docs.fest.build/compare/festival-vs-gsd/)
- [Festival vs Paperclip](https://docs.fest.build/compare/festival-vs-paperclip/)
- [Festival vs Task Master](https://docs.fest.build/compare/festival-vs-task-master/)
- [Festival vs Spec Kit and OpenSpec](https://docs.fest.build/compare/festival-vs-spec-kit-openspec/)

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
| Slash commands | `/fest-next`, `/fest-create`, `/fest-done`, `/fest-commit`, `/fest-validate`, `/camp-intent`, `/camp-init` |
| Skills | Auto-activating methodology knowledge, execution workflows, planning guidance |
| Agents | `fest-planner` for designing festivals, `fest-executor` for working through tasks |

## Documentation

Full documentation lives at **[docs.fest.build](https://docs.fest.build)**.

- [Quick Start](https://docs.fest.build/getting-started/quickstart/)
- [Methodology Overview](https://docs.fest.build/methodology/overview/)
- [Agent Workflows](https://docs.fest.build/guides/agent-workflows/)
- [Using Festival with Claude Code](https://docs.fest.build/guides/using-festival-with-claude-code/)
- [Using Festival with Codex](https://docs.fest.build/guides/using-festival-with-codex/)
- [Festival vs GSD](https://docs.fest.build/compare/festival-vs-gsd/)

## License

[Functional Source License 1.1 (FSL-1.1-ALv2)](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com). AI that does what you want, the way you want it done.
