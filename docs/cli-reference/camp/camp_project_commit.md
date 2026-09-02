---
title: "camp project commit"
linkTitle: "camp project commit"
description: "Commit changes in a project submodule"
---

## camp project commit

Commit changes in a project submodule

### Synopsis

Commit changes within a project submodule.

Auto-detects the current project from your working directory,
or use --project to specify a project by name.

Commit tags are traceability-aware: when the current project or cwd resolves
to an active festival or workitem (via path links, ancestor .workitem
markers, or festival-scoped links), the commit message carries the same
FE-<ref> / WI-<ref> tracking components that `fest commit` would
include. Use --workitem to override cwd-based resolution. When no
festival/workitem context resolves, the tag is the bare camp tag.

Examples:
  # From within a project directory
  cd projects/my-api
  camp project commit -m "Fix bug"

  # Specify project by name
  camp project commit --project my-api -m "Update deps"

```
camp project commit [flags]
```

### Options

```
  -a, --all                   Stage all changes (default true)
      --amend                 Amend the previous commit
      --auto-write            Run configured commit message writer
      --commit-large          Commit over-threshold files instead of keeping them out of git
      --commit-nested         Commit undeclared nested git repositories as gitlinks instead of keeping them out of git
  -h, --help                  help for commit
  -m, --message stringArray   Commit message (repeatable; multiple -m are joined git-style into subject + body; required unless --auto-write)
      --no-drain              Do not wait for camp's queued commits first
      --no-sync               Do not sync submodule ref even if settings enable it
  -p, --project string        Project name (auto-detected from cwd if not specified)
      --sync                  Sync submodule ref at camp root after commit (also enabled by commit.sync_project_refs setting)
      --workitem string       explicit workitem selector for the commit tag (overrides cwd-based resolution)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
