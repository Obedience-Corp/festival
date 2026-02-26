## camp leverage reset

Clear all cached leverage data to allow full recomputation

### Synopsis

Reset deletes cached snapshots and blame data so that leverage can
recompute from scratch.

Without flags, all project caches are removed. Use --project to clear
only a single project's data.

Examples:
  camp leverage reset                    Clear all cached data
  camp leverage reset --project camp     Clear only camp's cached data

```
camp leverage reset [flags]
```

### Options

```
  -h, --help             help for reset
  -p, --project string   clear snapshots for a single project
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects

