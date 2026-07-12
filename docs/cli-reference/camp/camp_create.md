---
title: "camp create"
linkTitle: "camp create"
description: "Create a new campaign at the default campaigns directory"
---

## camp create

Create a new campaign at the default campaigns directory

### Synopsis

Create a new campaign at <campaigns_dir>/<name>/, using the same scaffolding as 'camp init'. The default campaigns directory is ~/campaigns/ and can be configured via 'camp settings' or by editing the campaigns_dir field in ~/.obey/campaign/config.json.

```
camp create <name> [flags]
```

### Examples

```
  camp create my-project
  camp create my-project -d "Description" -m "Mission"
  camp create my-project --path ~/Dev/sandbox
  camp create my-project --dry-run
```

### Options

```
  -d, --description string   Campaign description
      --dry-run              Show what would be done without creating anything
  -h, --help                 help for create
  -m, --mission string       Campaign mission statement
  -n, --name string          Campaign display name (defaults to <name> positional)
      --no-git               Skip git repository initialization
      --no-skills            Skip linking campaign skills into .claude/skills and .agents/skills
      --org string           Assign the new campaign to this org (created if new; defaults to the fallback org)
      --path string          Override the base campaigns directory (campaign created at <path>/<name>/)
  -t, --type string          Campaign type (product, research, tools, personal) (default "product")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
