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
      --config string   config file (default: ~/.obey/campaign/config.yaml)
  -h, --help            help for camp
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp cache](camp_cache.md)	 - Manage the navigation index cache
* [camp clone](camp_clone.md)	 - Clone a campaign with full submodule setup
* [camp commit](camp_commit.md)	 - Commit changes in the campaign root
* [camp completion](camp_completion.md)	 - Generate the autocompletion script for the specified shell
* [camp concepts](camp_concepts.md)	 - List configured concepts
* [camp copy](camp_copy.md)	 - Copy a file or directory within the campaign
* [camp date](camp_date.md)	 - Append date suffix to file or directory name
* [camp doctor](camp_doctor.md)	 - Diagnose and fix campaign health issues
* [camp dungeon](camp_dungeon.md)	 - Manage the campaign dungeon
* [camp gather](camp_gather.md)	 - Import external data into the intent system
* [camp go](camp_go.md)	 - Navigate to campaign directories
* [camp init](camp_init.md)	 - Initialize a new campaign
* [camp intent](camp_intent.md)	 - Manage campaign intents
* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects
* [camp list](camp_list.md)	 - List all registered campaigns
* [camp log](camp_log.md)	 - Show git log of the campaign
* [camp move](camp_move.md)	 - Move a file or directory within the campaign
* [camp pin](camp_pin.md)	 - Bookmark a directory
* [camp pins](camp_pins.md)	 - List all pinned directories
* [camp project](camp_project.md)	 - Manage campaign projects
* [camp pull](camp_pull.md)	 - Pull latest changes from remote
* [camp push](camp_push.md)	 - Push campaign changes to remote
* [camp refs-sync](camp_refs-sync.md)	 - Sync submodule ref pointers in campaign root
* [camp register](camp_register.md)	 - Register campaign in global registry
* [camp registry](camp_registry.md)	 - Manage the campaign registry
* [camp run](camp_run.md)	 - Execute command from campaign root, or just recipe in a project
* [camp settings](camp_settings.md)	 - Manage camp configuration
* [camp shell-init](camp_shell-init.md)	 - Output shell initialization code
* [camp shortcuts](camp_shortcuts.md)	 - List all available shortcuts
* [camp skills](camp_skills.md)	 - Manage campaign skill directory links
* [camp status](camp_status.md)	 - Show git status of the campaign
* [camp switch](camp_switch.md)	 - Switch to a different campaign
* [camp sync](camp_sync.md)	 - Safely synchronize submodules
* [camp transfer](camp_transfer.md)	 - Copy files between campaigns
* [camp unpin](camp_unpin.md)	 - Remove a directory bookmark
* [camp unregister](camp_unregister.md)	 - Remove campaign from registry
* [camp version](camp_version.md)	 - Show version information

