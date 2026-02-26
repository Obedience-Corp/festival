---
title: "Quick Start"
weight: 12
---

# Quick Start

Create your first campaign and festival in under 5 minutes.

## Prerequisites

`fest` and `camp` should already be installed. If not, see the [Installation]({{< ref "/docs/getting-started/installation" >}}) guide.

## 1. Set Up Shell Integration

```bash
# Add to ~/.zshrc (or ~/.bashrc)
eval "$(camp shell-init zsh)"
eval "$(fest shell-init zsh)"

# Restart your shell or source the file
source ~/.zshrc
```

This gives you `cgo` for campaign navigation and `fgo` for festival shortcuts.

## 2. Create a Campaign

```bash
camp init my-project
cd my-project
```

This creates the campaign directory structure with `projects/`, `festivals/`, `docs/`, and the `.campaign/` workspace config.

## 3. Navigate the Campaign

```bash
cgo              # Jump to campaign root
cgo p            # Jump to projects/
cgo f            # Jump to festivals/
```

Single-letter shortcuts make navigation instant. `cgo p api` fuzzy-matches project names so you never type full paths.

## 4. Add a Project (Optional)

```bash
camp project add https://github.com/you/your-repo
```

Projects are added as git submodules under `projects/`.

## 5. Create Your First Festival

```bash
fest create festival --type implementation my-first-feature
```

This scaffolds a festival with an IMPLEMENT phase already included. Use `--type standard` if you need planning phases (PLAN, DESIGN) before implementation.

## 6. Add a Phase

```bash
fest create phase --name "001_IMPLEMENT" --type implementation
```

For implementation festivals, the IMPLEMENT phase is auto-scaffolded in step 5. You only need this when adding extra phases to a standard festival.

## 7. Add a Sequence

```bash
fest create sequence
```

An interactive TUI guides you through naming and placing the sequence within the current phase.

## 8. Write a Task

Tasks are markdown files inside the sequence directory. Each file follows a simple structure:

```
sequences/
  001_setup-database/
    tasks/
      001_create-schema.md
      002_write-migrations.md
      003_seed-test-data.md
```

Open any task file and fill in the description, acceptance criteria, and any notes. The filename ordering determines execution order.

## 9. Start Working

```bash
fest next                              # Get the next task with full context
```

Do the work described in the task, then:

```bash
fest task complete                     # Mark the current task done
fest commit -m "implement user model"  # Commit with festival tracking
```

`fest commit` wraps git commit with metadata that ties changes back to the active task. Always prefer it over raw `git commit` when working inside a festival.

## 10. Track Progress

```bash
fest status        # View overall festival progress
fest progress      # Detailed execution progress with phase/sequence breakdown
```

`fest status` gives a high-level view. `fest progress` shows exactly where you are in the phase-sequence-task hierarchy.

## What's Next?

- [Methodology Overview]({{< ref "/docs/methodology/overview" >}}) -- Understand the full phase-sequence-task system
- [First Festival Tutorial]({{< ref "/docs/tutorials/first-festival" >}}) -- Detailed end-to-end tutorial with real examples
- [Agent Workflows]({{< ref "/docs/guides/agent-workflows" >}}) -- Using Festival with AI coding tools like Claude Code
- [Best Practices]({{< ref "/docs/guides/best-practices" >}}) -- Patterns for effective planning and execution
