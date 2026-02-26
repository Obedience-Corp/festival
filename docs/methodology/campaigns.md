# Campaigns

## The Multiple Missions Problem

Every developer runs multiple missions at once. The day job. The side project that might become a startup. The open-source library you maintain on weekends. Each mission accumulates its own gravity - project repos, planning documents, research notes, AI conversation history, design decisions, workflow configurations. Without a boundary around each mission, that context scatters. It lives in expired chat windows, unmarked browser tabs, and directories named `misc-stuff-2`.

The problem compounds with AI-assisted development. An agent session needs to understand your workspace - where the code lives, what the plan is, what's been tried before. If your projects, plans, and research are spread across unrelated directories with no shared structure, every new session starts from scratch. You spend tokens re-explaining what an organized workspace would make obvious.

A campaign solves this by isolating one mission into a single, navigable workspace. Everything related to that mission - every repo, every plan, every design doc - lives under one root with a predictable layout. Humans can `cd` into it and know where things are. Agents can read the structure and orient themselves immediately.

## What is a Campaign?

A campaign is an isolated workspace for a single mission. It groups all related projects as git submodules, all festival plans in a structured hierarchy, and all supporting materials - documentation, research, workflow configs, design artifacts - into a standard directory layout.

The key property is **navigability**. Both humans and AI agents can enter a campaign and immediately understand its structure. Projects are in `projects/`. Plans are in `festivals/`. Docs are in `docs/`. There is no guessing, no project-specific convention to learn, no onboarding friction.

Campaigns are independent. Switching from your day-job campaign to your side-project campaign is a single command. Each campaign carries its own context, its own planning state, its own project graph.

## Campaign Directory Layout

```
my-campaign/
├── .campaign/              # Campaign configuration
│   └── campaign.yaml       # Name, type, description, metadata
├── projects/               # Git submodules - your actual code
│   ├── api-service/        # Each project is a separate repo
│   └── web-app/            # Added via camp project add
├── festivals/              # Festival planning workspace
│   ├── planning/           # Festivals being designed and scoped
│   ├── active/             # Festivals currently being executed
│   ├── ready/              # Fully planned, awaiting execution
│   ├── ritual/             # Recurring or special-purpose festivals
│   └── dungeon/            # Terminal statuses
│       ├── completed/      # Successfully finished festivals
│       ├── archived/       # Shelved but preserved for reference
│       └── someday/        # Deprioritized, revisit later
├── workflow/               # Workflow management materials
│   ├── code_reviews/       # Code review notes and checklists
│   ├── pipelines/          # CI/CD pipeline definitions
│   ├── design/             # Design documents and specs
│   └── intents/            # Intent documents for idea capture
├── ai_docs/                # AI-generated research and analysis
├── docs/                   # Human-authored documentation
├── corpus/                 # Reference materials and external sources
└── worktrees/              # Git worktrees for parallel development
```

Every directory serves a single purpose. There are no catch-all folders. If something does not fit the structure, it probably belongs in a different campaign or does not belong at all.

## Real Campaign Example

The `obey-campaign` workspace is the central campaign for all Obedience Corp product development. It contains:

- **20 project submodules** spanning Go CLIs, Rust TUI clients, a platform monorepo, a company website, prototypes, and shared libraries
- **Active festival planning** with festivals in `planning/`, `active/`, `ready/`, and `ritual/` directories
- **Workflow materials** including code reviews, design documents, and intent captures
- **AI documentation** with research notes generated across hundreds of agent sessions

Key projects in the campaign include `camp` (the campaign CLI itself), `fest` (the festival planning CLI), `obey-platform-monorepo` (the core daemon and services), `obey-chat` (chat client), `guild-chat` (Rust TUI), and `obediencecorp.com` (the website). The campaign also holds `guild-core`, the archived reference implementation that the current architecture evolved from.

This is a large campaign. Most campaigns are smaller - a side project with two or three repos and a handful of festivals. The structure scales in both directions.

## Camp CLI Overview

The `camp` CLI manages campaigns. It handles creation, navigation, project management, and cross-campaign operations.

### Creating a Campaign

```bash
camp init my-campaign
```

Scaffolds the full directory layout, initializes git, and creates the `.campaign/campaign.yaml` configuration.

### Navigation

The `cgo` shell function provides fast navigation with single-letter shortcuts:

```bash
cgo             # Jump to campaign root
cgo p           # Jump to projects/
cgo f           # Jump to festivals/
cgo d           # Jump to docs/
cgo w           # Jump to workflow/
cgo p api       # Jump to projects/api-service/ (fuzzy match)
```

### Project Management

```bash
camp project add git@github.com:org/repo.git    # Add a submodule
camp project list                                # List all projects
camp project remove old-project                  # Remove a submodule
```

### Health and Sync

```bash
camp doctor     # Diagnose campaign issues (broken submodules, missing dirs)
camp sync       # Update all submodules to latest refs
```

### Planning Tools

```bash
camp intent "add WebSocket support to chat"     # Capture an idea
camp leverage                                    # Prioritize intents
camp dungeon move old-festival                   # Archive completed work
```

### Multiple Campaigns

```bash
camp register               # Register the current directory as a campaign
camp list                    # List all registered campaigns
camp switch other-campaign   # Switch to a different campaign
```

## Working Across Campaigns

Campaigns are registered globally so you can manage several missions from anywhere.

Register a campaign to make it known to `camp`:

```bash
cd ~/Dev/side-project && camp register
cd ~/Dev/day-job && camp register
```

Switch between registered campaigns:

```bash
camp switch side-project    # Sets active campaign, cgo now targets it
camp switch day-job         # Back to work
```

Transfer files between campaigns when work migrates:

```bash
camp transfer festivals/planning/auth-system day-job
```

Each campaign is fully isolated. Switching campaigns does not affect the state of the one you left. Your festivals, project refs, and workflow materials stay exactly where they are until you come back.
