# Festival

**The workspace and planning layer for AI-native development.**

## The Problem

AI coding tools made writing code 10–100x faster. But they operate in a vacuum — no understanding of the larger goal, no memory across sessions, no structure for multi-step work. Every new chat starts from zero. The agent is fast but contextless.

This gets worse when you're running multiple missions in parallel — your day job, a side project, a startup, open source. Context that lives only in your head (or in expired chat sessions) doesn't scale.

You need two things traditional tools don't give you:

1. **Isolated workspaces** — one per mission, with all projects, docs, and planning in one place
2. **Structured plans** — that AI agents can pick up, execute, and resume without losing context

## What Festival Does

**`camp`** manages campaigns: isolated workspaces that hold all the projects, docs, research, and planning for a single mission. It gives you instant navigation across everything in the workspace, project lifecycle management, and shell shortcuts that make `cd` obsolete.

**`fest`** manages festivals: structured plans that break complex work into phases, sequences, and tasks — a hierarchy designed for AI agents to execute autonomously, pause, and resume without context loss. Run `fest next` and the agent gets its next task with full surrounding context. Run `fest commit` and every commit traces back to the plan.

### Where Festival Fits

Festival is a **planning and context layer**, not a runtime orchestrator. It doesn't spawn agents or manage their processes — it gives them the structure, context, and goals they need to work autonomously. Runtime orchestrators tell agents what to do next. Festival gives agents the context to understand *why* they're doing it, what success looks like, and where they are in a larger mission.

The context model is persistent and filesystem-based — plans survive across sessions, days, and weeks, not just a single agent run. And Festival is agent-agnostic: it works with Claude Code, Cursor, Codex, Aider, or any tool that can read files and run commands.

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
