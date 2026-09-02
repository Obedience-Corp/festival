---
title: "camp"
linkTitle: "camp"
description: "Manage your camps and the projects and festivals inside them"
---

## camp

Manage your camps and the projects and festivals inside them

### Synopsis

Camp manages your camps.

A camp is one context in your life: your job, a side project, your taxes. Each
camp holds the projects you work on and hosts the festivals you run in them.
Camp creates camps, manages git submodules as projects, and gives you
lightning-fast navigation through category shortcuts and TUI fuzzy finding.

Camp stores each camp's state in the .campaign/ directory. That name is
stable, so do not rename it. The separate .camp file is an attachment marker
for linked external directories, not a replacement for .campaign/.

GETTING STARTED:
  camp init               Initialize a new camp in the current directory
  camp project list       List all projects in the camp
  camp list               Show all registered camps

NAVIGATION (using cgo shell function):
  cgo                     Navigate to camp root
  cgo p                   Navigate to projects directory
  cgo f                   Navigate to festivals directory
  cgo <name>              Fuzzy find and navigate to any target

COMMON WORKFLOWS:
  camp project add <url>  Add a git repo as a project submodule
  camp run <command>      Run command from camp root directory
  camp shortcuts          View all available navigation shortcuts

Run 'camp shell-init' to enable the cgo navigation function.

```
camp [flags]
```

### Options

```
  -h, --help       help for camp
      --no-color   disable colored output
```

### SEE ALSO

* [camp artifacts](../camp_artifacts/)	 - Manage declared artifact roots (.campaign/artifacts.yaml)
* [camp attach](../camp_attach/)	 - Attach an external directory to a camp
* [camp cache](../camp_cache/)	 - Manage the navigation index cache
* [camp clone](../camp_clone/)	 - Clone a camp with full submodule setup
* [camp commit](../camp_commit/)	 - Commit changes in the camp root
* [camp completion](../camp_completion/)	 - Generate the autocompletion script for the specified shell
* [camp concepts](../camp_concepts/)	 - List configured concepts
* [camp copy](../camp_copy/)	 - Copy a file or directory within the camp
* [camp create](../camp_create/)	 - Create a new camp at the default camps directory
* [camp date](../camp_date/)	 - Append date suffix to file or directory name
* [camp detach](../camp_detach/)	 - Remove the current camp's attachment binding
* [camp doctor](../camp_doctor/)	 - Diagnose and fix camp health issues
* [camp dungeon](../camp_dungeon/)	 - Manage the camp dungeon
* [camp festivals](../camp_festivals/)	 - List festivals across camps, filtered by org/tag
* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
* [camp gather](../camp_gather/)	 - Gather related work into unified items
* [camp go](../camp_go/)	 - Navigate to camp directories
* [camp id](../camp_id/)	 - Print the current camp ID
* [camp idea](../camp_idea/)	 - Manage camp ideas
* [camp init](../camp_init/)	 - Initialize a new camp
* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
* [camp leverage](../camp_leverage/)	 - Compute leverage scores for the camp's projects
* [camp lifecycle](../camp_lifecycle/)	 - Manage camp lifecycle status
* [camp list](../camp_list/)	 - List all registered camps
* [camp log](../camp_log/)	 - Show git log of the camp
* [camp machine](../camp_machine/)	 - Manage remote machines (~/.obey/machines.yaml)
* [camp move](../camp_move/)	 - Move a file or directory within the camp
* [camp notify](../camp_notify/)	 - Manage camp state notices
* [camp org](../camp_org/)	 - Group camps into orgs
* [camp pack](../camp_pack/)	 - Pack a directory into a portable .festival bundle
* [camp pin](../camp_pin/)	 - Pin a directory
* [camp pins](../camp_pins/)	 - List all pinned directories
* [camp plugins](../camp_plugins/)	 - List discovered camp plugins on PATH
* [camp project](../camp_project/)	 - Manage camp projects
* [camp promote](../camp_promote/)	 - Promote any intent, workitem, or festival (universal front door)
* [camp pull](../camp_pull/)	 - Pull latest changes from remote
* [camp push](../camp_push/)	 - Push camp changes to remote
* [camp refs-sync](../camp_refs-sync/)	 - Sync submodule ref pointers in camp root
* [camp register](../camp_register/)	 - Register a camp in the global registry
* [camp registry](../camp_registry/)	 - Manage the camp registry
* [camp root](../camp_root/)	 - Print the current camp root
* [camp run](../camp_run/)	 - Execute command from camp root, or just recipe in a project
* [camp settings](../camp_settings/)	 - Manage camp configuration
* [camp shell-init](../camp_shell-init/)	 - Output shell initialization code
* [camp shortcuts](../camp_shortcuts/)	 - List all available shortcuts
* [camp skills](../camp_skills/)	 - Manage camp skill directory links
* [camp stage](../camp_stage/)	 - Stage changes in the camp root
* [camp status](../camp_status/)	 - Show git status of the camp
* [camp switch](../camp_switch/)	 - Switch to a different camp
* [camp sync](../camp_sync/)	 - Safely synchronize submodules
* [camp tag](../camp_tag/)	 - Label camps with tags
* [camp transfer](../camp_transfer/)	 - Copy files between camps (and machines)
* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
* [camp unbundle](../camp_unbundle/)	 - Unbundle a .festival archive into a directory
* [camp unpin](../camp_unpin/)	 - Remove a saved pin
* [camp unregister](../camp_unregister/)	 - Remove a camp from the registry
* [camp version](../camp_version/)	 - Show version information
* [camp workflow](../camp_workflow/)	 - Manage workflow collections
* [camp workitem](../camp_workitem/)	 - View active camp work items
