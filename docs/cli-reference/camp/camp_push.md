---
title: "camp push"
linkTitle: "camp push"
description: "Push camp changes to remote"
---

## camp push

Push camp changes to remote

### Synopsis

Push camp changes to the remote repository.

Works from anywhere within the camp - always pushes from
the camp root repository.

Use --sub to push from the submodule detected from your current directory.
Use --project to push from a specific project.
Use 'camp push all' to push all repos that have unpushed commits.

Examples:
  camp push                    # Push current branch
  camp push origin main        # Push to specific remote/branch
  camp push --force            # Force push
  camp push -u origin feature  # Push and set upstream
  camp push --sub              # Push current submodule
  camp push --project=projects/camp  # Push camp project
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
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp push all](../camp_push_all/)	 - Push all repos with unpushed commits
