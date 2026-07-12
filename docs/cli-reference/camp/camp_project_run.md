---
title: "camp project run"
linkTitle: "camp project run"
description: "Run a command inside a project directory, like cr but project-scoped"
---

## camp project run

Run a command inside a project directory, like cr but project-scoped

### Synopsis

Run any shell command inside a project directory from anywhere in the campaign.

This is the project-scoped counterpart to 'camp run' (cr): cr runs from the
campaign root, camp project run (cr -p) runs inside a project.

The project is resolved in this order:
  1. --project / -p flag (explicit project name, tab-completes registered projects)
  2. Auto-detect from current working directory
  3. Interactive fuzzy picker (if neither above applies)

Use -- to separate camp flags from the command to execute.

Examples:
  # Interactive project picker, then run command
  camp project run -- ls -la

  # Specify project explicitly
  camp project run -p fest -- just build
  camp project run --project camp -- go test ./...

  # Auto-detect from cwd (inside projects/fest/)
  camp project run -- just test all

  # Simple commands (no -- needed when no flags)
  camp project run make build

  # Shell shorthand (after 'eval "$(camp shell-init <shell>)"')
  cr -p fest -- just build
  cr -p camp go test ./...

```
camp project run [--project <name>] [--] <command> [args...] [flags]
```

### Options

```
  -h, --help             help for run
  -p, --project string   Project name (auto-detected from cwd, or interactive picker if omitted)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage campaign projects
