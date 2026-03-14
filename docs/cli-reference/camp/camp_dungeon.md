---
title: "camp dungeon"
linkTitle: "camp dungeon"
description: "Manage the campaign dungeon"
---

## camp dungeon

Manage the campaign dungeon

### Synopsis

Manage the campaign dungeon - a holding area for uncertain work.

The dungeon is where you put work you're unsure about or want out of the way.
It keeps items visible without them competing for your attention.

Commands:
  add     Initialize dungeon structure with documentation
  crawl   Interactive review and archival of dungeon contents
  list    List dungeon items (agent-friendly)
  move    Move items between dungeon statuses (agent-friendly)

Examples:
  camp dungeon add                        Initialize the dungeon
  camp dungeon crawl                      Review and archive dungeon items
  camp dungeon list                       List dungeon root items
  camp dungeon list --triage              List parent items eligible for triage
  camp dungeon move old-feature archived  Move item to archived status

```
camp dungeon [flags]
```

### Options

```
  -h, --help   help for dungeon
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp dungeon add](../camp_dungeon_add/)	 - Initialize dungeon structure
* [camp dungeon crawl](../camp_dungeon_crawl/)	 - Interactive dungeon review
* [camp dungeon list](../camp_dungeon_list/)	 - List dungeon items
* [camp dungeon move](../camp_dungeon_move/)	 - Move dungeon items between statuses
