# Quick Start

Create your first campaign and festival in under 5 minutes.

## Prerequisites

`fest` and `camp` should already be installed. If not, see the [Installation](installation.md) guide.

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
fest create festival --name "my-first-feature" --type standard
```

Use `standard` for the beginner path. It scaffolds the ingest and planning phases you need before implementation. Use `implementation` only when requirements are already defined and you want to skip that planning structure.

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

## What's Next?

- [Methodology Overview](../methodology/overview.md) -- Understand the full phase-sequence-task system
- [First Festival Tutorial](../tutorials/first-festival.md) -- Detailed end-to-end tutorial with real examples
- [Agent Workflows](../guides/agent-workflows.md) -- Using Festival with AI coding tools like Claude Code
- [Best Practices](../guides/best-practices.md) -- Patterns for effective planning and execution
