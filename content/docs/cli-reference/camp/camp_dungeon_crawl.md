## camp dungeon crawl

Interactive dungeon review

### Synopsis

Interactively review and archive dungeon contents.

Without flags, auto-detects what to crawl:
  - Parent items exist → triage mode (move items into dungeon)
  - Dungeon items exist → inner mode (keep/archive dungeon items)
  - Both exist → runs triage first, then inner

Use --triage or --inner to force a specific mode.

For each item, you'll be prompted to decide its fate.
Statistics are gathered when available (requires scc or fest).
All decisions are logged to crawl.jsonl for history.

Examples:
  camp dungeon crawl            Auto-detect mode
  camp dungeon crawl --triage   Force triage mode only
  camp dungeon crawl --inner    Force inner mode only

```
camp dungeon crawl [flags]
```

### Options

```
  -h, --help     help for crawl
      --inner    Force inner mode (review dungeon items)
      --triage   Force triage mode (review parent items)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp dungeon](camp_dungeon.md)	 - Manage the campaign dungeon

