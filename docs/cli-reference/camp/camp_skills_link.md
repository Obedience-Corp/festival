---
title: "camp skills link"
linkTitle: "camp skills link"
description: "Project camp skill bundles into tool-specific skills directories"
---

## camp skills link

Project camp skill bundles into tool-specific skills directories

### Synopsis

Project camp skill bundles from .campaign/skills/ into tool-specific
skills directories.

This command creates one symlink per skill bundle. It does not replace entire
provider skills directories, so existing user skills remain intact.

With neither --tool nor --path, skills are projected into every registered tool.
Pass --worktrees with no --tool/--path to also project into every
projects/worktrees/<project>/<name> git checkout (so Grok/Claude sessions
opened inside a worktree still see camp skills). Use --worktrees-only to
project into worktrees without touching camp-root tool directories.

Worktree discovery only includes directories with a .git file/dir. The normal
layout is projects/worktrees/<project>/<name>/. A loose git root at
projects/worktrees/<name>/ is also accepted; nested dirs under that root are
not scanned as separate worktrees.

Examples:
  camp skills link                     Project skills into all registered tools
  camp skills link --worktrees         Project into tools and every project worktree
  camp skills link --worktrees-only    Project into every project worktree only
  camp skills link --tool claude       Project skills into .claude/skills/
  camp skills link --tool agents       Project skills into .agents/skills/
  camp skills link --path custom/dir   Project skills into custom/dir
  camp skills link --tool claude -n    Dry run: show what would happen
  camp skills link --tool claude -f    Replace conflicting symlink entries

```
camp skills link [flags]
```

### Options

```
  -n, --dry-run          Show what would happen without making changes
  -f, --force            Replace conflicting symlink entries (never files/directories)
  -h, --help             help for link
  -p, --path string      Custom destination directory
  -t, --tool string      Tool to link: claude, agents
      --worktrees        Also project into every projects/worktrees/*/* worktree
      --worktrees-only   Project only into project worktrees (skip camp tool dirs)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp skills](../camp_skills/)	 - Manage camp skill directory links
