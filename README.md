# Festival

![Festival Banner](docs/images/festival_banner.png)

**Mission-based AI workspace management for developers using AI coding tools.**

## The Problem

You have multiple missions running in parallel — your day job, a side project, a startup idea, an open-source contribution. Each mission has its own projects, planning docs, research, and context. Without structure, this becomes a flat mess of repos, scattered notes, and context that lives only in your head (or worse, in expired chat sessions).

AI coding tools make you faster at writing code, but they don't help you organize *where* you work or *what* you're working toward. You need two things traditional tools don't give you:

1. **Isolated workspaces** — one per mission, with all projects, docs, and planning in one place
2. **Structured plans** — that AI agents can pick up, execute, and resume without losing context

## What Festival Does

Festival gives you **campaigns** and **festivals** — two concepts, two CLIs, one product.

A **campaign** is an isolated workspace for one mission. It organizes your projects, documentation, research, and planning into a standard layout that both you and AI agents can navigate.

A **festival** is a structured plan within a campaign. It breaks work into phases, sequences, and tasks — a hierarchy designed for AI agents to execute autonomously, pause, and resume without context loss.

### Real Example

Here's what `obey-campaign` looks like — a real campaign with 19 projects and active festival planning:

```
obey-campaign/
├── projects/                     # 19 project submodules
│   ├── camp/                     # Campaign CLI
│   ├── fest/                     # Festival planning CLI
│   ├── festival/                 # Distribution repo (this one)
│   ├── obey-platform-monorepo/   # Core platform
│   ├── obey-chat/                # Chat client
│   ├── guild-core/               # Reference implementation
│   ├── obediencecorp.com/        # Company website
│   ├── prototypes/               # Experiment sandbox
│   └── ...                       # 11 more projects
├── festivals/                    # Festival lifecycle workspace
│   ├── planning/                 # Festivals being designed
│   ├── active/                   # Currently executing
│   ├── ready/                    # Prepared, awaiting execution
│   ├── ritual/                   # Recurring processes
│   └── dungeon/                  # completed/ | archived/ | someday/
├── workflow/                     # Intents, code reviews, pipelines
├── ai_docs/                      # AI research and documentation
├── docs/                         # Human-authored documentation
└── CLAUDE.md                     # Agent instructions
```

Every project, every plan, every piece of context for this mission lives here. `cgo p fest` jumps to the fest project. `fgo` toggles between a festival and its linked project. Everything is navigable by both humans and AI agents.

## Two CLIs

### camp — workspace management

```bash
camp init my-startup          # Create a campaign
cgo p api                     # Navigate to projects/api-*
camp project add <url>        # Add a project as submodule
camp doctor                   # Health check the workspace
camp leverage                 # Find highest-impact work
```

### fest — hierarchical planning

```bash
fest create festival my-feature   # Create a structured plan
fest next                         # Get the next task (with full context)
fest status                       # View progress across all levels
fest commit -m "implement auth"   # Git commit with festival tracking
fest understand                   # Teach an agent the methodology
```

## Install

**macOS:**

```bash
brew install Obedience-Corp/tap/festival
```

**Arch Linux:**

```bash
yay -S festival-bin
```

**Debian/Ubuntu:** Download `.deb` from [releases](https://github.com/Obedience-Corp/festival/releases/latest)

**Windows:**

```powershell
scoop bucket add obey https://github.com/Obedience-Corp/scoop-bucket
scoop install festival
```

## Quick Start

```bash
# Shell integration (add to ~/.zshrc)
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"

# Create a campaign
camp init my-project && cd my-project

# Add a project
camp project add https://github.com/you/your-repo

# Create your first festival
fest create festival my-first-feature

# Start working
fest next
```

See the [quick start guide](https://obedience-corp.github.io/festival/getting-started/quickstart/) for a full walkthrough.

## Documentation

Full documentation at **[obedience-corp.github.io/festival](https://obedience-corp.github.io/festival)**:

- [Methodology Overview](https://obedience-corp.github.io/festival/methodology/overview/) — Core principles and concepts
- [Agent Workflows](https://obedience-corp.github.io/festival/guides/agent-workflows/) — Using Festival with AI coding tools
- [First Festival Tutorial](https://obedience-corp.github.io/festival/tutorials/first-festival/) — End-to-end walkthrough

## License

[Business Source License 1.1](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com) — AI that does what you want, the way you want it done.
