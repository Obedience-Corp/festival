---
title: "Everyday Development in a Camp"
linkTitle: "Everyday Development"
description: "Move between camp work, isolate changes in worktrees, and reset projects safely after a merge."
---

# Everyday Development in a Camp

A camp gives planning files and one or more codebases a shared home. Day to day,
that means less path hunting, separate directories for concurrent changes, and a
repeatable post-merge reset. The commands below keep those jobs separate: `camp`
manages the workspace and `fest` manages a festival plan.

## Move where the work is

Shell integration adds `cgo`, a function that can change the directory of the
shell you are using. Use the packaged helper when it is available, or the
dynamic setup shown in [Shell Setup]({{< ref "/getting-started/shell-setup" >}}).
For a zsh session without the packaged helper:

```bash
eval "$(camp shell-init zsh)"
```

Then move by category or project name instead of spelling out long paths:

```bash
cgo              # camp root, or toggle back to the last location
cgo p            # projects/
cgo p api        # fuzzy-match a project under projects/
cgo f            # festivals/
cgo w            # workflow/
cgo i            # .campaign/intents/
```

Run `camp shortcuts` to see the shortcuts defined for this camp. `camp go`
resolves the same targets but does not change your current shell, which makes it
useful in scripts:

```bash
cd "$(camp go p --print)"
```

When you need another registered camp, `csw` is the shell shortcut for `camp
switch`. It opens a picker without an argument or accepts a camp name, ID prefix,
or an `org/camp` selector:

```bash
csw client-work
csw obey/platform
```

`csw` changes the shell's directory. Plain `camp switch` can resolve a target,
but needs `--print` and `cd` when you are not using the shell wrapper. See the
[shell-init reference]({{< ref "/cli-reference/camp/camp_shell-init" >}}) and
[switch reference]({{< ref "/cli-reference/camp/camp_switch" >}}) for the full
set of shell and remote-camp options.

## Give each change its own directory

Use a Git worktree when two changes in the same repository need to stay checked
out at once. Camp creates its managed worktrees under
`projects/worktrees/<project>/<worktree-name>/`, so they remain visible beside
the rest of the camp.

```bash
# From anywhere in the camp, create a branch and working directory.
camp project worktree add feature-search --project api --start-point main

# Check the directories Git knows about for this project.
camp project worktree list --project api
```

The first command creates a new branch named `feature-search` unless you choose
an existing branch with `--branch` or a remote branch with `--track`. Give an
agent the resulting worktree path when it should work independently from your
main checkout. Remove a worktree only after its changes are merged or otherwise
safe to discard. The [worktree reference]({{< ref "/cli-reference/camp/camp_project_worktree" >}})
covers those choices and the removal command.

## Start clean after a merge

After a pull request lands, preview the reset before changing anything:

```bash
camp fresh api --dry-run
```

The normal cycle checks out the project's default branch, fetches `origin`,
synchronizes to the remote default while retaining local-only commits, and
prunes merged branches. When the preview looks right, run it without `--dry-run`:

```bash
camp fresh api
```

By default, `camp fresh` synchronizes and prunes. A camp can also configure a
new working branch and follow-up commands such as bootstrap or build steps in
`.campaign/settings/fresh.yaml`. Inspect that resolved sequence before relying
on it:

```bash
camp fresh show-workflow api
```

Use `--no-follow-up` to skip configured commands. If a working branch is
configured or supplied with `--branch`, fresh pushes that new branch unless you
pass `--no-push`. `--no-prune` leaves merged branches alone.

For a camp-wide preview, use:

```bash
camp fresh all --dry-run
```

`all` cycles every project submodule in the camp. It does not include linked
external projects, so run `camp fresh <project-name> --dry-run` for those.
Read the [fresh reference]({{< ref "/cli-reference/camp/camp_fresh" >}}) and
[fresh-all reference]({{< ref "/cli-reference/camp/camp_fresh_all" >}}) before
using pruning, branch creation, or configured follow-ups on unfamiliar work.
