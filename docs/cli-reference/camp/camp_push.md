---
title: "camp push"
linkTitle: "camp push"
description: "Push campaign changes to remote"
---

## camp push

Push campaign changes to remote

### Synopsis

Push campaign changes to the remote repository.

Works from anywhere within the campaign - always pushes from
the campaign root repository.

Use --sub to push from the submodule detected from your current directory.
Use --project/-p to push from a specific project.
Use 'camp push all' to push all repos that have unpushed commits.

Examples:
  camp push                    # Push current branch
  camp push origin main        # Push to specific remote/branch
  camp push --force            # Force push
  camp push -u origin feature  # Push and set upstream
  camp push --sub              # Push current submodule
  camp push -p projects/camp   # Push camp project
  camp push all                # Push all repos with unpushed commits
  camp push all --force        # Force push all repos

```
camp push [flags] [remote] [branch]
```

### Options

```
  -h, --help   help for push
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp push all](../camp_push_all/)	 - Push all repos with unpushed commits
