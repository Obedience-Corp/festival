## camp push all

Push all repos with unpushed commits

### Synopsis

Push all repositories in the campaign that have unpushed commits.

Scans all submodules and the campaign root, checks which have commits
ahead of their upstream, and pushes them. Any extra flags are passed
through to git push for each repo.

By default, nested submodules (e.g. inside monorepos) are included.
Use --no-recurse to only push top-level submodules.

Examples:
  camp push all              # Push all repos with unpushed commits
  camp push all --force      # Force push all repos
  camp push all -u origin    # Push and set upstream for all
  camp push all --no-recurse # Only top-level submodules

```
camp push all [git push flags] [flags]
```

### Options

```
  -h, --help   help for all
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp push](camp_push.md)	 - Push campaign changes to remote

