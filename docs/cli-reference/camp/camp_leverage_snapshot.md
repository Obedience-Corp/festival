## camp leverage snapshot

Capture current leverage state as a snapshot

### Synopsis

Capture the current leverage state for all projects (or a specific project)
and save as JSON snapshots for historical tracking.

Each snapshot includes scc metrics, computed leverage scores, and per-author
LOC attribution from git blame.

Snapshots are stored in .campaign/leverage/snapshots/<project>/<date>.json.
Re-running on the same date overwrites the previous snapshot.

Examples:
  camp leverage snapshot                  Snapshot all projects
  camp leverage snapshot --project camp   Snapshot specific project

```
camp leverage snapshot [flags]
```

### Options

```
  -h, --help             help for snapshot
  -p, --project string   snapshot a specific project only
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects

