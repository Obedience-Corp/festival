---
title: "camp status"
linkTitle: "camp status"
description: "Show git status of the campaign"
---

## camp status

Show git status of the campaign

### Synopsis

Show git status of the campaign root directory.

Works from anywhere within the campaign - always shows the status
of the campaign root repository.

Use --sub to show status of the submodule detected from your current directory.
Use --project/-p to show status of a specific project.
Pass git status flags after -- to forward them directly to git.

```
camp status [flags] [-- <git-flags>]
```

### Examples

```
  camp status           # Full status
  camp status -s        # Short format
  camp status --sub     # Status of current submodule
  camp status -p projects/camp  # Status of camp project
```

### Options

```
  -h, --help             help for status
      --no-drain         Do not wait for camp's queued commits first
  -p, --project string   Status of a specific project path
  -s, --short            Give output in short format
      --show-refs        Show campaign root submodule ref changes
      --sub              Status of the submodule detected from current directory
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp status all](../camp_status_all/)	 - Show git status of all submodules
