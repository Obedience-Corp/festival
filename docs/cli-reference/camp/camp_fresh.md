---
title: "camp fresh"
linkTitle: "camp fresh"
description: "Post-merge branch cycling: sync to default branch and optionally create a new working branch"
---

## camp fresh

Post-merge branch cycling: sync to default branch and optionally create a new working branch

### Synopsis

Reset one or more projects to a fresh state after merging a PR.

Performs the post-merge cycle: checkout the default branch, fetch origin,
sync to the remote default while preserving local-only commits, prune merged
branches, and optionally create a new working branch.

Auto-detects the current project from your working directory, or accepts a
single project name. Use --list to cycle a specific set of projects in one
run, or 'camp fresh all' to cycle every project submodule in the campaign.

Without configuration, syncs to the default branch and prunes.
Configure .campaign/settings/fresh.yaml to set a default working branch, or
follow-up command workflows (install, build, bootstrap, ...) to run once the
cycle succeeds. Manage those with 'camp fresh configure'. Inspect the resolved
sequence with 'camp fresh show-workflow [project-name]'.

WORKITEM COMPLETION

Two fresh.yaml settings decide what happens to workitems whose work looks done:

  completed_runs     Tier 1, once per run, campaign-root scoped. "prompt"
                     (default) asks per workitem on a TTY and reports otherwise,
                     "report" prints a read-only banner and the reason for every
                     non-move, "sweep" promotes automatically (the pre-2026-08
                     behavior), "off" skips it. This is the same work
                     'camp workitem sweep' performs.
  merged_workitems   Tier 2, per project. A workitem whose branch merged is
                     inferred evidence, so it never auto-promotes: "prompt"
                     asks on a TTY and reports otherwise, "report" prints the
                     exact promote commands to run, "off" skips it.

completed_runs asks rather than sweeps because a completed workflow run is not
the same claim for every kind of work. For a bug or a chore the loop was the
work. For explore and research it means findings now exist and need a home, so
the prompt offers to route them into docs/ instead of burying them. For a design
it means a specification exists that nobody has built yet, so a completed run
never promotes one; a design waits for a merged branch or a completed festival.

Both settings are configured in fresh.yaml, not by flags. See
'camp fresh configure'.

Examples:
  camp fresh                            # Sync current project (checkout default, fetch, prune)
  camp fresh --branch develop           # Sync and create develop branch
  camp fresh camp -b feat/new-thing     # Sync camp project, create feature branch
  camp fresh --list camp,fest,festival  # Sync a specific set of projects
  camp fresh --no-prune                 # Sync without pruning
  camp fresh --no-follow-up             # Sync without running configured follow-ups
  camp fresh --dry-run                  # Preview what would happen (follow-ups listed, not run)

  camp fresh --branch feat/aggregate-CW0003 --cleanup-stack
                                        # Switch to an existing aggregate branch and
                                        # remove child worktrees merged into it
                                        # (ancestry or squash/patch-id). Refuses
                                        # main/master unless --allow-default-target.
                                        # Worktrees whose branches also landed on
                                        # the default branch are skipped (not stack
                                        # children). The default-branch prune still
                                        # runs first; pass --no-prune to skip it.
  camp fresh --branch feat/aggregate-CW0003 --cleanup-stack --dry-run
                                        # Preview the stack cleanup plan without removing anything

```
camp fresh [project-name] [flags]
```

### Options

```
      --allow-default-target   Permit --cleanup-stack against the default branch (main/master). Without this, cleanup-stack refuses default-branch targets because every merged feature worktree would look like a stack child
  -b, --branch string          Branch to create after syncing (overrides config)
      --cleanup-stack          Target an existing aggregate branch and remove child worktrees merged into it by ancestry or squash (requires --branch; refuses the default branch unless --allow-default-target)
  -n, --dry-run                Preview without making changes
  -h, --help                   help for fresh
      --list strings           Comma-separated set of projects to cycle in one run
      --no-branch              Skip branch creation even if configured
      --no-drain               Do not wait for camp's queued commits first
      --no-follow-up           Skip configured follow-up command workflows
      --no-prune               Skip pruning merged branches
      --no-push                Skip pushing the new branch upstream
  -p, --project string         Project name (auto-detected from cwd)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp fresh all](../camp_fresh_all/)	 - Run fresh across all project submodules
* [camp fresh configure](../camp_fresh_configure/)	 - Configure the camp fresh workflow
* [camp fresh show-workflow](../camp_fresh_show-workflow/)	 - Show the fresh cycle and configured follow-up steps
