---
title: "camp init"
linkTitle: "camp init"
description: "Initialize a new camp"
---

## camp init

Initialize a new camp

### Synopsis

Initialize a new camp directory structure.

Creates the standard camp directories:
  .campaign/              - Camp configuration and metadata
  .campaign/intents/      - System-managed intent state
  projects/               - Project repositories (submodules or worktrees)
  projects/worktrees/     - Git worktrees for parallel development
  festivals/              - Festival methodology workspace (via fest init)
  docs/                   - Human-authored documentation
  dungeon/                - Archived and deprioritized work
  workflow/               - Workflow management
  workflow/reviews/       - Review notes, feedback, and assessments
  workflow/design/        - Design documents

Also creates:
  AGENTS.md     - AI agent instruction file
  CLAUDE.md     - Symlink to AGENTS.md

Initializes a git repository if not already inside one.

Camp metadata lives in the directory named .campaign/. That name is stable and
Camp expects it, so do not rename it. The separate .camp file is an attachment
marker for linked external directories, not a replacement for .campaign/.

Use --no-git to skip git initialization.

```
camp init [path] [flags]
```

### Examples

```
  camp init                      Initialize current directory
  camp init my-camp          Create and initialize new directory
  camp init --name "My Project"  Set custom camp name
  camp init --no-git             Skip git initialization
  camp init --dry-run            Preview without creating anything
```

### Options

```
  -d, --description string   Camp description
      --dry-run              Show what would be done without creating anything
  -f, --force                Initialize in non-empty directory without prompting
  -h, --help                 help for init
  -m, --mission string       Camp mission statement
  -n, --name string          Camp name (defaults to directory name)
      --no-git               Skip git repository initialization
      --no-register          Don't add to global registry
      --no-skills            Skip linking camp skills into .claude/skills and .agents/skills
      --org string           Assign the new camp to this org (created if new; defaults to the fallback org)
      --repair               Add missing files to existing camp
  -t, --type string          Camp type (product, research, tools, personal) (default "product")
  -v, --verbose              Show skipped optional setup details
      --yes                  Skip repair confirmation prompt (for scripting)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
