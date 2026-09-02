---
title: "camp create"
linkTitle: "camp create"
description: "Create a new camp at the default camps directory"
---

## camp create

Create a new camp at the default camps directory

### Synopsis

Create a new camp at <campaigns_dir>/<name>/, using the same scaffolding as 'camp init'. The default camps directory is ~/campaigns/ and can be configured via 'camp settings' or by editing the campaigns_dir field in ~/.obey/campaign/config.json.

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
  -d, --description string   Camp description
      --dry-run              Show what would be done without creating anything
  -h, --help                 help for create
  -m, --mission string       Camp mission statement
  -n, --name string          Camp display name (defaults to <name> positional)
      --no-git               Skip git repository initialization
      --no-skills            Skip linking camp skills into .claude/skills and .agents/skills
      --org string           Assign the new camp to this org (created if new; defaults to the fallback org)
      --path string          Override the base camps directory (camp created at <path>/<name>/)
  -t, --type string          Camp type (product, research, tools, personal) (default "product")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
