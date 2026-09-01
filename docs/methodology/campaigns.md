---
title: "Camps"
weight: 22
---

# Camps

A camp, previously called a campaign, is one workspace holding a group of related projects and the festivals you run in them.

## The Multiple Missions Problem

Every developer runs multiple missions at once. The day job. The side project that might become a startup. The open-source library you maintain on weekends. Each mission accumulates its own gravity - project repos, planning documents, research notes, AI conversation history, design decisions, workflow configurations. Without a boundary around each mission, that context scatters. It lives in expired chat windows, unmarked browser tabs, and directories named `misc-stuff-2`.

The problem compounds with AI-assisted development. An agent session needs to understand your workspace - where the code lives, what the plan is, what's been tried before. If your projects, plans, and research are spread across unrelated directories with no shared structure, every new session starts from scratch. You spend tokens re-explaining what an organized workspace would make obvious.

A camp solves this by isolating one mission into a single, navigable workspace. Everything related to that mission - every repo, every plan, every design doc - lives under one root with a predictable layout. Humans can `cd` into it and know where things are. Agents can read the structure and orient themselves immediately.

## What is a Camp?

A camp is an isolated workspace for a single mission, a high-level purpose such as a startup, a job, or an open-source project you maintain. A mission is broad and long-lived, so a camp grows with it over months and years. It groups all related projects, as git submodules or as links to repositories already on your machine, all festival plans in a structured hierarchy, and all supporting materials - documentation, research, workflow configs, design artifacts - into a standard directory layout.

The key property is **navigability**. Both humans and AI agents can enter a camp and immediately understand its structure. Projects are in `projects/`. Plans are in `festivals/`. Docs are in `docs/`. There is no guessing, no project-specific convention to learn, no onboarding friction.

Camps are independent. Switching from your day-job camp to your side-project camp is a single command. Each camp carries its own context, its own planning state, its own project graph.

## Camp Directory Layout

```
my-campaign/
├── .campaign/              # Camp configuration
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

Every directory serves a single purpose. There are no catch-all folders. If something does not fit the structure, it probably belongs in a different camp or does not belong at all.

## Real Camp Example

The `obey-campaign` workspace is the central camp for all Obedience Corp product development. It contains:

- **20 project submodules** spanning Go CLIs, Rust TUI clients, a platform monorepo, a company website, prototypes, and shared libraries
- **Active festival planning** with festivals in `planning/`, `active/`, `ready/`, and `ritual/` directories
- **Workflow materials** including code reviews, design documents, and intent captures
- **AI documentation** with research notes generated across hundreds of agent sessions

Key projects in the camp include `camp` (the Camp CLI itself), `fest` (the festival planning CLI), `obey-platform-monorepo` (the core daemon and services), `obey-chat` (chat client), `guild-chat` (Rust TUI), and `obediencecorp.com` (the website). The camp also holds `guild-core`, the archived reference implementation that the current architecture evolved from.

This is a large camp. Most camps are smaller - a side project with two or three repos and a handful of festivals. The structure scales in both directions.

## Camp CLI Overview

The `camp` CLI manages camps. It handles creation, navigation, project management, and cross-camp operations.

### Creating a Camp

```bash
camp init my-campaign
```

Scaffolds the full directory layout, initializes git, and creates the `.campaign/campaign.yaml` configuration.

### Navigation

The `cgo` shell function provides fast navigation with single-letter shortcuts:

```bash
cgo             # Jump to camp root
cgo p           # Jump to projects/
cgo f           # Jump to festivals/
cgo d           # Jump to docs/
cgo w           # Jump to workflow/
cgo p api       # Jump to projects/api-service/ (fuzzy match)
```

### Adding Projects

A project can join a camp two ways, depending on where the code already lives.

**As a submodule.** If the project is a remote git repository, add it as a tracked
submodule under `projects/`. Camp clones it and records the ref:

```bash
camp project add git@github.com:org/repo.git    # Clone a remote repo as a submodule
camp project new my-service                      # Scaffold a brand-new project in the camp
```

**As a linked workspace.** If the project already exists on your machine, link it
instead of cloning a second copy. Camp creates a symlink at `projects/<name>` pointing
at the real directory and writes a `.camp` marker so commands run from inside that
directory know which camp owns it. The original checkout is left exactly where it is:

```bash
camp project link ~/code/my-project              # Link an existing local directory
camp project link                                # Link the current directory
camp project link ~/code/api --name backend      # Override the project name
```

Linking is the right choice for repositories you already clone and work on outside any
camp. Your existing branches, remotes, and history stay in place; the camp just
gains a navigable reference to them. Both humans (`cgo p backend`) and AI agents treat a
linked workspace exactly like a submodule project.

To list, unlink, or remove projects:

```bash
camp project list                                # List all projects (submodules and links)
camp project unlink my-project                   # Remove a link (leaves the external workspace intact)
camp project remove old-service                  # Remove a submodule project
```

`unlink` removes only the symlink and the camp marker. The external workspace and
its git history are never touched. Use `remove` for submodule projects.

To rename a project:

```bash
camp project rename api-old api                  # Rename a managed project
camp project rename api-old api --dry-run        # Print the plan without writing
```

`rename` handles submodules, linked workspaces, and camp-owned directories,
migrating the camp's references to the project in one transaction. Dirty
checkouts and linked worktrees are preserved. Camp never assumes the upstream
repository was renamed too, so pass `--remote-url` when origin should move with it.

### Attaching Other Directories

Not every directory a camp should own is a project. A notes folder, a scratch
directory, or an external reference repo can be attached without becoming a project.
`camp attach` writes a `.camp` marker at the target so commands run from inside it
resolve to the right camp. You manage the symlink, if any, yourself:

```bash
camp attach ~/scratch/research-notes             # Attach a non-project directory
camp detach ~/scratch/research-notes             # Remove the attachment marker
```

### Health and Sync

```bash
camp doctor     # Diagnose camp issues (broken submodules, missing dirs)
camp sync       # Update all submodules to latest refs
```

### Planning Tools

```bash
camp intent "add WebSocket support to chat"     # Capture an idea
camp leverage                                    # Prioritize intents
camp dungeon move old-festival                   # Archive completed work
```

`camp dungeon crawl` reviews stale work interactively -- for each item, keep it, file it into the dungeon (completed, archived, or someday), or skip it:

{{< terminal-demo src="/images/demos/tui-dungeon-crawl.gif" title="camp dungeon crawl" alt="camp dungeon crawl triaging stale items into the dungeon: move to archived, keep, or skip, ending in a committed summary" max="720" >}}

### Multiple Camps

```bash
camp register               # Register the current directory as a camp
camp list                    # List all registered camps
camp switch other-campaign   # Switch to a different camp
```

## Working Across Camps

Camps are registered globally so you can manage several missions from anywhere.

Register a camp to make it known to `camp`:

```bash
cd ~/Dev/side-project && camp register
cd ~/Dev/day-job && camp register
```

Switch between registered camps:

```bash
camp switch side-project    # Sets active camp, cgo now targets it
camp switch day-job         # Back to work
```

Transfer files between camps when work migrates:

```bash
camp transfer festivals/planning/auth-system day-job
```

Each camp is fully isolated. Switching camps does not affect the state of the one you left. Your festivals, project refs, and workflow materials stay exactly where they are until you come back.
