---
title: "Quick Start"
weight: 12
---

# Quick Start

**Your files. Any agent.**

Festival is the planning and verification layer for long-running agent work. The campaign is files you own. The harness is whatever you already run. The next session starts from `fest next`, not from a vendor brief.

Create your first campaign and festival in under 5 minutes.

## Common Questions

**Is this a coding agent?**

No. Keep Claude Code, Codex, Grok, or whatever you use. Festival is the work system those agents read and write.

**Where does the memory live?**

In your campaign: phases, sequences, tasks, intents, and git history, as plain files on your disk. You can copy it, diff it, and leave with it.

**What happens when a session ends?**

The next actionable task is still on disk. `fest next` is the resume, in the same agent or a different one.

**How do you know the work is done?**

Each task carries completion criteria, `fest validate` checks the plan against the methodology, quality gates run at the end of an implementation sequence, and `fest commit` ties the change back to the task it came from. That trail is the proof of work.

**Why not a hosted agent workspace?**

A hosted workspace keeps your continuity in someone else's account and usually replaces the coding agent you already run. Festival sits beside the harness you already pay for and keeps the record on your disk.

{{< terminal-demo src="/images/demos/proof-loop.gif" title="fest next" alt="One sentence of intent scaffolds a festival, an agent runs the next task, the session is interrupted, fest next resumes it, then fest validate and fest commit close it out" max="700" >}}

*One sentence of intent. A scaffolded festival. The agent runs the next task, the session is interrupted, and `fest next` picks it back up. Validate, commit, done.*

## Prerequisites

`fest` and `camp` should already be installed. If not, see the [Installation]({{< ref "/getting-started/installation" >}}) guide.

## 1. Set Up Shell Integration

```bash
# Add to ~/.zshrc when installed with install.sh
source ~/.local/share/festival/shell/festival.zsh

# Or, if no helper file is installed:
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
csw              # Interactive campaign picker -- switch between campaigns
csw my-project   # Switch directly by name
```

Single-letter shortcuts make navigation instant. `cgo p api` fuzzy-matches project names so you never type full paths. `csw` switches between campaigns -- use it when you're managing multiple campaigns.

## 4. Add a Project (Optional)

```bash
camp project add https://github.com/you/your-repo
```

Projects are added as git submodules under `projects/`.

## 5. Create Your First Festival

```bash
fest create festival --name "my-first-feature" --type standard
```

Use `standard` for the beginner path. It scaffolds the ingest and planning phases you need before implementation. Use `implementation` only when requirements are already defined and you want to skip that planning structure.

If you are not sure whether this work should start as an intent, a design doc, or a festival, read [Intent vs Design vs Festival]({{< ref "/guides/intent-design-festival" >}}) before creating more planning artifacts.

## 6. Fill Required Markers

Open the generated festival files and replace the required `REPLACE` markers with real content. Do not skip this step.

## 7. Validate the Festival

```bash
fest validate
```

Validation catches unfinished markers and structure issues before execution. Keep running it until the new festival passes cleanly.

## 8. Write a Task

When `standard` scaffolding is valid, your first useful work starts in `001_INGEST/`. Implementation tasks later live directly inside the sequence directory, not under a `tasks/` subdirectory:

```
01_setup-database/
  01_create-schema.md
  02_write-migrations.md
  03_seed-test-data.md
```

If you later create implementation sequences manually, add the standard quality gates explicitly:

```bash
fest gates apply --approve
```

## 9. Start Working

```bash
fest next                              # Get the next task with full context
```

On a first-run `standard` festival, `fest next` should take you into the ingest workflow after marker fill and validation. Once you reach implementation tasks later, do the work described and then:

```bash
fest task completed                     # Mark the current task done
fest commit -m "implement user model"  # Commit with festival tracking
```

`fest commit` wraps git commit with metadata that ties changes back to the active task. Always prefer it over raw `git commit` when working inside a festival.

## 10. Track Progress

```bash
fest status        # View overall festival progress
fest progress      # Detailed execution progress with phase/sequence breakdown
```

`fest status` gives a high-level view. `fest progress` shows exactly where you are in the phase-sequence-task hierarchy.

To see every festival in the campaign at once, grouped by status, use `fest list`:

{{< terminal-demo src="/images/demos/tui-fest-list.gif" title="fest list" alt="fest list showing festivals grouped by status: active, ready, and planning" max="600" >}}

## What's Next?

- [Methodology Overview]({{< ref "/methodology/overview" >}}) -- Understand the full phase-sequence-task system
- [First Festival Tutorial]({{< ref "/tutorials/first-festival" >}}) -- Detailed end-to-end tutorial with real examples
- [Agent Workflows]({{< ref "/guides/agent-workflows" >}}) -- Using Festival with AI coding tools
- [Best Practices]({{< ref "/guides/best-practices" >}}) -- Patterns for effective planning and execution
