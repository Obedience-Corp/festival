---
title: "camp CLI Reference"
weight: 1
---

# camp CLI Reference

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
      --config string   config file (default: ~/.obey/campaign/config.yaml)
  -h, --help            help for camp
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp cache

Manage the navigation index cache

### Synopsis

Manage the navigation index cache used for fast project lookups.

```
camp cache [flags]
```

### Options

```
  -h, --help   help for cache
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp cache clear

Delete the navigation cache

### Synopsis

Delete the cached navigation index. It will be rebuilt on next navigation.

```
camp cache clear [flags]
```

### Options

```
  -h, --help   help for clear
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp cache info

Show cache status and metadata

### Synopsis

Show information about the navigation index cache including path, size, age, and staleness.

```
camp cache info [flags]
```

### Options

```
  -h, --help   help for info
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp cache rebuild

Force rebuild the navigation cache

### Synopsis

Force rebuild the navigation index cache, regardless of staleness.

```
camp cache rebuild [flags]
```

### Options

```
  -h, --help   help for rebuild
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp clone

Clone a campaign with full submodule setup

### Synopsis

Clone a campaign repository and initialize all submodules.

This command provides a single-step setup for new devices:

  1. CLONE REPOSITORY
     Clones the campaign repository with recursive submodules.

  2. SYNCHRONIZE URLs
     Copies URLs from .gitmodules to .git/config, ensuring
     URL consistency across all submodules.

  3. UPDATE SUBMODULES
     Fetches and checks out the correct commits for all submodules.

  4. VALIDATE SETUP
     Verifies all submodules are initialized, at correct commits,
     and have matching URLs.

  5. REGISTER CAMPAIGN
     If .campaign/campaign.yaml exists, registers the campaign
     in the global registry for navigation and discovery.

EXIT CODES:
  0  Success
  1  Clone failed (no campaign created)
  2  Partial success (some submodules failed)
  3  Validation failed
  4  Invalid arguments

EXAMPLES:
  # Clone a campaign (default: SSH)
  camp clone git@github.com:Obedience-Corp/obey-campaign.git

  # Clone with HTTPS
  camp clone https://github.com/Obedience-Corp/obey-campaign.git

  # Clone to a specific directory
  camp clone git@github.com:org/repo.git my-campaign

  # Clone a specific branch
  camp clone git@github.com:org/repo.git --branch develop

  # Shallow clone (latest commit only)
  camp clone git@github.com:org/repo.git --depth 1

  # Clone without submodules
  camp clone git@github.com:org/repo.git --no-submodules

  # Clone without validation
  camp clone git@github.com:org/repo.git --no-validate

  # Clone without auto-registration
  camp clone git@github.com:org/repo.git --no-register

  # JSON output for scripting
  camp clone git@github.com:org/repo.git --json

```
camp clone <url> [directory] [flags]
```

### Options

```
  -b, --branch string   Clone specific branch (default: repository default branch)
      --depth int       Shallow clone depth (0 = full history)
  -h, --help            help for clone
      --json            Output results as JSON for scripting
      --no-register     Skip auto-registration in global campaign registry
      --no-submodules   Skip submodule initialization
      --no-validate     Skip post-clone validation
  -p, --parallel int    Number of parallel submodule initializations (default 4)
  -v, --verbose         Show detailed output for each operation
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```
---

## camp commit

Commit changes in the campaign root

### Synopsis

Commit changes in the campaign root directory.

Automatically stages all changes and creates a commit. Handles
stale lock files from crashed processes.

At the campaign root, submodule ref changes (projects/*) are excluded
from staging by default to prevent accidental ref conflicts across
machines. Use --include-refs to stage them explicitly.

Use --sub to commit in the submodule detected from your current directory.
Use -p/--project to commit in a specific project (e.g., -p projects/camp).

Examples:
  camp commit -m "Add new feature"
  camp commit --amend -m "Fix typo"
  camp commit -a -m "Stage and commit all"
  camp commit --include-refs -m "Sync all submodule refs"
  camp commit --sub -m "Commit in current submodule"
  camp commit -p projects/camp -m "Commit in camp project"

```
camp commit [flags]
```

### Options

```
  -a, --all              Stage all changes before committing (default true)
      --amend            Amend the previous commit
  -h, --help             help for commit
      --include-refs     Include submodule ref changes when staging at campaign root
  -m, --message string   Commit message (required)
  -p, --project string   Operate on a specific project/submodule path
      --sub              Operate on the submodule detected from current directory
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp completion

Generate the autocompletion script for the specified shell

### Synopsis

Generate the autocompletion script for camp for the specified shell.
See each sub-command's help for details on how to use the generated script.


### Options

```
  -h, --help   help for completion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(camp completion bash)

To load completions for every new session, execute once:

#### Linux:

	camp completion bash > /etc/bash_completion.d/camp

#### macOS:

	camp completion bash > $(brew --prefix)/etc/bash_completion.d/camp

You will need to start a new shell for this setup to take effect.


```
camp completion bash
```

### Options

```
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp completion fish

Generate the autocompletion script for fish

### Synopsis

Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	camp completion fish | source

To load completions for every new session, execute once:

	camp completion fish > ~/.config/fish/completions/camp.fish

You will need to start a new shell for this setup to take effect.


```
camp completion fish [flags]
```

### Options

```
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp completion powershell

Generate the autocompletion script for powershell

### Synopsis

Generate the autocompletion script for powershell.

To load completions in your current shell session:

	camp completion powershell | Out-String | Invoke-Expression

To load completions for every new session, add the output of the above command
to your powershell profile.


```
camp completion powershell [flags]
```

### Options

```
  -h, --help              help for powershell
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp completion zsh

Generate the autocompletion script for zsh

### Synopsis

Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(camp completion zsh)

To load completions for every new session, execute once:

#### Linux:

	camp completion zsh > "${fpath[1]}/_camp"

#### macOS:

	camp completion zsh > $(brew --prefix)/share/zsh/site-functions/_camp

You will need to start a new shell for this setup to take effect.


```
camp completion zsh [flags]
```

### Options

```
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp concepts

List configured concepts

```
camp concepts [flags]
```

### Options

```
  -h, --help   help for concepts
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp copy

Copy a file or directory within the campaign

### Synopsis

Copy a file or directory within the current campaign.

Paths are resolved relative to the current directory, matching standard
'cp' behavior and tab completion.

Use @ prefix for campaign shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in campaign config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename. Directories are copied
recursively.

```
camp copy <src> <dest> [flags]
```

### Examples

```
  camp copy myfile.md ../docs/
  camp cp @f/active/my-fest/OVERVIEW.md @d/
  camp cp @w/design/active/ @w/explore/backup/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for copy
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp date

Append date suffix to file or directory name

### Synopsis

Append a date suffix to a file or directory name.

Renames a file or directory by appending a date to its name.
Shows a preview of the rename and asks for confirmation.

Date source (in priority order):
  --mtime    Use the file's last modified date
  --ago N    Use today minus N days
  (default)  Use today's date

Examples:
  camp date old-project              # old-project -> old-project-2026-01-27
  camp date ./docs/archive.md        # archive.md -> archive-2026-01-27.md
  camp date old-project --yes        # Skip confirmation
  camp date old-project --ago 3      # Use date from 3 days ago
  camp date old-project --mtime      # Use file's last modified date
  camp date old-project -f 20060102  # Use different date format

```
camp date <path> [flags]
```

### Options

```
  -a, --ago int         Use date from N days ago
      --dry-run         Show what would be done without making changes
  -f, --format string   Date format (Go time format) (default "2006-01-02")
  -h, --help            help for date
  -m, --mtime           Use file's last modified date
  -y, --yes             Skip confirmation prompt
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp doctor

Diagnose and fix campaign health issues

### Synopsis

Check campaign for common issues and optionally fix them.

CHECKS PERFORMED:
  orphan      Orphaned gitlinks in index (no .gitmodules entry)
  url         URL consistency between .gitmodules and .git/config
  integrity   Submodule integrity (empty/broken directories)
  head        HEAD states (detached with local work)
  working     Working directory cleanliness
  commits     Parent-submodule commit alignment
  lock        Stale git index.lock files

EXIT CODES:
  0  All checks passed (no warnings or errors)
  1  Warnings found (but no errors)
  2  Errors found
  3  Fix attempted but some issues remain

EXAMPLES:
  # Run all checks
  camp doctor

  # Attempt automatic fixes
  camp doctor --fix

  # Run URL check only
  camp doctor -c url

  # Detailed output
  camp doctor --verbose

  # JSON output for scripting
  camp doctor --json

```
camp doctor [flags]
```

### Options

```
  -c, --check strings     Run specific check(s) only (orphan, url, integrity, head, working, commits, lock)
  -f, --fix               Attempt automatic fixes for detected issues
  -h, --help              help for doctor
      --json              Output results as JSON
      --submodules-only   Only check submodule health
  -v, --verbose           Show detailed information for each check
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```
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
---

## camp dungeon add

Initialize dungeon structure

### Synopsis

Initialize the dungeon directory with documentation and structure.

Creates the dungeon directory with:
  - OBEY.md: Documentation explaining the dungeon's purpose
  - completed/: Successfully finished work
  - archived/: Preserved for history, truly done
  - someday/: Low priority, might revisit

This creates the same dungeon structure as 'camp flow init' but without
the full workflow (no .workflow.yaml, active/, or ready/ directories).
Useful when you only need a dungeon for idea capture or temporary holding.

This operation is idempotent - running it multiple times is safe.
Use --force to overwrite existing files.

Examples:
  camp dungeon add          Initialize dungeon (skip existing files)
  camp dungeon add --force  Overwrite existing documentation

```
camp dungeon add [flags]
```

### Options

```
  -f, --force   Overwrite existing files
  -h, --help    help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

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
---

## camp dungeon list

List dungeon items

### Synopsis

List items in the dungeon or parent items eligible for triage.

By default, lists items at the dungeon root (items already in the dungeon).
Use --triage to list parent directory items that could be moved into the dungeon.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            Names only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp dungeon list                  List dungeon root items
  camp dungeon list --triage         List parent items eligible for triage
  camp dungeon list -f json          JSON output for scripting
  camp dungeon list -f simple        Names only, pipe to other commands

```
camp dungeon list [flags]
```

### Options

```
  -f, --format string   Output format: table, simple, json (default "table")
  -h, --help            help for list
      --triage          List parent items eligible for triage into dungeon
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp dungeon move

Move dungeon items between statuses

### Synopsis

Move items within the dungeon or from the parent directory into the dungeon.

Without --triage, moves an item already in the dungeon root to a status directory.
With --triage, moves an item from the parent directory into the dungeon.

Statuses: completed, archived, someday

Examples:
  camp dungeon move old-feature archived         Move dungeon item to archived
  camp dungeon move stale-doc completed          Move dungeon item to completed
  camp dungeon move old-project --triage         Move parent item into dungeon root
  camp dungeon move old-project archived --triage Move parent item directly to archived

```
camp dungeon move <item> [status] [flags]
```

### Options

```
  -h, --help        help for move
      --no-commit   Don't create a git commit
      --triage      Move from parent directory (not from dungeon root)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

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
---

## camp flow add

Add workflow tracking to current directory

### Synopsis

Add workflow tracking to the current directory.

Creates a .workflow.yaml file, dungeon/ directory structure, and root OBEY.md.
Uses workflow schema v2 (dungeon-centric model) where:
  - Root directory (.) = active work
  - dungeon/           = all other statuses

If dungeon/ already exists, only creates .workflow.yaml.
If both exist, displays a notice.

Use --force to overwrite an existing workflow configuration.

Provide name/description via flags, JSON, or interactive TUI:
  --name/-n and --description/-d   Set via flags
  --json/-j '{"name":"...","description":"..."}'  Set via JSON
  --json -   Read JSON from stdin (for piping)

Note: Flows cannot be nested inside other flows. If you're inside a flow,
navigate to a directory outside of it before running this command.

Examples:
  camp flow add                                      Interactive TUI
  camp flow add --name "API" --description "API dev" Via flags
  camp flow add --json '{"name":"API","description":"API development"}'
  echo '{"name":"X","description":"Y"}' | camp flow add --json -
  camp flow add --force                              Overwrite existing

```
camp flow add [flags]
```

### Options

```
  -d, --description string   workflow description/purpose
  -f, --force                overwrite existing workflow
  -h, --help                 help for add
  -j, --json string          JSON input (use "-" for stdin)
  -n, --name string          workflow name
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow items

List items in a status directory

### Synopsis

List items in a status directory.

If no status is specified, lists items in the default status (usually 'active').
Use --all to list items in all status directories.

Examples:
  camp flow items              List items in default status
  camp flow items active       List items in active/
  camp flow items dungeon/completed  List items in dungeon/completed/
  camp flow items --all        List items in all statuses

```
camp flow items [status] [flags]
```

### Options

```
  -a, --all    list all statuses
  -h, --help   help for items
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow list

List registered flows from the registry

### Synopsis

List all flows registered in .campaign/flows/registry.yaml.

Shows flow name, description, and tags in table format.

Examples:
  camp flow list

```
camp flow list [flags]
```

### Options

```
  -h, --help   help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow migrate

Migrate workflow to latest schema version

### Synopsis

Migrate a workflow to the latest schema version.

Supports two migration paths:
  - Legacy dungeon → v1 workflow (creates .workflow.yaml)
  - v1 → v2 (dungeon-centric model)

For v1→v2 migration:
  - active/ items move to root directory
  - ready/ items move to dungeon/ready/
  - Empty active/ and ready/ directories are removed
  - Schema is updated to version 2

Use --dry-run to preview changes without applying them.
Use --force to skip confirmation prompts.

Examples:
  camp flow migrate            Migrate with confirmation
  camp flow migrate --dry-run  Preview migration
  camp flow migrate --force    Migrate without confirmation

```
camp flow migrate [flags]
```

### Options

```
  -n, --dry-run   preview migration without making changes
  -f, --force     skip confirmation
  -h, --help      help for migrate
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow move

Move an item to a new status

### Synopsis

Move an item from its current status to a new status.

The item is moved from wherever it currently exists to the specified status.
Transitions are validated against the workflow schema unless --force is used.

Auto-commit behavior is controlled by .workflow.yaml auto_commit settings.
Use --commit to force a commit or --no-commit to skip it.

Examples:
  camp flow move project-1 ready             Move to ready/
  camp flow move old-project dungeon/completed   Move to dungeon/completed/
  camp flow move project-1 ready --reason "Ready for review"
  camp flow move project-1 active --force    Force move (skip validation)
  camp flow move project-1 ready --commit    Force auto-commit

```
camp flow move <item> <status> [flags]
```

### Options

```
      --commit          force auto-commit after move
  -f, --force           force move (skip transition validation)
  -h, --help            help for move
      --no-commit       skip auto-commit even if enabled in config
  -r, --reason string   reason for the move
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow run

Execute a registered flow by name

### Synopsis

Execute a registered flow from .campaign/flows/registry.yaml.

Extra arguments after -- are appended to the flow's command.

Examples:
  camp flow run build
  camp flow run test -- --verbose
  camp flow run deploy -- production

```
camp flow run <name> [-- extra-args...] [flags]
```

### Options

```
  -h, --help   help for run
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow show

Show workflow structure

### Synopsis

Display the workflow structure and configuration.

Shows the directories defined in the workflow, their descriptions,
and transition rules.

Use --schema to display the raw .workflow.yaml file.

Examples:
  camp flow show             Show workflow structure
  camp flow show --schema    Show raw schema file

```
camp flow show [flags]
```

### Options

```
  -h, --help     help for show
  -s, --schema   show raw schema file
  -t, --tree     display as tree
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow status

Show workflow statistics

### Synopsis

Show workflow statistics including item counts per status.

Displays the workflow name, location, and counts for each status directory.

Examples:
  camp flow status            Show workflow statistics

```
camp flow status [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp flow sync

Sync directories with schema

### Synopsis

Synchronize directories with the workflow schema.

Creates any directories defined in .workflow.yaml that don't exist yet.
Does not remove directories that aren't in the schema.

Use --dry-run to see what would be created without making changes.

Examples:
  camp flow sync              Create missing directories
  camp flow sync --dry-run    Preview changes without creating

```
camp flow sync [flags]
```

### Options

```
  -n, --dry-run   preview changes without creating directories
  -h, --help      help for sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp gather

Import external data into the intent system

### Synopsis

Gather external data sources into trackable intents.

The gather command imports data from various sources into the intent system,
creating structured intents with checkboxes for tracking progress.

Available sources:
  feedback    Gather feedback observations from festivals

```
camp gather [flags]
```

### Options

```
  -h, --help   help for gather
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp gather feedback

Gather feedback observations from festivals into intents

### Synopsis

Scan festival directories for feedback observations and create
trackable FEEDBACK intent files with checkboxes.

Each festival with feedback observations gets a FEEDBACK_<fest_id>.md intent
in workflow/intents/inbox/. Observations are grouped by criteria with
checkboxes for tracking addressed status.

Deduplication tracking ensures observations are only gathered once.
Re-running the command appends only new observations to existing intents,
preserving any checkbox state from previous runs.

Examples:
  # Gather all feedback from all festivals
  camp gather feedback

  # Preview what would be gathered
  camp gather feedback --dry-run

  # Gather from a specific festival
  camp gather feedback --festival-id CC0004

  # Only gather from completed festivals
  camp gather feedback --status completed

  # Filter by severity
  camp gather feedback --severity high

  # Re-gather everything (ignore tracking)
  camp gather feedback --force

```
camp gather feedback [flags]
```

### Options

```
      --dry-run              Preview without creating intents
      --festival-id string   Only gather from a specific festival
      --force                Re-gather all, ignoring tracking
  -h, --help                 help for feedback
      --no-commit            Skip git commit
      --severity string      Filter by observation severity (low, medium, high)
      --status string        Festival status dirs to scan (comma-separated) (default "completed,active,planned")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp go

Navigate to campaign directories

### Synopsis

Navigate within the campaign using shortcuts.

Usage patterns:
  camp go           Toggle between campaign root and last location
  camp go --root    Jump to campaign root (ignore toggle)
  camp go t         Jump to last visited location (cd - equivalent)
  camp go p         Jump to projects/
  camp go f         Jump to festivals/
  camp go p api     Fuzzy search projects/ for "api"

Toggle behavior (no args):
  - From anywhere: jump to campaign root, save current location
  - From campaign root: jump back to saved location

Toggle keyword (t / toggle):
  - Jump to the last visited location regardless of where you are
  - Repeated calls alternate between two locations (like cd -)

The --print flag outputs just the path for shell integration:
  cd "$(camp go p --print)"

The -c flag runs a command from the directory without changing to it:
  camp go p -c ls           List contents of projects/
  camp go f -c fest status  Run fest status from festivals/

Or use the cgo shell function for instant navigation:
  cgo               Toggle between root and last location
  cgo p             Equivalent to: cd "$(camp go p --print)"
  cgo p -c ls       Run ls in projects/ without changing directory

```
camp go [shortcut] [query...] [flags]
```

### Examples

```
  camp go               # Toggle: root ↔ last location
  camp go --root        # Force jump to campaign root
  camp go t             # Jump to last visited location (cd -)
  camp go p             # Jump to projects/
  camp go p api         # Fuzzy find "api" in projects/
  camp go p --print     # Print path (for shell scripts)
  camp go f -c ls       # List festivals/ without cd
```

### Options

```
  -c, --command stringArray   Run command from directory (can be repeated for args)
  -h, --help                  help for go
  -l, --list                  List available sub-shortcuts for a project
      --print                 Print path only (for shell integration)
      --root                  Jump to campaign root (ignore last location)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp init

Initialize a new campaign

### Synopsis

Initialize a new campaign directory structure.

Creates the standard campaign directories:
  .campaign/              - Campaign configuration and metadata
  projects/               - Project repositories (submodules or worktrees)
  projects/worktrees/     - Git worktrees for parallel development
  festivals/              - Festival methodology workspace (via fest init)
  ai_docs/                - AI-generated documentation
  docs/                   - Human-authored documentation
  dungeon/                - Archived and deprioritized work
  workflow/               - Workflow management
  workflow/code_reviews/  - Code review notes and feedback
  workflow/pipelines/     - CI/CD pipeline definitions
  workflow/design/        - Design documents
  workflow/intents/       - Intent documents

Also creates:
  AGENTS.md     - AI agent instruction file
  CLAUDE.md     - Symlink to AGENTS.md

Initializes a git repository if not already inside one.

Use --no-git to skip git initialization.

```
camp init [path] [flags]
```

### Examples

```
  camp init                      Initialize current directory
  camp init my-campaign          Create and initialize new directory
  camp init --name "My Project"  Set custom campaign name
  camp init --no-git             Skip git initialization
  camp init --dry-run            Preview without creating anything
```

### Options

```
  -d, --description string   Campaign description
      --dry-run              Show what would be done without creating anything
  -f, --force                Initialize in non-empty directory without prompting
  -h, --help                 help for init
  -m, --mission string       Campaign mission statement
  -n, --name string          Campaign name (defaults to directory name)
      --no-git               Skip git repository initialization
      --no-register          Don't add to global registry
      --repair               Add missing files to existing campaign
      --skip-fest            Skip automatic Festival Methodology initialization
  -t, --type string          Campaign type (product, research, tools, personal) (default "product")
      --yes                  Skip repair confirmation prompt (for scripting)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent

Manage campaign intents

### Synopsis

Manage intents for ideas and features not yet ready for full planning.

Intents capture ideas, bugs, features, and research topics that depend on work
not yet completed. They serve as structured storage for ideas that aren't ready
to become Festivals but need to be tracked.

CAPTURE MODES:
  Fast (default)    Quick capture with minimal fields
  Deep (--edit)     Open in editor for full context

INTENT LIFECYCLE:
  inbox  → Captured, not yet reviewed
  ready  → Reviewed/enriched, ready for promotion
  active → Promoted to festival/design doc, work in progress
  dungeon/* → Terminal statuses (done, killed, archived, someday)

Examples:
  camp intent add "Add dark mode toggle"         Fast capture to inbox
  camp intent add -e "Refactor auth system"      Deep capture with editor
  camp intent list                               List all intents
  camp intent list --status active               List active intents
  camp intent edit add-dark                      Edit intent (fuzzy match)
  camp intent show 20260119-153412-add-dark      Show intent details
  camp intent move add-dark ready                Mark as ready
  camp intent promote add-dark                   Promote to active via festival
  camp intent archive add-dark                   Archive intent

```
camp intent [flags]
```

### Options

```
  -h, --help   help for intent
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent add

Create a new intent

### Synopsis

Create a new intent with fast or deep capture mode.

CAPTURE MODES:
  Ultra-fast          Title provided as argument → immediate creation
  Fast TUI (default)  Step-through form (title, type, concept)
  Full TUI (--full)   Step-through form including body textarea
  Deep (--edit)       Full template in $EDITOR

Fast capture is optimized for speed - ideas are saved immediately.
Use --full when you want to add a body description in the form.
Use --edit when you need the complete template in your editor.

Examples:
  camp intent add "Add dark mode"        Ultra-fast capture
  camp intent add                        Fast TUI (3-step form)
  camp intent add --full                 Full TUI (includes body)
  camp intent add -e "Complex feature"   Deep capture with editor
  camp intent add -t feature "New API"   Set type explicitly

```
camp intent add [title] [flags]
```

### Options

```
  -e, --edit          Open in $EDITOR for deep capture
  -f, --full          Full TUI mode with body textarea
  -h, --help          help for add
      --no-commit     Don't create a git commit
  -t, --type string   Intent type (idea, feature, bug, research, chore) (default "idea")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent archive

Archive an intent

### Synopsis

Archive an intent by moving it to dungeon/archived.

This is a convenience command equivalent to:
  camp intent move <id> archived --reason "..."

Dungeon moves require a reason and append a decision record to the intent body.
Use 'camp intent move <id> inbox' to un-archive if needed.

Examples:
  camp intent archive add-dark --reason "superseded by broader initiative"
  camp intent archive 20260119-153412 --reason "preserve as reference"

```
camp intent archive <id> [flags]
```

### Options

```
  -h, --help            help for archive
      --no-commit       Don't create a git commit
      --reason string   Reason for archiving (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent count

Count intents by status directory

### Synopsis

Display a count of intents grouped by status directory.

OUTPUT FORMATS:
  table (default)   Styled summary with counts per status
  json              Machine-readable JSON output

Examples:
  camp intent count              Show counts per status
  camp intent count -f json      JSON output for scripting

```
camp intent count [flags]
```

### Options

```
  -f, --format string   Output format: table, json (default "table")
  -h, --help            help for count
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent edit

Edit an existing intent

### Synopsis

Edit an intent in your preferred editor.

If ID is provided, opens the intent directly (supports partial matching).
If no ID is provided, shows a fuzzy picker to select an intent.

PARTIAL ID MATCHING:
  Full ID:       20260119-153412-add-retry-logic
  Time suffix:   153412-add-retry
  Slug portion:  add-retry

Examples:
  camp intent edit                       Interactive picker
  camp intent edit 20260119-153412...    Direct edit by full ID
  camp intent edit retry-logic           Partial match edit
  camp intent edit --status active       Picker filtered by status

```
camp intent edit [id] [flags]
```

### Options

```
  -h, --help             help for edit
  -p, --project string   Filter picker by project
  -s, --status string    Filter picker by status
  -t, --type string      Filter picker by type
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent explore

Interactive intent explorer

### Synopsis

Launch the interactive Intent Explorer TUI.

The explorer provides a full-screen interface for browsing,
filtering, and managing intents with keyboard shortcuts.

NAVIGATION
  j/↓           Move down
  k/↑           Move up
  g             Go to top (preview)
  G             Go to bottom (preview)
  Enter/Space   Select/expand group
  Tab           Switch focus (list/preview)

ACTIONS
  e             Edit in $EDITOR
  o             Open with system handler
  O             Reveal in file manager
  n             New intent
  p             Promote to next status
  a             Archive intent
  d             Delete intent
  m             Move intent to status

GATHER (Multi-Select)
  Space         Toggle selection / enter gather mode
  ga            Gather selected intents
  Escape        Exit multi-select mode

FILTERS
  /             Search intents (fuzzy)
  t             Filter by type
  s             Filter by status
  c             Filter by concept
  C             Clear concept filter
  Escape        Clear filter/cancel

VIEW
  v             Toggle preview pane
  ?             Show help overlay
  q             Quit explorer

Examples:
  camp intent explore          Launch the intent explorer

```
camp intent explore [flags]
```

### Options

```
  -h, --help   help for explore
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent find

Search for intents by title or content

### Synopsis

Search for intents across all statuses by title, content, or ID.

The search is case-insensitive and matches partial strings.
Without a query, returns all intents.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            IDs only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp intent find                   List all intents
  camp intent find dark              Find intents containing "dark"
  camp intent find "bug fix"         Find intents with "bug fix"
  camp intent find -f simple auth    Get IDs of auth-related intents

```
camp intent find [query] [flags]
```

### Options

```
  -f, --format string   Output format: table, simple, json (default "table")
  -h, --help            help for find
  -n, --limit int       Limit results (0 = no limit)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent gather

Gather related intents into a unified document

### Synopsis

Gather multiple related intents into a single unified document.

DISCOVERY MODES:
  By IDs      Explicitly specify intent IDs to gather
  --tag       Find intents with a specific frontmatter tag
  --hashtag   Find intents containing a specific #hashtag
  --similar   Find intents similar to a given ID (TF-IDF)

The gather process:
  1. Find related intents using the specified discovery method
  2. Merge their content with full metadata preservation
  3. Create a new unified intent in inbox status
  4. Archive source intents (unless --no-archive)

Source intents are preserved with a 'gathered_into' reference.

Examples:
  # Gather by explicit IDs
  camp intent gather id1 id2 id3 --title "Auth System"

  # Find and gather by tag
  camp intent gather --tag auth --title "Auth System"

  # Find and gather by hashtag
  camp intent gather --hashtag login --title "Login System"

  # Find similar intents and gather
  camp intent gather --similar auth-feature --title "Auth Unified"

  # Gather without archiving sources
  camp intent gather id1 id2 --title "Combined" --no-archive

  # Dry run to preview what would be gathered
  camp intent gather --tag auth --title "Auth System" --dry-run

```
camp intent gather [ids...] [flags]
```

### Options

```
      --concept string    Override concept path
      --dry-run           Preview gather without making changes
      --hashtag string    Find intents by content hashtag
  -h, --help              help for gather
      --horizon string    Override horizon (now, next, later, someday)
      --min-score float   Minimum similarity score (0.0-1.0) (default 0.1)
      --no-archive        Don't archive source intents
      --no-commit         Don't create a git commit
      --priority string   Override priority (low, medium, high)
      --similar string    Find intents similar to this ID
      --tag string        Find intents by frontmatter tag
  -t, --title string      Title for the gathered intent (required)
      --type string       Override type (idea, feature, bug, research)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent list

List intents in the campaign

### Synopsis

List intents with filtering, sorting, and output format options.

By default, lists intents in inbox, active, and ready status.
Use --all to include dungeon intents.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            IDs only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp intent list                         List active intents
  camp intent ls --status inbox            List inbox only
  camp intent list -f json                 JSON output
  camp intent list -f simple | xargs ...   Pipe IDs to commands
  camp intent list --all                   Include archived

```
camp intent list [flags]
```

### Options

```
  -a, --all              Include dungeon intents
  -f, --format string    Output format: table, simple, json (default "table")
  -h, --help             help for list
      --horizon string   Filter by horizon
  -n, --limit int        Limit results (0 = no limit)
  -p, --project string   Filter by project
  -S, --sort string      Sort by: updated, created, priority, title (default "updated")
  -s, --status strings   Filter by status (repeatable)
  -t, --type strings     Filter by type (repeatable)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent move

Move intent to a different status

### Synopsis

Transition an intent between lifecycle statuses.

VALID STATUSES:
  inbox      Captured, not yet reviewed
  ready      Reviewed/enriched, ready to be promoted
  active     Promoted to festival/design, work in progress
  done       Resolved (dungeon)
  killed     Abandoned (dungeon)
  archived   Preserved but inactive (dungeon)
  someday    Deferred (dungeon)

PIPELINE ORDER:
  inbox → ready → active → dungeon/done

Move is an escape hatch that allows any-to-any transitions.
Dungeon moves require a --reason flag.
You can use short dungeon names (done) or canonical paths (dungeon/done).

Examples:
  camp intent move add-dark ready                         Mark as ready
  camp intent move add-dark done --reason "completed"     Mark as done
  camp intent move add-dark killed --reason "superseded"  Kill intent

```
camp intent move <id> <status> [flags]
```

### Options

```
  -h, --help            help for move
      --no-commit       Don't create a git commit
      --reason string   Reason for the move (required for dungeon targets)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent promote

Promote an intent through the pipeline

### Synopsis

Promote an intent to the next pipeline stage.

TARGETS:
  ready      Move from inbox to ready (reviewed/enriched)
  festival   Move from ready to active + create festival (default)
  design     Move from ready to active + create design doc

The intent moves to active status when promoted to festival or design,
because work is just beginning. Use --force to bypass status checks.

Examples:
  camp intent promote add-dark                       Promote ready → festival
  camp intent promote add-dark --target design       Promote ready → design doc
  camp intent promote add-dark --target ready         Promote inbox → ready
  camp intent promote add-dark --force                Force promote from any status

```
camp intent promote <id> [flags]
```

### Options

```
      --dry-run         Preview promotion without making changes
      --force           Promote even if not in expected status
  -h, --help            help for promote
      --no-commit       Don't create a git commit
      --target string   Promote target: ready, festival, design (default "festival")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp intent show

Show detailed intent information

### Synopsis

Display detailed information about a specific intent.

Supports partial ID matching - you can use:
  - Full ID: 20260119-153412-add-retry-logic
  - Time suffix: 153412-add-retry
  - Slug portion: add-retry

OUTPUT FORMATS:
  text (default)   Human-readable detailed view
  json             Full metadata in JSON format
  yaml             Full metadata in YAML format

Examples:
  camp intent show 20260119-153412...    Show by full ID
  camp intent show retry-logic           Show by partial match
  camp intent show retry -f json         JSON output
  camp intent show retry -f yaml         YAML output

```
camp intent show <id> [flags]
```

### Options

```
  -f, --format string   Output format: text, json, yaml (default "text")
  -h, --help            help for show
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp leverage

Compute leverage scores for campaign projects

### Synopsis

Compute productivity leverage scores by comparing scc COCOMO estimates
against actual development effort.

Leverage score measures how much more output you produce versus what
traditional estimation models predict for the same team and time.

  FullLeverage   = (EstimatedPeople x EstimatedMonths) / (ActualPeople x ElapsedMonths)
  SimpleLeverage = EstimatedPeople / ActualPeople

Examples:
  camp leverage                              Show team leverage (auto-detect authors from git)
  camp leverage --author lance@example.com   Show personal leverage
  camp leverage --project camp               Show score for specific project
  camp leverage --json                       Output as JSON
  camp leverage --people 2                   Override team size
  camp leverage --verbose                    Show diagnostic details

```
camp leverage [flags]
```

### Options

```
      --author string    filter by author email (git substring match — 'alice@co' matches 'alice@co.com')
      --by-author        show per-author leverage breakdown
  -h, --help             help for leverage
      --json             output as JSON
      --no-legend        hide the leverage formula legend
      --people int       override team size (0 = auto-detect from git)
  -p, --project string   filter by project name
  -v, --verbose          show diagnostic details (config, project resolution, exclusions)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```
---

## camp leverage backfill

Reconstruct historical leverage data from git history

### Synopsis

Backfill analyzes past commits to build leverage-over-time data.

Uses git worktrees to check out weekly snapshots, run scc analysis,
and compute leverage scores at each point in time. Results are stored
as snapshots for later retrieval via 'camp leverage history'.

Backfill is incremental: re-running only processes dates without
existing snapshots.

Examples:
  camp leverage backfill                       Backfill all projects
  camp leverage backfill --project camp        Backfill specific project
  camp leverage backfill --workers 2           Limit concurrency
  camp leverage backfill --since 2025-06-01    Backfill from June 2025

```
camp leverage backfill [flags]
```

### Options

```
  -h, --help             help for backfill
  -p, --project string   backfill a single project
      --since string     start date (YYYY-MM-DD), overrides config project_start
  -w, --workers int      number of parallel workers (default 4)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp leverage config

View or update leverage configuration

### Synopsis

View or update leverage score configuration settings.

Without flags, displays the current configuration. With flags, updates
the configuration and saves it to .campaign/leverage/config.json.

Configuration parameters:
  --people       Number of developers on the team
  --start        Project start date (YYYY-MM-DD format)
  --cocomo-type  COCOMO project type (organic, semi-detached, embedded)
  --exclude      Exclude a project from leverage scoring
  --include      Include a previously excluded project

Examples:
  camp leverage config                         Show current config
  camp leverage config --people 3              Set team size to 3
  camp leverage config --start 2025-01-01      Set project start date
  camp leverage config --exclude obey-daemon   Exclude a project
  camp leverage config --include obey-daemon   Re-include a project

```
camp leverage config [flags]
```

### Options

```
      --author-email string   default author email for personal leverage (empty = team view)
      --cocomo-type string    COCOMO project type (organic, semi-detached, embedded)
      --exclude string        exclude a project from leverage scoring
  -h, --help                  help for config
      --include string        include a previously excluded project
      --people int            number of developers on the team (0 = auto-detect from git)
      --start string          project start date (YYYY-MM-DD)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp leverage history

Show leverage score history over time

### Synopsis

Display leverage data aggregated over time from stored snapshots.

Shows how leverage has changed week by week. Use --by-author to see
per-contributor leverage breakdown based on git blame attribution.

Requires snapshot data from 'camp leverage backfill' or 'camp leverage snapshot'.

Examples:
  camp leverage history                            Show all history
  camp leverage history --project camp             Filter to one project
  camp leverage history --since 2025-06-01         Start from June 2025
  camp leverage history --json                     Output as JSON
  camp leverage history --by-author                Per-author breakdown

```
camp leverage history [flags]
```

### Options

```
      --by-author        show per-author leverage breakdown
  -h, --help             help for history
      --json             output as JSON
      --period string    aggregation period: weekly or monthly (default "monthly")
  -p, --project string   filter to specific project
      --since string     start date (YYYY-MM-DD)
      --until string     end date (YYYY-MM-DD, default: today)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

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
---

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
---

## camp list

List all registered campaigns

### Synopsis

List all campaigns registered in the global registry.

Campaigns are registered when created with 'camp init' or manually
with 'camp register'. The registry lives at ~/.obey/campaign/registry.yaml.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Campaign names only, one per line
  json    - JSON array for scripting

Sorting options:
  accessed - Most recently accessed first (default)
  name     - Alphabetically by name
  type     - Alphabetically by type

Examples:
  camp list                  List all campaigns
  camp list --format json    Output as JSON
  camp list --sort name      Sort by name
  camp list --format simple  Names only for scripting

```
camp list [flags]
```

### Options

```
  -f, --format string    Output format (table, simple, json) (default "table")
  -h, --help             help for list
  -s, --sort string      Sort by (name, accessed, type) (default "accessed")
      --verify-verbose   Show detailed verification output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp log

Show git log of the campaign

### Synopsis

Show git log of the campaign root repository.

Works from anywhere within the campaign - always shows the log
of the campaign root repository.

Use --sub to show log of the submodule detected from your current directory.
Use --project/-p to show log of a specific project.

Examples:
  camp log              # Full log
  camp log -5           # Last 5 commits
  camp log --oneline    # One line per commit
  camp log --graph      # Show branch graph
  camp log --sub        # Log of current submodule
  camp log -p projects/camp --oneline  # Log of camp project

```
camp log [flags]
```

### Options

```
  -h, --help   help for log
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp move

Move a file or directory within the campaign

### Synopsis

Move a file or directory within the current campaign.

Paths are resolved relative to the current directory, matching standard
'mv' behavior and tab completion.

Use @ prefix for campaign shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in campaign config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename.

```
camp move <src> <dest> [flags]
```

### Examples

```
  camp move mydir/ ../docs/mydir/
  camp mv @f/active/old-fest @f/completed/
  camp mv draft.md @w/design/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for move
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp pin

Bookmark a directory

### Synopsis

Bookmark a directory for quick navigation with 'camp jump'.

If path is omitted, the current working directory is used.

```
camp pin <name> [path] [flags]
```

### Examples

```
  camp pin myspot           # Pin current directory as "myspot"
  camp pin docs /path/to/docs  # Pin a specific path
```

### Options

```
  -h, --help   help for pin
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp pins

List all pinned directories

### Synopsis

List all pinned directory bookmarks. Use 'camp pin' to add and 'camp unpin' to remove.

```
camp pins [flags]
```

### Options

```
  -h, --help   help for pins
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project

Manage campaign projects

### Synopsis

Manage git submodules and project repositories in the campaign.

A project is a git repository tracked as a submodule under the projects/ directory.
Projects can be added from remote URLs or existing local repositories.

Examples:
  camp project list                    List all projects
  camp project add git@github.com:org/repo.git  Add a new project
  camp project remove api-service      Remove a project

```
camp project [flags]
```

### Options

```
  -h, --help   help for project
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project add

Add a project to campaign

### Synopsis

Add a git repository as a project in the campaign.

The project is cloned as a git submodule into the projects/ directory.
A worktree directory is also created for future parallel development.

Source can be:
  - SSH URL:   git@github.com:org/repo.git
  - HTTPS URL: https://github.com/org/repo.git
  - Local path (with --local): ./existing-repo

Examples:
  camp project add git@github.com:org/api.git           # Add remote repo
  camp project add https://github.com/org/web.git       # Add via HTTPS
  camp project add --local ./my-repo --name my-project  # Add existing local repo
  camp project add git@github.com:org/api.git --name backend  # Custom name

```
camp project add <source> [flags]
```

### Options

```
  -h, --help           help for add
  -l, --local string   Add existing local repository instead of cloning
  -n, --name string    Override project name (defaults to repo name)
      --no-commit      Skip automatic git commit
  -p, --path string    Override destination path (defaults to projects/<name>)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project commit

Commit changes in a project submodule

### Synopsis

Commit changes within a project submodule.

Auto-detects the current project from your working directory,
or use --project to specify a project by name.

Examples:
  # From within a project directory
  cd projects/my-api
  camp project commit -m "Fix bug"

  # Specify project by name
  camp project commit --project my-api -m "Update deps"

```
camp project commit [flags]
```

### Options

```
  -a, --all              Stage all changes (default true)
      --amend            Amend the previous commit
  -h, --help             help for commit
  -m, --message string   Commit message (required)
  -p, --project string   Project name (auto-detected from cwd if not specified)
      --sync             Sync submodule ref at campaign root after commit (opt-in)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project list

List projects in campaign

### Synopsis

List all projects in the current campaign.

Projects are git repositories located in the projects/ directory.
The command detects project types by looking for marker files like
go.mod (Go), Cargo.toml (Rust), or package.json (TypeScript).

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Project names only, one per line
  json    - JSON array for scripting

Examples:
  camp project list               List projects in table format
  camp project list --format json Output as JSON
  camp project list --format simple  Names only for scripting

```
camp project list [flags]
```

### Options

```
  -f, --format string   Output format (table, simple, json) (default "table")
  -h, --help            help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project new

Create a new project in campaign

### Synopsis

Create a new local project as a git submodule in the campaign.

The project is initialized as a git repository with an initial commit,
then added as a submodule under projects/. No remote repository is required.

You can add a remote later:
  cd projects/<name>
  git remote add origin git@github.com:org/<name>.git

Examples:
  camp project new my-service             # Create new project
  camp project new my-service --no-commit # Skip auto-commit to campaign

```
camp project new <name> [flags]
```

### Options

```
  -h, --help          help for new
      --no-commit     Skip automatic git commit
  -p, --path string   Override destination path (defaults to projects/<name>)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project prune

Delete merged branches in a project

### Synopsis

Delete local branches that have been merged into the default branch.

Auto-detects the current project from your working directory,
or accepts a project name as a positional argument.

Protected branches (default branch, current branch) are never deleted.

Examples:
  camp project prune                     # Prune current project
  camp project prune camp                # Prune by name
  camp project prune -p camp             # Prune by flag
  camp project prune --dry-run           # Preview what would be deleted
  camp project prune --remote            # Also prune stale remote tracking refs
  camp project prune --remote-delete     # Also delete merged branches on origin

```
camp project prune [project-name] [flags]
```

### Options

```
  -n, --dry-run          Preview without deleting
  -f, --force            Skip local branch deletion confirmation
  -h, --help             help for prune
  -p, --project string   Project name (auto-detected from cwd)
      --remote           Also prune stale remote tracking refs
      --remote-delete    Also delete merged branches on origin (destructive)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project prune all

Delete merged branches across all projects

### Synopsis

Delete local branches that have been merged into the default branch,
across every project submodule in the campaign.

Produces a per-project summary showing what was (or would be) pruned.

Examples:
  camp project prune all                 # Prune all projects
  camp project prune all --dry-run       # Preview across all projects
  camp project prune all --force         # Skip confirmation for each project
  camp project prune all --remote        # Also prune stale remote tracking refs

```
camp project prune all [flags]
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
---

## camp project remove

Remove a project from campaign

### Synopsis

Remove a project from the campaign.

By default, this only removes the project from git submodule tracking.
The project files remain in place for you to handle manually.

Use --delete to also remove all project files. This is destructive
and requires confirmation unless --force is also specified.

Examples:
  camp project remove api-service           # Unregister submodule only
  camp project remove api-service --delete  # Also delete files (confirms)
  camp project remove api-service --delete --force  # Delete without confirmation
  camp project remove api-service --dry-run # Show what would be done

```
camp project remove <name> [flags]
```

### Options

```
  -d, --delete      Also delete project files (destructive)
      --dry-run     Show what would be done without making changes
  -f, --force       Skip confirmation prompts
  -h, --help        help for remove
      --no-commit   Skip automatic git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project run

Run a command inside a project directory

### Synopsis

Run any shell command inside a project directory from anywhere in the campaign.

The project is resolved in this order:
  1. --project / -p flag (explicit project name)
  2. Auto-detect from current working directory
  3. Interactive fuzzy picker (if neither above applies)

Use -- to separate camp flags from the command to execute.

Examples:
  # Interactive project picker, then run command
  camp project run -- ls -la

  # Specify project explicitly
  camp project run -p fest -- just build
  camp project run --project camp -- go test ./...

  # Auto-detect from cwd (inside projects/fest/)
  camp project run -- just test all

  # Simple commands (no -- needed when no flags)
  camp project run make build

```
camp project run [--project <name>] [--] <command> [args...] [flags]
```

### Options

```
  -h, --help   help for run
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project worktree

Manage worktrees for a project

### Synopsis

Manage git worktrees for the current project.

Worktrees allow you to have multiple working directories for the same repository,
enabling parallel development on different branches without stashing or switching.

Auto-detects the current project from your working directory, or use --project
to specify explicitly.

All worktrees are created at: projects/worktrees/<project>/<worktree-name>/

Commands:
  add       Create a new worktree
  list      List worktrees for the project
  remove    Remove a worktree

Examples:
  # From within a project directory
  cd projects/my-api
  camp project worktree add feature-auth      # Creates new branch based on current
  camp project worktree add fix --start-point main  # New branch based on main
  camp project worktree list
  camp project worktree remove feature-auth

  # With explicit project
  camp project worktree add feature-xyz --project my-api

```
camp project worktree [flags]
```

### Options

```
  -h, --help   help for worktree
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project worktree add

Create a new worktree for the project

### Synopsis

Create a new git worktree for the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

The worktree will be created at: projects/worktrees/<project>/<name>/

By default, creates a new branch with the worktree name based on the current branch.
Use --branch to checkout an existing branch instead.

Examples:
  # Create worktree with new branch based on current branch (default)
  camp project worktree add feature-auth

  # Create worktree with new branch based on main
  camp project worktree add experiment --start-point main

  # Checkout existing branch (instead of creating new)
  camp project worktree add hotfix --branch hotfix-123

  # Track a remote branch
  camp project worktree add pr-review --track origin/feature-xyz

  # Explicit project
  camp project worktree add feature --project my-api

```
camp project worktree add <name> [flags]
```

### Options

```
  -b, --branch string        Checkout existing branch instead of creating new one
  -h, --help                 help for add
  -p, --project string       Project name (auto-detected from cwd if not specified)
  -s, --start-point string   Base branch/commit for new branch (default: current branch)
  -t, --track string         Remote branch to track (creates new local tracking branch)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project worktree list

List worktrees for the project

### Synopsis

List all worktrees for the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

Examples:
  # From within a project
  cd projects/my-api
  camp project worktree list

  # Explicit project
  camp project worktree list --project my-api

```
camp project worktree list [flags]
```

### Options

```
  -h, --help             help for list
  -p, --project string   Project name (auto-detected from cwd if not specified)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp project worktree remove

Remove a worktree

### Synopsis

Remove a worktree from the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

Examples:
  # From within a project
  cd projects/my-api
  camp project worktree remove feature-auth

  # Force remove (even with uncommitted changes)
  camp project worktree remove experiment --force

  # Explicit project
  camp project worktree remove feature --project my-api

```
camp project worktree remove <name> [flags]
```

### Options

```
  -f, --force            Force removal even with uncommitted changes
  -h, --help             help for remove
  -p, --project string   Project name (auto-detected from cwd if not specified)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp pull

Pull latest changes from remote

### Synopsis

Pull latest changes from the remote repository.

Works from anywhere within the campaign - always pulls to
the campaign root repository.

Use --sub to pull the submodule detected from your current directory.
Use --project/-p to pull a specific project.
Use 'camp pull all' to pull all repos with upstream tracking.

Any git pull flags are passed through (e.g. --rebase, --ff-only).

Examples:
  camp pull                    # Pull current branch (merge)
  camp pull --rebase           # Pull with rebase
  camp pull --ff-only          # Fast-forward only
  camp pull --sub              # Pull current submodule
  camp pull -p projects/camp   # Pull camp project
  camp pull all                # Pull all repos
  camp pull all --ff-only      # Pull all repos, fast-forward only

```
camp pull [flags] [remote] [branch]
```

### Options

```
  -h, --help   help for pull
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

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
---

## camp push

Push campaign changes to remote

### Synopsis

Push campaign changes to the remote repository.

Works from anywhere within the campaign - always pushes from
the campaign root repository.

Use --sub to push from the submodule detected from your current directory.
Use --project/-p to push from a specific project.
Use 'camp push all' to push all repos that have unpushed commits.

Examples:
  camp push                    # Push current branch
  camp push origin main        # Push to specific remote/branch
  camp push --force            # Force push
  camp push -u origin feature  # Push and set upstream
  camp push --sub              # Push current submodule
  camp push -p projects/camp   # Push camp project
  camp push all                # Push all repos with unpushed commits
  camp push all --force        # Force push all repos

```
camp push [flags] [remote] [branch]
```

### Options

```
  -h, --help   help for push
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

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
---

## camp refs-sync

Sync submodule ref pointers in campaign root

### Synopsis

Update the campaign root's recorded submodule pointers to match
each submodule's current HEAD. Creates a single atomic commit.

Without arguments, syncs all submodules. Specify paths to sync specific ones.

Examples:
  camp refs-sync                      # Sync all dirty refs
  camp refs-sync projects/camp        # Sync specific submodule
  camp refs-sync --dry-run            # Show plan without executing

```
camp refs-sync [submodule...] [flags]
```

### Options

```
  -n, --dry-run   Show plan without executing
  -f, --force     Skip safety checks (staged changes)
  -h, --help      help for refs-sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp register

Register campaign in global registry

### Synopsis

Register an existing campaign in the global registry.

This adds the campaign to the registry at ~/.obey/campaign/registry.yaml,
enabling it to appear in 'camp list' and be accessible via navigation commands.

Note: 'camp init' automatically registers new campaigns. This command is for
registering existing campaigns that weren't created with camp or were unregistered.

If the specified path is not a campaign (has no .campaign/ directory),
you'll be offered the option to initialize it.

Examples:
  camp register                          # Register current directory
  camp register ~/Dev/my-project         # Register specified path
  camp register . --name custom-name     # Override the campaign name
  camp register . --type research        # Override the campaign type

```
camp register [path] [flags]
```

### Options

```
  -h, --help          help for register
  -n, --name string   Override campaign name
  -t, --type string   Override campaign type (product, research, tools, personal)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp registry

Manage the campaign registry

### Synopsis

Manage the campaign registry at ~/.obey/campaign/registry.json.

The registry tracks all known campaigns for quick navigation and lookup.
Use these commands to maintain registry health and resolve issues.

Commands:
  prune   Remove stale entries (campaigns that no longer exist)
  sync    Update registry entry for current campaign
  check   Validate registry integrity

Examples:
  camp registry prune             Remove entries for non-existent campaigns
  camp registry prune --dry-run   Show what would be removed
  camp registry sync              Update path for current campaign
  camp registry check             Check for issues

### Options

```
  -h, --help   help for registry
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp registry check

Check registry integrity

### Synopsis

Validate the registry and report any issues found.

Checks for:
- Stale entries (paths that don't exist)
- Missing .campaign/ directories
- Campaigns in /tmp/ directories
- Duplicate entries (multiple IDs pointing to the same path)

Examples:
  camp registry check   Show any registry issues

```
camp registry check [flags]
```

### Options

```
  -h, --help   help for check
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp registry prune

Remove stale registry entries

### Synopsis

Remove registry entries where the campaign no longer exists.

Checks each registered path and removes entries where:
- The path no longer exists
- The path has no .campaign/ directory

Options:
  --dry-run       Show what would be removed without making changes
  --include-temp  Also remove entries in /tmp/ directories

Examples:
  camp registry prune             Remove stale entries
  camp registry prune --dry-run   Preview what would be removed
  camp registry prune --include-temp  Also clean up test campaigns

```
camp registry prune [flags]
```

### Options

```
      --dry-run        Show what would be removed without making changes
  -h, --help           help for prune
      --include-temp   Also remove entries in /tmp/ directories
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp registry sync

Sync current campaign with registry

### Synopsis

Update the registry entry for the current campaign.

Run this after moving a campaign directory to update its path
in the registry. Reads the campaign ID from .campaign/campaign.yaml
and updates (or adds) the registry entry.

Examples:
  camp registry sync   # Run from inside a campaign

```
camp registry sync [flags]
```

### Options

```
  -h, --help   help for sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp run

Execute command from campaign root, or just recipe in a project

### Synopsis

Execute any command from the campaign root directory, or run just recipes
in a project directory.

If the first argument exactly matches a project name (a directory in projects/
with a git repo), camp dispatches to 'just' in that project's directory.
Any remaining arguments are passed as the recipe and arguments to just.

If the first argument does not match a project, it is treated as a shell command
and executed from the campaign root directory.

Use @shortcut prefix to run from a shortcut's directory instead of root.
Only navigation shortcuts (those with paths) can be used.

All arguments after 'run' (or '@shortcut') are passed directly to the shell.

```
camp run [project | @shortcut] [command | recipe] [args...] [flags]
```

### Examples

```
  # Project just dispatch (first arg matches a project name):
  camp run fest              # Show just recipes for fest project
  camp run fest build        # Run 'just build' in projects/fest/
  camp run camp test all     # Run 'just test all' in projects/camp/

  # Raw command from campaign root (first arg is not a project):
  camp run ls -la            # List campaign root contents
  camp run just --list       # Show just recipes from root

  # Shortcut-based execution:
  camp run @p ls             # List projects/ directory
  camp run @f make test      # Run make from festivals/
```

### Options

```
  -h, --help   help for run
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp settings

Manage camp configuration

### Synopsis

Interactive menu for managing global and local camp settings.

```
camp settings [flags]
```

### Options

```
  -h, --help   help for settings
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp shell-init

Output shell initialization code

### Synopsis

Output shell initialization code for your shell config.

Add to your shell config:
  zsh:  eval "$(camp shell-init zsh)"
  bash: eval "$(camp shell-init bash)"
  fish: camp shell-init fish | source

This provides:
  - cgo function for navigation
  - Tab completion for camp commands
  - Category shortcuts (p, c, f, etc.)

The cgo function enables quick navigation:
  cgo                 Interactive picker or jump to campaign root
  cgo p               Jump to projects/
  cgo p api           Fuzzy find "api" in projects/
  cgo -c p ls         Run "ls" in projects/ directory

```
camp shell-init <shell> [flags]
```

### Examples

```
  # Add to ~/.zshrc
  eval "$(camp shell-init zsh)"

  # Add to ~/.bashrc
  eval "$(camp shell-init bash)"

  # Add to ~/.config/fish/config.fish
  camp shell-init fish | source
```

### Options

```
  -h, --help   help for shell-init
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp shortcuts

List all available shortcuts

### Synopsis

List all navigation and command shortcuts from .campaign/campaign.yaml.

Navigation shortcuts (path-based):
  These shortcuts jump to directories within the campaign.
  Usage: camp go <shortcut>

Command shortcuts (command-based):
  These shortcuts execute commands from specified directories.
  Usage: camp run <shortcut> [args...]

Default shortcuts are added when you run 'camp init'.
You can customize shortcuts by editing .campaign/campaign.yaml.

```
camp shortcuts [flags]
```

### Examples

```
  camp shortcuts              # List all shortcuts
  camp go api                 # Use navigation shortcut
  camp run build              # Use command shortcut
```

### Options

```
  -h, --help   help for shortcuts
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp shortcuts add

Add a shortcut (campaign-level or project sub-shortcut)

### Synopsis

Add a shortcut for quick navigation.

Campaign-level shortcut (2 args):
  Adds a navigation shortcut to .campaign/settings/jumps.yaml.
  Usage: camp shortcuts add <name> <path>

Project sub-shortcut (3 args):
  Adds a sub-directory shortcut within a project.
  Usage: camp shortcuts add <project> <name> <path>

With no arguments, launches an interactive TUI for entering
shortcut details.

```
camp shortcuts add [name] [path] or [project] [name] [path] [flags]
```

### Examples

```
  camp shortcuts add                                  Interactive TUI mode
  camp shortcuts add api projects/api-service/        Campaign shortcut
  camp shortcuts add api projects/api/ -d "API svc"   With description
  camp shortcuts add cfg "" -c config                 Concept-only shortcut
  camp shortcuts add camp default cmd/camp/            Project sub-shortcut
```

### Options

```
  -c, --concept string       Command group for expansion
  -d, --description string   Help text for the shortcut
  -h, --help                 help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp shortcuts list

List shortcuts for a specific project

### Synopsis

List all sub-shortcuts configured for a specific project.

If no project is specified, lists all campaign shortcuts.

```
camp shortcuts list [project] [flags]
```

### Examples

```
  camp shortcuts list festival-methodology
  camp shortcuts list fest  # Fuzzy match
```

### Options

```
  -h, --help   help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp shortcuts remove

Remove a shortcut (campaign-level or project sub-shortcut)

### Synopsis

Remove a shortcut.

Campaign-level shortcut (1 arg):
  Usage: camp shortcuts remove <name>

Project sub-shortcut (2 args):
  Usage: camp shortcuts remove <project> <name>

```
camp shortcuts remove <name> or <project> <name> [flags]
```

### Examples

```
  camp shortcuts remove api                           Remove campaign shortcut
  camp shortcuts remove festival-methodology cli      Remove project sub-shortcut
```

### Options

```
  -h, --help   help for remove
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp skills

Manage campaign skill directory links

### Synopsis

Manage campaign skill bundle projection for tool interoperability.

Skills are centralized in .campaign/skills/ and projected into tool ecosystems
(Claude, agents, etc.) as per-bundle symlinks. This keeps a single source of
truth while preserving existing provider-native skills directories.

Commands:
  link     Project per-skill symlinks into a tool-specific skills directory
  status   Show projection status for tool-specific skills directories
  unlink   Remove projected skill symlinks

Examples:
  camp skills link --tool claude    Project skills into .claude/skills/
  camp skills link --tool agents    Project skills into .agents/skills/
  camp skills status                Show all skill projection states
  camp skills unlink --tool claude  Remove projected symlinks from .claude/skills/

```
camp skills [flags]
```

### Options

```
  -h, --help   help for skills
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp skills link

Project campaign skill bundles into tool-specific skills directories

### Synopsis

Project campaign skill bundles from .campaign/skills/ into tool-specific
skills directories.

This command creates one symlink per skill bundle. It does not replace entire
provider skills directories, so existing user skills remain intact.

Examples:
  camp skills link --tool claude       Project skills into .claude/skills/
  camp skills link --tool agents       Project skills into .agents/skills/
  camp skills link --path custom/dir   Project skills into custom/dir
  camp skills link --tool claude -n    Dry run — show what would happen
  camp skills link --tool claude -f    Replace conflicting symlink entries

```
camp skills link [flags]
```

### Options

```
  -n, --dry-run       Show what would happen without making changes
  -f, --force         Replace conflicting symlink entries (never files/directories)
  -h, --help          help for link
  -p, --path string   Custom destination directory
  -t, --tool string   Tool to link: claude, agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp skills status

Show the current state of projected skill bundle symlinks

### Synopsis

Show projection status for campaign skill bundles across tool targets.

Reports whether each tool's skills directory has projected entries from
.campaign/skills/, is partially projected, missing, broken, or blocked.

Examples:
  camp skills status          Show projection states in table format
  camp skills status --json   Machine-readable JSON output

```
camp skills status [flags]
```

### Options

```
  -h, --help     help for status
      --json     Output as JSON
      --strict   Return non-zero exit code when links need attention (for CI)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp skills unlink

Remove projected skill bundle symlinks

### Synopsis

Remove managed skill bundle symlinks created by 'camp skills link'.

Only removes projected symlink entries created from .campaign/skills bundles.
It never removes non-symlink files/directories or foreign symlinks.

Examples:
  camp skills unlink --tool claude       Remove projected entries in .claude/skills/
  camp skills unlink --tool agents       Remove projected entries in .agents/skills/
  camp skills unlink --path custom/dir   Remove projected entries in custom/dir
  camp skills unlink --tool claude -n    Dry run — show what would happen

```
camp skills unlink [flags]
```

### Options

```
  -n, --dry-run       Show what would happen without making changes
  -h, --help          help for unlink
  -p, --path string   Custom destination directory to unlink
  -t, --tool string   Tool to unlink: claude, agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp status

Show git status of the campaign

### Synopsis

Show git status of the campaign root directory.

Works from anywhere within the campaign - always shows the status
of the campaign root repository.

Use --sub to show status of the submodule detected from your current directory.
Use --project/-p to show status of a specific project.

Examples:
  camp status           # Full status
  camp status -s        # Short format (git flag)
  camp status --short   # Short format (git flag)
  camp status --sub     # Status of current submodule
  camp status -p projects/camp  # Status of camp project

```
camp status [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp status all

Show git status of all submodules

### Synopsis

Show a visual overview of git status for all submodules in the campaign.

Displays a table with each submodule's name, branch, clean/dirty state,
and push status. Results are cached for quick subsequent lookups.

Examples:
  camp status all           # Show all submodule statuses
  camp status all --json    # Output as JSON
  camp status all --no-cache  # Skip cache, refresh all

```
camp status all [flags]
```

### Options

```
  -h, --help         help for all
      --json         Output as JSON
      --no-cache     Skip cache and refresh
      --no-recurse   Only list top-level submodules
      --view         Open interactive TUI viewer
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp switch

Switch to a different campaign

### Synopsis

Switch to a registered campaign by name or ID.

Without arguments, opens an interactive picker to select a campaign.
With an argument, looks up the campaign by name or ID prefix.

Use with the cgo shell function for instant navigation:
  cgo switch                 # Interactive campaign picker
  cgo switch my-campaign     # Switch by name
  cgo switch a1b2             # Switch by ID prefix

The --print flag outputs just the path for shell integration:
  cd "$(camp switch --print)"

```
camp switch [campaign] [flags]
```

### Examples

```
  camp switch                    # Interactive picker
  camp switch obey-campaign      # Switch by name
  camp switch a1b2               # Switch by ID prefix
  camp switch --print            # Picker, output path only
```

### Options

```
  -h, --help    help for switch
      --print   Print path only (for shell integration)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp sync

Safely synchronize submodules

### Synopsis

Synchronize submodules with pre-flight safety checks.

The sync command performs three critical operations:

  1. PRE-FLIGHT CHECKS
     Verifies no uncommitted changes or unpushed commits that could
     be lost during synchronization.

  2. URL SYNCHRONIZATION
     Copies URLs from .gitmodules to .git/config, fixing URL mismatches
     that occur when remote URLs change.

  3. SUBMODULE UPDATE
     Fetches and checks out the correct commits for all submodules.

This order is critical: sync-before-update prevents silent code deletion
when URLs change on remote repositories.

EXIT CODES:
  0  Success
  1  Pre-flight check failed (uncommitted changes)
  2  Sync or update operation failed
  3  Post-sync validation failed
  4  Invalid arguments

EXAMPLES:
  # Sync all submodules (recommended default)
  camp sync

  # Preview what would happen without making changes
  camp sync --dry-run

  # Sync a specific submodule only
  camp sync projects/camp

  # Force sync despite uncommitted changes (dangerous!)
  camp sync --force

  # Detailed output for each submodule
  camp sync --verbose

  # JSON output for scripting
  camp sync --json

```
camp sync [submodule...] [flags]
```

### Options

```
  -n, --dry-run        Show what would happen without making changes
  -f, --force          Skip safety checks (uncommitted changes warning still shown)
  -h, --help           help for sync
      --json           Output results as JSON for scripting
      --no-fetch       Skip fetching from remote (use local refs only)
  -p, --parallel int   Number of parallel git operations (default 4)
  -v, --verbose        Show detailed output for each submodule
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```
---

## camp transfer

Copy files between campaigns

### Synopsis

Copy files between different campaigns using campaign:path syntax.

Transfer always copies — it never moves or deletes the source.
Either the source or destination (or both) can use "campaign:path"
notation to reference a different registered campaign. Paths without
a campaign prefix resolve relative to the current campaign root.

At least one side must reference a different campaign. For copies
within the same campaign, use 'camp copy' instead.

```
camp transfer <src> <dest> [flags]
```

### Examples

```
  camp transfer docs/my-doc.md other-campaign:docs/my-doc.md     # push
  camp transfer other-campaign:docs/my-doc.md docs/              # pull
  camp transfer other:festivals/plan.md festivals/planned/       # pull into dir
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for transfer
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp unpin

Remove a directory bookmark

### Synopsis

Remove a pinned directory bookmark by name.

Without arguments, detects and unpins the current directory.

```
camp unpin [name] [flags]
```

### Options

```
  -h, --help   help for unpin
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp unregister

Remove campaign from registry

### Synopsis

Remove a campaign from the global registry.

This does NOT delete any files - it only removes the campaign from
tracking in the global registry. Use this when:
  - A campaign directory was deleted manually
  - A campaign was moved to a different location
  - You no longer want to track a campaign

The campaign files remain untouched on disk.

You can specify the campaign by name or ID (or ID prefix).

Examples:
  camp unregister old-project            # Remove by name
  camp unregister 550e84                 # Remove by ID prefix
  camp unregister old-project --force    # Remove without confirmation

```
camp unregister <name-or-id> [flags]
```

### Options

```
  -f, --force   Skip confirmation prompt
  -h, --help    help for unregister
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## camp version

Show version information

### Synopsis

Show camp version, build information, and runtime details.

Examples:
  camp version           Show full version info
  camp version --short   Show only version number
  camp version --json    Output as JSON

```
camp version [flags]
```

### Options

```
  -h, --help    help for version
      --json    output as JSON
  -s, --short   show only version number
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```