---
title: "camp pull all"
linkTitle: "camp pull all"
description: "Pull latest changes for all repos"
---

## camp pull all

Pull latest changes for all repos

### Synopsis

Pull latest changes for all repositories in the camp.

Scans the camp root and all submodules, checks which have a tracking
branch with upstream, and pulls them. Any extra flags are passed through
to git pull for each repo.

Repos in detached HEAD state or without upstream tracking are skipped.
Use --default-branch to auto-checkout each submodule's default branch
before pulling. This is useful when submodules are on stale feature
branches whose remote tracking branch has been deleted.

By default, nested submodules (e.g. inside monorepos) are included.
Use --no-recurse to only pull top-level submodules.

The camp root pulls first, then submodules pull concurrently (8 at a
time by default; set with --parallel N). Results print in .gitmodules
order. In a terminal, a live area below the results shows the repos
pulling right now and overall progress; piped output prints one plain
line per repo.

Examples:
  camp pull all                      # Pull all repos
  camp pull all --rebase             # Pull all repos with rebase
  camp pull all --ff-only            # Fast-forward only for all repos
  camp pull all --no-recurse         # Only top-level submodules
  camp pull all --default-branch     # Checkout default branch first
  camp pull all --parallel 2         # Pull at most 2 submodules at once

```
camp pull all [git pull flags] [flags]
```

### Options

```
  -h, --help   help for all
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp pull](../camp_pull/)	 - Pull latest changes from remote
