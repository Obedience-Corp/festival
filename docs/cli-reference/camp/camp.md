---
title: "camp"
linkTitle: "camp"
description: "Campaign management CLI for multi-project AI workspaces"
---

## camp

Campaign management CLI for multi-project AI workspaces

### Synopsis

Camp manages multi-project AI workspaces with fast navigation.

Camp provides structure and navigation for AI-powered development workflows.
It creates standardized campaign directories, manages git submodules as projects,
and enables lightning-fast navigation through category shortcuts and TUI fuzzy finding.

GETTING STARTED:
  camp init               Initialize a new campaign in the current directory
  camp project list       List all projects in the campaign
  camp list               Show all registered campaigns

NAVIGATION (using cgo shell function):
  cgo                     Navigate to campaign root
  cgo p                   Navigate to projects directory
  cgo f                   Navigate to festivals directory
  cgo <name>              Fuzzy find and navigate to any target

COMMON WORKFLOWS:
  camp project add <url>  Add a git repo as a project submodule
  camp run <command>      Run command from campaign root directory
  camp shortcuts          View all available navigation shortcuts

Run 'camp shell-init' to enable the cgo navigation function.

```
camp [flags]
```

### Options

```
      --config string   config file (default: ~/.obey/campaign/config.json)
  -h, --help            help for camp
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp cache](../camp_cache/)	 - Manage the navigation index cache
* [camp clone](../camp_clone/)	 - Clone a campaign with full submodule setup
* [camp commit](../camp_commit/)	 - Commit changes in the campaign root
* [camp completion](../camp_completion/)	 - Generate the autocompletion script for the specified shell
* [camp concepts](../camp_concepts/)	 - List configured concepts
* [camp copy](../camp_copy/)	 - Copy a file or directory within the campaign
* [camp date](../camp_date/)	 - Append date suffix to file or directory name
* [camp doctor](../camp_doctor/)	 - Diagnose and fix campaign health issues
* [camp dungeon](../camp_dungeon/)	 - Manage the campaign dungeon
* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
* [camp gather](../camp_gather/)	 - Import external data into the intent system
* [camp go](../camp_go/)	 - Navigate to campaign directories
* [camp id](../camp_id/)	 - Print the current campaign ID
* [camp init](../camp_init/)	 - Initialize a new campaign
* [camp intent](../camp_intent/)	 - Manage campaign intents
* [camp leverage](../camp_leverage/)	 - Compute leverage scores for campaign projects
* [camp list](../camp_list/)	 - List all registered campaigns
* [camp log](../camp_log/)	 - Show git log of the campaign
* [camp move](../camp_move/)	 - Move a file or directory within the campaign
* [camp pin](../camp_pin/)	 - Pin a directory
* [camp pins](../camp_pins/)	 - List all pinned directories
* [camp plugins](../camp_plugins/)	 - List discovered camp plugins on PATH
* [camp project](../camp_project/)	 - Manage campaign projects
* [camp pull](../camp_pull/)	 - Pull latest changes from remote
* [camp push](../camp_push/)	 - Push campaign changes to remote
* [camp refs-sync](../camp_refs-sync/)	 - Sync submodule ref pointers in campaign root
* [camp register](../camp_register/)	 - Register campaign in global registry
* [camp registry](../camp_registry/)	 - Manage the campaign registry
* [camp root](../camp_root/)	 - Print the current campaign root
* [camp run](../camp_run/)	 - Execute command from campaign root, or just recipe in a project
* [camp settings](../camp_settings/)	 - Manage camp configuration
* [camp shell-init](../camp_shell-init/)	 - Output shell initialization code
* [camp shortcuts](../camp_shortcuts/)	 - List all available shortcuts
* [camp skills](../camp_skills/)	 - Manage campaign skill directory links
* [camp status](../camp_status/)	 - Show git status of the campaign
* [camp switch](../camp_switch/)	 - Switch to a different campaign
* [camp sync](../camp_sync/)	 - Safely synchronize submodules
* [camp transfer](../camp_transfer/)	 - Copy files between campaigns
* [camp unpin](../camp_unpin/)	 - Remove a saved pin
* [camp unregister](../camp_unregister/)	 - Remove campaign from registry
* [camp version](../camp_version/)	 - Show version information
