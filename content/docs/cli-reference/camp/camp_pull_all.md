## camp pull all

Pull latest changes for all repos

### Synopsis

Pull latest changes for all repositories in the campaign.

Scans the campaign root and all submodules, checks which have a tracking
branch with upstream, and pulls them. Any extra flags are passed through
to git pull for each repo.

Repos in detached HEAD state or without upstream tracking are skipped.
Use --default-branch to auto-checkout each submodule's default branch
before pulling. This is useful when submodules are on stale feature
branches whose remote tracking branch has been deleted.

By default, nested submodules (e.g. inside monorepos) are included.
Use --no-recurse to only pull top-level submodules.

Examples:
  camp pull all                      # Pull all repos
  camp pull all --rebase             # Pull all repos with rebase
  camp pull all --ff-only            # Fast-forward only for all repos
  camp pull all --no-recurse         # Only top-level submodules
  camp pull all --default-branch     # Checkout default branch first

```
camp pull all [git pull flags] [flags]
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

* [camp pull](camp_pull.md)	 - Pull latest changes from remote

