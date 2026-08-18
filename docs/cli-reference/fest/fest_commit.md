---
title: "fest commit"
linkTitle: "fest commit"
description: "Create git commit with task reference"
---

## fest commit

Create git commit with task reference

### Synopsis

Create a git commit with the festival/task ID embedded in the message.

Requires festival context: either run from inside a festival directory,
a linked project directory (see 'fest link'), or use --festival to specify one.

The fest commit command wraps git commit and automatically:
  1. Stages changes and prepends the festival reference to the commit message
  2. Creates a campaign root commit for festival-scoped files (task docs, progress, state)

When a festival or sequence has a linked project, up to two commits are created
even when this command is run from inside the festival:
  - Project commit: stages all project changes (skipped when the project is clean)
  - Campaign root commit: stages only festival directory, .campaign/fest/,
    festivals/.festival/.state/, and the submodule pointer

The sequence's fest_working_dir is preferred over the festival navigation link
and legacy fest.yaml project_path. A festival with no linked project creates one
campaign-root commit containing only festival-scoped files (not git add -A).

Use --no-root to skip the campaign root commit.

Reference format: [FE-{id}]
  - FE: Festival component identifier
  - {id}: Task ref (FEST-xxxxxx) or festival ID (e.g., CS0001)

Detection priority:
  1. Explicit --task flag value
  2. Task fest_ref from current directory (if inside festival task)
  3. Explicit --festival flag (path, name, or ID)
  4. Festival ID from fest.yaml metadata

Examples:
```bash
  fest commit -m "Implement feature"
  # In linked project or sequence → [FE-CS0001] Implement feature
  # In festival task              → [FE-FEST-a3b2c1] Implement feature

  fest commit --task FEST-b4c5d6 -m "Related work"
  # → [FE-FEST-b4c5d6] Related work

  fest commit --festival OA0001 -m "Work from unlinked dir"
  # → [FE-OA0001] Work from unlinked dir

  fest commit --no-tag -m "No reference"
  # → No reference

  fest commit --stage=false -m "Only commit staged"
  # Skip auto-staging, commit only what's already staged

  fest commit --auto-write
  # Run the configured campaign commit-message hook from the target repo
```

```
fest commit [flags]
```

### Options

```
      --auto-write        run configured commit message writer
      --commit-large      commit over-threshold files instead of keeping them out of git
      --festival string   festival path, name, or ID (overrides auto-detection)
  -h, --help              help for commit
      --json              output result as JSON
  -m, --message string    commit message (required unless --auto-write)
      --no-root           skip campaign root commit (project commit only)
      --no-tag            don't prepend task reference
      --stage             auto-stage all changes before commit (default true)
      --task string       task reference ID to use (e.g., FEST-a3b2c1)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
