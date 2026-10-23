---
title: "Festival Camp Workspaces"
weight: 22
---

# Festival Camp Workspaces

A **Festival camp workspace** holds the context for a job, business, project, or hobby: related repositories, plans, research, skills, and working practices. We shorten this to **camp** below. Older commands and paths sometimes use **campaign**.

## The Multiple Missions Problem

Every developer runs multiple missions at once. The day job. The side project that might become a startup. The open-source library you maintain on weekends. Each mission accumulates its own gravity - project repos, planning documents, research notes, AI conversation history, design decisions, workflow configurations. Without a boundary around each mission, that context scatters. It lives in expired chat windows, unmarked browser tabs, and directories named `misc-stuff-2`.

The problem compounds with AI-assisted development. An agent session needs to understand your workspace - where the code lives, what the plan is, what's been tried before. If your projects, plans, and research are spread across unrelated directories with no shared structure, a new session may miss decisions and repeat work. You spend tokens re-explaining what an organized workspace would make obvious.

A camp solves this by isolating one mission into a single, navigable workspace. Everything related to that mission - every repo, every plan, every design doc - lives under one root with a predictable layout. Humans can `cd` into it and know where things are. Agents can use the structure to find the instructions and records they need.

## What is a Camp?

A Festival camp workspace organizes a single mission, a high-level purpose such as a startup, a job, or an open-source project you maintain. A mission is broad and long-lived, so a camp grows with it over months and years. It groups all related projects, as git submodules or as links to repositories already on your machine, all festival plans in a structured hierarchy, and all supporting materials - documentation, research, workflow configs, design artifacts - into a standard directory layout.

The key property is **navigability**. Both humans and AI agents can enter a camp and immediately understand its structure. Projects are in `projects/`. Plans are in `festivals/`. Docs are in `docs/`. Those conventions give a new session a starting point. It still needs to read the instructions and relevant project context.

Camps are independent. Switching from your day-job camp to your side-project camp is a single command. Each camp carries its own context, its own planning state, its own project graph.

## Camp Directory Layout

```text
my-camp/                   # Camp Git repository
├── AGENTS.md              # Instructions for work in this camp
├── .campaign/             # Camp configuration and managed state
│   ├── campaign.yaml
│   └── intents/           # Ideas captured with camp intent
├── projects/              # Separate repos: submodules or local links
│   ├── api-service/
│   ├── web-app/
│   └── worktrees/         # Isolated branches for concurrent changes
├── festivals/             # Plans, tasks, and execution records
│   ├── planning/
│   ├── ready/
│   ├── active/
│   ├── ritual/
│   └── .dungeon/          # Completed, archived, or someday festivals
├── workflow/
│   ├── explore/           # Research and questions before a decision
│   ├── design/            # Directions you intend to build
│   ├── code_reviews/
│   └── pipelines/
└── docs/                  # Knowledge you want to keep and reuse
```

This is a representative layout. Add workflow collections and reference materials
as the mission needs them. Use camp and fest commands to manage tracked work and
its lifecycle. New camps use `.dungeon/` by default; older camps or a different
`dungeon_hidden` setting may retain `dungeon/`.

## Camp context and project context

Keeping context outside a project means putting your personal workflow in the
camp's repository. For example, a research process, cross-project plan, or script
you use with your agents can live there without requiring every collaborator to
adopt your setup.

The project's shared rules, architecture, and build instructions still belong in
the project repository. Agents need both: how you want this work handled, and the
requirements of the code they are changing.

An existing checkout can stay at `/your/code/api-service`. Linking it creates
`projects/api-service` as a reference to that directory and adds a `.camp`
attachment file to the checkout. Camp context and project code keep separate Git
histories. Start your agent at the camp root so it can navigate to both.

## How agents find context

Predictable locations give an agent a place to start. Think of looking for a fork:
you look in the kitchen, then the cutlery drawer. A camp uses the same idea for
work. Instructions and links point toward the relevant files instead of asking a
session to carry the entire workspace in its conversation.

For a dependency migration, the path through context might be:

1. Read `AGENTS.md` for the camp's working practices.
2. Find the migration with `camp workitem --json` or its saved path.
3. Read its goal, decisions, current step, and review notes.
4. Follow the project link and read that repository's instructions and relevant code.
5. Run `fest next` in the festival or linked project to get the next planned step.

Files are available to read; they are not all automatically loaded into every
session. Keep important decisions in the work record and useful recurring
practices in instructions or templates. A fresh session still needs to read them
and check them against the current files.

Follow [one change across sessions]({{< ref "/guides/one-change-across-sessions" >}})
for prompts, a review example, and the next run using what you learned.

## A public record of the work

The [practice simulator archive](https://github.com/Festival-Examples/codesignal-practice-simulator/tree/main/festivals)
contains three completed festivals from a job-search workspace: a Python practice
engine, a browser interface, and a practice library. Its plans, decisions, reviews,
and corrections show the work around the application, alongside the application
code. The archive explains how paths and private activity details were sanitized
for public sharing; it is a historical record, not an active workspace to resume.

You can start smaller: one repository, one goal, and the instructions needed to
work on it. Add reusable workflows as you discover what helps.

## Camp CLI Overview

The `camp` CLI manages camps. It handles creation, navigation, project management, and cross-camp operations.

### Creating a Camp

```bash
camp create my-camp
```

Creates the camp in your configured camps directory (by default `~/campaigns/`),
asks for its description and mission, initializes Git, and prints its path. Use
[`camp init`]({{< ref "/cli-reference/camp/camp_init" >}}) when you want to
initialize a directory at a location you choose.

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
gains a navigable reference to them. Humans (`cgo p backend`) and agents can navigate to either kind of project.
Commands that operate on all submodules do not necessarily include linked projects;
check each command’s scope before using it to sync repositories.

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
camp sync       # Synchronize URLs and check out recorded submodule commits
```

### Planning Tools

```bash
camp intent add "add WebSocket support to chat"     # Capture an idea
camp leverage                                    # Prioritize intents
camp dungeon move old-note archived              # Archive an item in a dungeon collection
```

`camp dungeon crawl` reviews stale work interactively -- for each item, keep it, file it into the dungeon (completed, archived, or someday), or skip it:

{{< terminal-demo src="/images/demos/tui-dungeon-crawl.gif" title="camp dungeon crawl" alt="camp dungeon crawl triaging stale items into the dungeon: move to archived, keep, or skip, ending in a committed summary" max="720" >}}

### Multiple Camps

```bash
camp register               # Register the current directory as a camp
camp list                    # List all registered camps
camp switch other-camp       # Switch to a different camp
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

Switching camps changes your navigation context; it does not move the files or reset the work you left. A camp is an organizational boundary, not a security sandbox. Linked projects can be shared between workspaces.
