## camp flow

Manage status workflows for organizing work

### Synopsis

Manage status workflows for organizing work.

A workflow defines status directories that items can move between,
with optional transition rules and history tracking. The workflow is
configured via a .workflow.yaml file.

GETTING STARTED:
  camp flow init              Initialize a new workflow
  camp flow sync              Create missing directories from schema
  camp flow status            Show workflow statistics

MANAGING ITEMS:
  camp flow list              List registered flows
  camp flow items             List items in a status directory
  camp flow move <item> <to>  Move an item to a new status

RUNNING FLOWS:
  camp flow run <name>        Execute a registered flow
  camp flow                   Interactive flow picker

OTHER COMMANDS:
  camp flow show              Display workflow structure
  camp flow history           View transition history
  camp flow migrate           Upgrade legacy dungeon structure

DEFAULT STRUCTURE:
  active/                Work in progress
  ready/                 Prepared for action
  dungeon/
    completed/           Successfully finished
    archived/            Preserved but inactive
    someday/             Maybe later

Customize by editing .workflow.yaml and running 'camp flow sync'.

```
camp flow [flags]
```

### Options

```
  -h, --help   help for flow
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp flow add](camp_flow_add.md)	 - Add workflow tracking to current directory
* [camp flow items](camp_flow_items.md)	 - List items in a status directory
* [camp flow list](camp_flow_list.md)	 - List registered flows from the registry
* [camp flow migrate](camp_flow_migrate.md)	 - Migrate workflow to latest schema version
* [camp flow move](camp_flow_move.md)	 - Move an item to a new status
* [camp flow run](camp_flow_run.md)	 - Execute a registered flow by name
* [camp flow show](camp_flow_show.md)	 - Show workflow structure
* [camp flow status](camp_flow_status.md)	 - Show workflow statistics
* [camp flow sync](camp_flow_sync.md)	 - Sync directories with schema

