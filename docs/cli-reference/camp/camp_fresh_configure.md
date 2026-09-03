---
title: "camp fresh configure"
linkTitle: "camp fresh configure"
description: "Configure the camp fresh workflow"
---

## camp fresh configure

Configure the camp fresh workflow

### Synopsis

Configure what camp fresh does after a merge. Configuration lives in
.campaign/settings/fresh.yaml, as camp-wide defaults plus optional
per-project overrides.

Run without a subcommand to open the interactive setup for humans, which
groups the fresh sequence by what you can change about each step:

  Sync        checkout, fetch, and safe default-branch realignment; always runs
  Settings    branch, push_upstream, prune, and prune_remote
  Follow-ups  your own commands, run after a successful cycle

Press enter on a settings step to change it, and a/e/d/K/J on a follow-up to
add, edit, delete, or reorder it. prune and prune_remote are camp-wide,
so they are changed under Global defaults rather than under a project.

The subcommands below cover follow-ups only, for scripts and agents; edit the
other keys in the interactive setup or in fresh.yaml directly.

The interactive setup opens on the project you are standing in, resolved the
same way camp fresh picks its target, so the overrides you edit are the ones
that run. Pass --project to open on a different project, and edit the global
defaults by selecting them in the left pane.

Examples:
  camp fresh configure
  camp fresh configure --project camp
  camp fresh show-workflow camp
  camp fresh configure show
  camp fresh configure add install --run "npm install"
  camp fresh configure add build --run "go build ./..." --project camp --dir cmd/camp
  camp fresh configure move build --up --project camp
  camp fresh configure remove install
  camp fresh configure remove build --project camp

```
camp fresh configure [flags]
```

### Options

```
  -h, --help             help for configure
      --project string   Open the setup on a project scope (default: detected from the current directory)
```

### Options inherited from parent commands

```
      --allow-default-target   Permit --cleanup-stack against the default branch (main/master). Without this, cleanup-stack refuses default-branch targets because every merged feature worktree would look like a stack child
  -b, --branch string          Branch to create after syncing (overrides config)
      --cleanup-stack          Target an existing aggregate branch and remove child worktrees merged into it by ancestry or squash (requires --branch; refuses the default branch unless --allow-default-target)
  -n, --dry-run                Preview without making changes
      --no-branch              Skip branch creation even if configured
      --no-color               disable colored output
      --no-follow-up           Skip configured follow-up command workflows
      --no-prune               Skip pruning merged branches
      --no-push                Skip pushing the new branch upstream
```

### SEE ALSO

* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
* [camp fresh configure add](../camp_fresh_configure_add/)	 - Add a follow-up command workflow step
* [camp fresh configure move](../camp_fresh_configure_move/)	 - Move a follow-up command workflow step
* [camp fresh configure remove](../camp_fresh_configure_remove/)	 - Remove a follow-up command workflow step
* [camp fresh configure show](../camp_fresh_configure_show/)	 - Show configured follow-up workflows
