# Festival

**Mission-based AI workspace management for developers using AI coding tools.**

## The Multiple Missions Problem

Most developers juggle several missions at once. Your day job has a backend service, a frontend app, and infrastructure. Your side project has its own repos and research. Maybe you're building a startup on nights and weekends, or contributing to open source.

Each mission accumulates context - project repos, planning documents, research notes, design decisions, AI conversation history. Without structure, this context scatters across your filesystem, gets lost between sessions, and lives in your head instead of somewhere durable.

AI coding tools (Claude Code, Cursor, Codex) make you dramatically faster at writing code. But they operate at the file and project level. They don't help you organize across projects, plan multi-step work, or maintain context between sessions. You end up re-explaining the same architecture, re-discovering the same decisions, and re-planning work that was already planned.

Festival solves this with two concepts: **campaigns** for workspace isolation and **festivals** for structured planning.

## Two CLIs, One Product

### camp - workspace management

Camp creates and manages **campaigns** - isolated workspaces for individual missions. Each campaign has a standard directory layout for projects, documentation, planning, and research.

- Create campaigns with `camp init` and navigate with `cgo` shell shortcuts
- Add projects as git submodules with `camp project add`
- Navigate between projects, festivals, docs, and worktrees with single-letter shortcuts
- Health check workspaces with `camp doctor`, sync submodules with `camp sync`
- Register campaigns globally and switch between them with `camp switch`

### fest - hierarchical planning

Fest creates and manages **festivals** - structured plans that break complex work into phases, sequences, and tasks. The hierarchy is designed for AI agents to execute autonomously.

- Create festivals with `fest create festival` and scaffold structure interactively
- Get the next task with full inline context using `fest next`
- Track progress across all levels with `fest status` and `fest progress`
- Teach AI agents the methodology on-demand with `fest intro` and `fest understand`
- Commit with festival tracking using `fest commit`

### How They Work Together

Camp gives you the workspace. Fest gives you the plan. Together, they create a structured environment where you can organize multiple missions, plan complex work, and hand off execution to AI agents that can pick up exactly where you (or another agent) left off.

A typical workflow: `camp init` creates your workspace, `camp project add` brings in your repos, `fest create festival` defines what you're building, and `fest next` tells your AI agent exactly what to do next - with full context about the goal, the current phase, and the specific task requirements.

## Next Steps

<div class="grid cards" markdown>

-   **New to Festival?**

    ---

    Start with the hands-on quick start guide.

    [:octicons-arrow-right-24: Quick Start](getting-started/quickstart.md)

-   **Understand the Methodology**

    ---

    Learn the core principles, hierarchy, and workflow.

    [:octicons-arrow-right-24: Methodology Overview](methodology/overview.md)

-   **Using AI Agents?**

    ---

    How Festival integrates with Claude Code, Cursor, and other AI tools.

    [:octicons-arrow-right-24: Agent Workflows](guides/agent-workflows.md)

-   **Setting Up a Campaign**

    ---

    Full tutorial for workspace setup and project organization.

    [:octicons-arrow-right-24: Campaign Setup](tutorials/campaign-setup.md)

</div>
