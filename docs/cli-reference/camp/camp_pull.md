---
title: "camp pull"
linkTitle: "camp pull"
description: "Pull latest changes from remote"
---

## camp pull

Pull latest changes from remote

### Synopsis

Pull latest changes from the remote repository.

Works from anywhere within the camp - always pulls to
the camp root repository.

Use --sub to pull the submodule detected from your current directory.
Use --project to pull a specific project.
Use 'camp pull all' to pull all repos with upstream tracking.

Any git pull flags are passed through (e.g. --rebase, --ff-only).

Examples:
  camp pull                    # Pull current branch (merge)
  camp pull --rebase           # Pull with rebase
  camp pull --ff-only          # Fast-forward only
  camp pull --sub              # Pull current submodule
  camp pull --project=projects/camp  # Pull camp project
  camp pull all                # Pull all repos
  camp pull all --ff-only      # Pull all repos, fast-forward only

```
camp pull [flags] [remote] [branch]
```

### Options

```
  -h, --help   help for pull
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp pull all](../camp_pull_all/)	 - Pull latest changes for all repos
