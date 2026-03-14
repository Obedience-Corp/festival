---
title: "fest CLI Reference"
linkTitle: "fest CLI Reference"
description: "Festival Methodology CLI - goal-oriented project management for AI agents"
weight: 1
---

# fest CLI Reference

---

## fest

Festival Methodology CLI - goal-oriented project management for AI agents

### Synopsis

fest manages Festival Methodology - a goal-oriented project management
system designed for AI agent development workflows.

GETTING STARTED (for AI agents):
```bash
  fest understand methodology    Learn core principles first
  fest understand structure      Understand the 3-level hierarchy
  fest understand tasks          Learn when/how to create task files
  fest validate                  Check if a festival is properly structured
```

COMMON WORKFLOWS:
```bash
  fest create festival           Create a new festival (interactive TUI)
  fest create phase/sequence     Add phases or sequences to existing festival
  fest validate --fix            Fix common structure issues automatically
  fest go                        Navigate to festivals directory
```

SYSTEM MAINTENANCE:
```bash
  fest system sync               Download latest templates from source
  fest system update             Update .festival/ methodology files
```

Run 'fest understand' to learn the methodology before executing tasks.

### Options

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
  -h, --help            help for fest
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest apply

Apply a local template to a destination file (copy or render)

### Synopsis

Apply a local template (from .festival/templates) to a destination file. Copy if no variables provided; render if variables exist.

```
fest apply [flags]
```

### Options

```
  -h, --help                   help for apply
      --json                   Emit JSON output
      --template-id string     Template ID or alias (from frontmatter)
      --template-path string   Path to template file (relative to .festival/templates or absolute)
      --to string              Destination file path (required)
      --vars-file string       JSON file providing variables for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain

Manage festival chains (inter-festival dependencies)

### Synopsis

Create, validate, and track chains of dependent festivals.

### Options

```
  -h, --help   help for chain
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain check

Check if a festival is unblocked within its chain

### Synopsis

Quick check whether a specific festival's hard dependencies are met.

```
fest chain check <ref-or-id> [flags]
```

### Options

```
      --chain string   specify chain ID for disambiguation
  -h, --help           help for check
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain complete

Complete and archive a chain

### Synopsis

Mark a chain as completed and move it to festivals/dungeon/completed/chains/.

All festivals in the chain must be completed unless --force is used.

```
fest chain complete <chain-id> [flags]
```

### Options

```
      --force          complete even if not all festivals are done
  -h, --help           help for complete
      --notes string   completion notes for the status history
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain create

Create a new festival chain

### Synopsis

Create a new chain YAML definition file in festivals/chains/.

```
fest chain create [flags]
```

### Options

```
      --goal string   chain goal description
  -h, --help          help for create
      --name string   chain name (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain graph

Visualize chain dependency graph

### Synopsis

Render the chain's dependency graph as ASCII waves or Mermaid diagram syntax.

```
fest chain graph <chain-id> [flags]
```

### Options

```
  -h, --help      help for graph
      --live      annotate nodes with live festival statuses
      --mermaid   output Mermaid diagram syntax
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain list

List all festival chains

```
fest chain list [flags]
```

### Options

```
  -h, --help            help for list
      --status string   filter by status (planning|active|completed)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain status

Show chain status and progress

```
fest chain status <chain-id> [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest chain validate

Validate a festival chain

### Synopsis

Run all structural validation checks (S1-S10) against a chain definition.
Use --cross to validate across all chains.

```
fest chain validate <chain-id> [flags]
```

### Options

```
      --cross   validate across all chains (duplicate IDs, conflicts)
  -h, --help    help for validate
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest commit

Create git commit with task reference

### Synopsis

Create a git commit with the festival/task ID embedded in the message.

Requires festival context: either run from inside a festival directory,
a linked project directory (see 'fest link'), or use --festival to specify one.

The fest commit command wraps git commit and automatically:
  1. Stages all changes (git add -A) unless --stage=false
  2. Prepends the festival reference to the commit message

Reference format: [OBEY-FE-{id}]
  - OBEY: Obey workflow tool prefix
  - FE: Festival component identifier
  - {id}: Task ref (FEST-xxxxxx) or festival ID (e.g., CS0001)

Detection priority:
  1. Explicit --task flag value
  2. Task fest_ref from current directory (if inside festival task)
  3. Festival ID from fest.yaml metadata
  4. Explicit --festival flag (name or ID)

Examples:
```bash
  fest commit -m "Implement feature"
  # In linked project → [OBEY-FE-CS0001] Implement feature
  # In festival task  → [OBEY-FE-FEST-a3b2c1] Implement feature

  fest commit --task FEST-b4c5d6 -m "Related work"
  # → [OBEY-FE-FEST-b4c5d6] Related work

  fest commit --festival OA0001 -m "Work from unlinked dir"
  # → [OBEY-FE-OA0001] Work from unlinked dir

  fest commit --no-tag -m "No reference"
  # → No reference

  fest commit --stage=false -m "Only commit staged"
  # Skip auto-staging, commit only what's already staged
```

```
fest commit [flags]
```

### Options

```
      --festival string      festival name or ID (overrides auto-detection)
  -h, --help                 help for commit
      --json                 output result as JSON
  -m, --message string       commit message
      --no-tag               don't prepend task reference
      --stage                auto-stage all changes before commit (default true)
      --sync-submodule-ref   sync submodule ref at campaign root after commit
      --task string          task reference ID to use (e.g., FEST-a3b2c1)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest commits

Query commits by festival element

### Synopsis

Query git commits that reference festival elements.

Search commits by task ID, sequence, or phase. Uses git log with grep
to find commits that contain festival references in their messages.

Examples:
```bash
  fest commits                           # All commits for current festival
  fest commits --task FEST-a3b2c1        # Commits for specific task
  fest commits --sequence 01_foundation  # Commits for sequence
  fest commits --phase 002_IMPLEMENT     # Commits for phase
  fest commits --limit 20                # Limit results
```

```
fest commits [flags]
```

### Options

```
  -h, --help              help for commits
      --json              output as JSON
      --limit int         maximum number of commits to return (default 50)
      --phase string      query commits for phase
      --sequence string   query commits for sequence
      --task string       query commits for specific task (e.g., FEST-a3b2c1)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest completion

Generate shell completion scripts

### Synopsis

Generate shell completion scripts for fest.

This command generates shell-specific completion scripts that enable
tab completion for commands, flags, and arguments.

SETUP:

  Bash:
```bash
    # Add to ~/.bashrc:
    source <(fest completion bash)

    # Or save to a file:
    fest completion bash > /usr/local/etc/bash_completion.d/fest

  Zsh:
    # Add to ~/.zshrc:
    source <(fest completion zsh)

    # Or save to completions directory:
    fest completion zsh > "${fpath[1]}/_fest"

  Fish:
    fest completion fish | source

    # Or save to completions directory:
    fest completion fish > ~/.config/fish/completions/fest.fish

  PowerShell:
    fest completion powershell | Out-String | Invoke-Expression
```

CUSTOM COMPLETIONS:

After setup, you can tab-complete:
```bash
  fest status act<TAB>     → fest status active/
  fest show pla<TAB>       → fest show plan
  fest create <TAB>        → festival, phase, sequence, task
```

```
fest completion [bash|zsh|fish|powershell]
```

### Options

```
  -h, --help   help for completion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config

Manage fest configuration repositories

### Synopsis

Manage fest configuration repositories.

Config repos contain custom templates, policies, plugins, and extensions
that override or extend the built-in fest methodology resources.

### Options

```
  -h, --help   help for config
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config add

Add a configuration repository

### Synopsis

Add a configuration repository from a git URL or local path.

For git repos, the repository will be cloned to ~/.config/fest/config-repos/<name>.
For local paths, a symlink will be created instead.

```
fest config add <name> <source> [flags]
```

### Examples

```
  fest config add myconfig https://github.com/user/fest-config
  fest config add local /path/to/my/config
  fest config add work git@github.com:company/fest-templates.git
```

### Options

```
  -h, --help   help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config list

List all configuration repositories

### Synopsis

List all configured configuration repositories.

```
fest config list [flags]
```

### Options

```
  -h, --help   help for list
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config remove

Remove a configuration repository

### Synopsis

Remove a configuration repository.

For git repos, this removes the cloned directory.
For local symlinks, this only removes the symlink (not the original directory).

```
fest config remove <name> [flags]
```

### Examples

```
  fest config remove myconfig
```

### Options

```
      --force   skip confirmation
  -h, --help    help for remove
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config show

Show active configuration

### Synopsis

Show the currently active configuration repository and its details.

```
fest config show [flags]
```

### Options

```
  -h, --help   help for show
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config sync

Sync configuration repository

### Synopsis

Sync a configuration repository (git pull for git repos).

If no name is provided, syncs all configured repos.

```
fest config sync [name] [flags]
```

### Examples

```
  fest config sync myconfig
  fest config sync  # syncs all repos
```

### Options

```
  -h, --help   help for sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config theme

Manage TUI color theme

### Synopsis

Manage the TUI color theme for fest commands.

Available themes:
  adaptive      Auto-detect light/dark terminal (default)
  light         Optimized for light backgrounds
  dark          Optimized for dark backgrounds
  high-contrast Pure white + bright colors (works on any background)

Use 'fest config theme test' to preview all themes on your terminal.

### Options

```
  -h, --help   help for theme
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config theme set

Set the TUI theme

### Synopsis

Set the TUI color theme.

Available themes:
  adaptive      Auto-detect light/dark terminal (default)
  light         Optimized for light backgrounds
  dark          Optimized for dark backgrounds
  high-contrast Pure white + bright colors (works on any background)

```
fest config theme set <theme> [flags]
```

### Examples

```
  fest config theme set high-contrast
  fest config theme set dark
```

### Options

```
  -h, --help   help for set
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config theme show

Show current theme setting

```
fest config theme show [flags]
```

### Options

```
  -h, --help   help for show
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config theme test

Preview all themes side by side

### Synopsis

Preview all available themes to see which works best on your terminal background.

This displays sample TUI elements with each theme so you can compare
how they look on your current terminal background color.

```
fest config theme test [flags]
```

### Options

```
  -h, --help   help for test
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest config use

Set active configuration repository

### Synopsis

Set a configuration repository as the active one.

The active config repo is symlinked at ~/.config/fest/active and its
contents are used for templates, policies, plugins, and extensions.

```
fest config use <name> [flags]
```

### Examples

```
  fest config use myconfig
  fest config use work
```

### Options

```
  -h, --help   help for use
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest context

Get context for the current location or task

### Synopsis

Provides AI agents with context for the current location in a festival.

Context includes:
  - Festival, phase, and sequence goals
  - Relevant rules from FESTIVAL_RULES.md
  - Recent decisions from CONTEXT.md
  - Dependency outputs (what prior tasks produced)

Depth levels:
  minimal   - Immediate goals, dependencies, autonomy level
  standard  - + Rules, recent decisions (5)
  full      - + All decisions, dependency outputs

Examples:
```bash
  fest context                    # Context for current location
  fest context --depth full       # Full context with all details
  fest context --task my_task     # Context for a specific task
  fest context --json             # Output as JSON
  fest context --verbose          # Explanatory output for agents
```

```
fest context [flags]
```

### Options

```
      --depth string   context depth (minimal, standard, full) (default "standard")
  -h, --help           help for context
      --json           output as JSON
      --task string    get context for a specific task
      --verbose        output with explanatory text for agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest create

Create festivals, phases, sequences, or tasks (TUI)

```
fest create [flags]
```

### Options

```
  -h, --help   help for create
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest create festival

Create a new festival scaffold under festivals/planning

```
fest create festival [flags]
```

### Options

```
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dest string           Destination under festivals/: planning or ritual (use 'fest promote' to advance to active) (default "planning")
      --dry-run               Show template markers without creating file
      --goal string           Festival goal
  -h, --help                  help for festival
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Festival name (required)
  -p, --project string        Project directory path (auto-links to festival)
      --skip-markers          Skip REPLACE marker processing
      --tags string           Comma-separated tags
      --type string           Festival type (standard, implementation, research, quick, ritual)
      --vars-file string      JSON file with variables
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest create phase

Insert a new phase and render its goal file

```
fest create phase [flags]
```

### Options

```
      --after int             Insert after this phase number (-1 or omit to append at end) (default -1)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --description string    Phase objective (auto-fills Primary Goal marker)
      --dry-run               Show template markers without creating file
      --festival string       Path to festival directory (use when not inside a festival)
  -h, --help                  help for phase
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Phase name (required)
      --path string           Path to festival root (directory containing numbered phases) (default ".")
      --skip-markers          Skip REPLACE marker processing
      --type string           Phase type (planning|implementation|research|review|ingest|non_coding_action) (default "planning")
      --vars-file string      JSON vars for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest create sequence

Insert a new sequence and render its goal file

### Synopsis

Create a new sequence directory with SEQUENCE_GOAL.md.

IMPORTANT: After creating a sequence, you must also create TASK FILES.
The SEQUENCE_GOAL.md defines WHAT to achieve, but AI agents need task
files to know HOW to execute. See 'fest understand tasks'.

TEMPLATE VARIABLES (automatically set):
  {{ sequence_name }}        Name of the sequence
  {{ sequence_number }}      Sequential number (01, 02, ...)
  {{ sequence_id }}          Full ID (e.g., "01_api_endpoints")
  {{ parent_phase_id }}      Parent phase ID

EXAMPLES:
```bash
  # Create sequence in current phase
  fest create sequence --name "api endpoints" --json

  # Create sequence at specific position
  fest create sequence --name "frontend" --after 2 --json
```

NEXT STEPS after creating a sequence:
```bash
  # Add task files (required for implementation sequences)
  fest create task --name "design" --json
  fest create task --name "implement" --json

  # Add quality gates
  fest gates apply --approve
```

Run 'fest validate tasks' to verify task files exist.

```
fest create sequence [flags]
```

### Options

```
      --after int             Insert after this sequence number (-1 or omit to append at end) (default -1)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dry-run               Show template markers without creating file
      --festival string       Path to festival directory (use when not inside a festival)
  -h, --help                  help for sequence
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Sequence name (required)
      --no-prompt             Skip interactive prompts
      --path string           Path to phase directory (directory containing numbered sequences) (default ".")
      --skip-markers          Skip REPLACE marker processing
      --vars-file string      JSON vars for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest create task

Insert a new task file in a sequence

### Synopsis

Create new task file(s) with automatic numbering and template rendering.

IMPORTANT: AI agents execute TASK FILES, not goals. If your sequences only
have SEQUENCE_GOAL.md without task files, agents won't know HOW to execute.

BATCH CREATION: Use multiple --name flags to create sequential tasks at once.
This avoids the common mistake of all tasks getting numbered 01_.

TEMPLATE VARIABLES (automatically set from --name):
  {{ task_name }}            Name of the task
  {{ task_number }}          Sequential number (01, 02, ...)
  {{ task_id }}              Full filename (e.g., "01_design.md")
  {{ parent_sequence_id }}   Parent sequence ID
  {{ parent_phase_id }}      Parent phase ID
  {{ full_path }}            Complete path from festival root

EXAMPLES:
```bash
  # Create single task in current sequence
  fest create task --name "design endpoints" --json

  # Create multiple tasks at once (sequential numbering)
  fest create task --name "requirements" --name "design" --name "implement"
  # Creates: 01_requirements.md, 02_design.md, 03_implement.md

  # Create tasks starting after position 2
  fest create task --after 2 --name "new step" --name "another step"
  # Creates: 03_new_step.md, 04_another_step.md

  # Create task in specific sequence
  fest create task --name "setup" --path ./002_IMPLEMENT/01_api --json
```

MARKER FILLING (for AI agents):
```bash
  # Fill all REPLACE markers in one command
  fest create task --name "setup" --markers '{"Brief description": "Auth middleware", "Yes/No": "Yes"}'

  # Preview template markers first (dry-run)
  fest create task --name "setup" --dry-run --json

  # Skip marker filling (leave REPLACE tags)
  fest create task --name "setup" --skip-markers
```

Run 'fest understand tasks' for detailed guidance on task file creation.
Run 'fest validate tasks' to verify task files exist in implementation sequences.

```
fest create task [flags]
```

### Options

```
      --after int             Insert after this number (0 inserts at beginning)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dry-run               Show template markers without creating file
  -h, --help                  help for task
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name strings          Task name(s) - can be specified multiple times for batch creation
      --path string           Path to sequence directory (directory containing numbered task files) (default ".")
      --skip-markers          Skip REPLACE marker processing
      --vars-file string      JSON vars for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest create workflow

Create a WORKFLOW.md for a phase from structured step definitions

### Synopsis

Generate a WORKFLOW.md file for an existing phase directory.

Takes structured JSON input (inline or file) and produces a parseable WORKFLOW.md
that matches the format expected by the workflow parser.

Examples:
```bash
  # From a steps file
  fest create workflow --steps-file steps.json --position after

  # Inline JSON (for agents)
  fest create workflow --steps '{"title":"Review","steps":[...]}' --position before

  # With explicit phase path
  fest create workflow --steps-file steps.json --path ./004_POLISH
```

```
fest create workflow [flags]
```

### Options

```
      --agent               Strict agent mode (implies --json)
      --festival string     Festival root override
  -h, --help                help for workflow
      --json                Emit JSON output
      --path string         Phase directory path (default ".")
      --position string     Workflow position relative to sequences (before|after) (default "after")
      --steps string        Inline JSON with workflow definition
      --steps-file string   Path to JSON file with workflow definition
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest deps

Show task dependencies

### Synopsis

Display dependency information for tasks in the festival.

Without arguments, shows the dependency graph for the current sequence.
With a task name, shows dependencies for that specific task.

Examples:
```bash
  fest deps                    # Show all deps in current sequence
  fest deps 02_implement       # Show deps for specific task
  fest deps --all              # Show all deps in festival
  fest deps --json             # Output as JSON
  fest deps --critical-path    # Show critical path through the DAG
```

```
fest deps [task] [flags]
```

### Options

```
      --all             show all dependencies in festival
      --critical-path   show the critical path
  -h, --help            help for deps
      --json            output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest feedback

Manage structured feedback collection

### Synopsis

Collect and manage structured feedback during festival execution.

Feedback allows agents to record observations based on defined criteria
for later aggregation and analysis.

Examples:
```bash
  fest feedback init --criteria "Code quality" --criteria "Performance"
  fest feedback add --criteria "Code quality" --observation "Found duplication"
  fest feedback view
  fest feedback export --format markdown
```

### Options

```
  -h, --help   help for feedback
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest feedback add

Add a feedback observation

### Synopsis

Add a feedback observation for a defined criteria.

Use either flags or JSON input to add an observation.

Examples:
```bash
  fest feedback add --criteria "Code quality" --observation "Found duplicate logic"
  fest feedback add --json '{"criteria": "Performance", "observation": "N+1 query"}'
  fest feedback add --criteria "Code quality" --observation "..." --severity high --suggestion "Refactor"
```

```
fest feedback add [flags]
```

### Options

```
      --criteria string      criteria category
  -h, --help                 help for add
      --json string          JSON observation object
      --observation string   observation text
      --severity string      severity: low, medium, high
      --suggestion string    suggested action
      --task string          related task path
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest feedback export

Export collected feedback

### Synopsis

Export collected feedback to a file format.

Supports markdown, JSON, and YAML output formats.

Examples:
```bash
  fest feedback export --format markdown > report.md
  fest feedback export --format json > report.json
  fest feedback export --format yaml
```

```
fest feedback export [flags]
```

### Options

```
      --format string   output format: markdown, json, yaml (default "markdown")
  -h, --help            help for export
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest feedback init

Initialize feedback collection

### Synopsis

Initialize feedback collection with defined criteria.

Creates a feedback/ directory in the current festival with
configuration for the specified criteria.

Examples:
```bash
  fest feedback init --criteria "Code quality observations"
  fest feedback init --criteria "Performance concerns" --criteria "Methodology suggestions"
```

```
fest feedback init [flags]
```

### Options

```
      --criteria strings   feedback criteria (required)
  -h, --help               help for init
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest feedback view

View collected feedback

### Synopsis

View collected feedback observations.

Filter by criteria or severity, or view a summary of all feedback.

Examples:
```bash
  fest feedback view
  fest feedback view --criteria "Code quality"
  fest feedback view --severity high
  fest feedback view --summary
  fest feedback view --json
```

```
fest feedback view [flags]
```

### Options

```
      --criteria string   filter by criteria
  -h, --help              help for view
      --json              output in JSON format
      --severity string   filter by severity
      --summary           show summary only
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest gates

Manage quality gates - validation steps at sequence end

### Synopsis

Manage quality gate policies for festivals.

Quality gates are validation steps that run at the end of implementation sequences.
Gates are configured in fest.yaml under the implementation section.

Available Commands:
  show      Show effective gate policy from fest.yaml
  apply     Apply quality gates to sequences
  remove    Remove quality gate files from sequences

### Options

```
  -h, --help   help for gates
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest gates apply

Apply quality gates to sequences

### Synopsis

Apply quality gate task files to sequences based on phase type.

By default, runs in dry-run mode showing what would change.
Use --approve to actually apply the changes.

Gates are read from the fest.yaml implementation section.
Only implementation phases have quality gates.

Quality gates are only added to sequences not matching excluded_patterns.

```
fest gates apply [flags]
```

### Examples

```
  # Preview changes (dry-run is default)
  fest gates apply

  # Apply to all sequences
  fest gates apply --approve

  # Apply to specific sequence
  fest gates apply --sequence 002_IMPL/01_core --approve

  # Force overwrite modified files
  fest gates apply --approve --force

  # JSON output for automation
  fest gates apply --json
```

### Options

```
      --approve           Apply changes
      --dry-run           Preview changes without applying (default) (default true)
      --force             Overwrite modified files
  -h, --help              help for apply
      --json              Output JSON
      --phase string      Apply to specific phase
      --sequence string   Apply to specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest gates remove

Remove quality gate files from sequences

### Synopsis

Remove quality gate task files from implementation sequences.

Only files with fest_managed: true marker in frontmatter are removed.
This safely removes only gate files, not regular task files.

By default, runs in dry-run mode showing what would be removed.
Use --approve to actually remove the files.

```
fest gates remove [flags]
```

### Examples

```
  # Preview what would be removed (dry-run is default)
  fest gates remove

  # Remove all gates from all sequences
  fest gates remove --approve

  # Remove gates from specific phase
  fest gates remove --phase 001_IMPLEMENTATION --approve

  # Remove gates from specific sequence
  fest gates remove --sequence 001_IMPL/01_core --approve

  # JSON output for automation
  fest gates remove --json
```

### Options

```
      --approve           Actually remove files
      --dry-run           Preview changes without removing (default) (default true)
  -h, --help              help for remove
      --json              Output JSON
      --phase string      Remove from specific phase
      --sequence string   Remove from specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest gates show

Show effective gate policy

### Synopsis

Display the effective gate policy for a festival, phase, or sequence.
Shows which gates are active and where each gate originated from.

```
fest gates show [flags]
```

### Examples

```
  fest gates show
  fest gates show --phase 002_IMPLEMENT
  fest gates show --sequence 002_IMPLEMENT/01_core --json
```

### Options

```
  -h, --help              help for show
      --json              Output in JSON format
      --phase string      Show gates for specific phase
      --sequence string   Show gates for specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go

Navigate to festivals/ - use 'fgo' after shell-init setup

### Synopsis

Navigate to your workspace's festivals directory.

The go command finds the festivals/ directory that has been registered
as your active workspace using 'fest init --register'.

By default, outputs 'cd /path' for human-friendly display.
Use --print to output just the bare path (for scripts, tools, and agents).

SHELL INTEGRATION (recommended):
```bash
  # Add to ~/.zshrc or ~/.bashrc:
  eval "$(fest shell-init zsh)"
```

Then use 'fgo' to navigate:
  fgo              Navigate to festivals root
  fgo 002          Navigate to phase 002
  fgo 2/1          Navigate to phase 2, sequence 1
  fgo fest_improv  Fuzzy match to fest-improvements-*

Without shell integration, use command substitution:
  cd "$(fest go --print)"
  cd "$(fest go 002 --print)"

Fuzzy matching is supported - partial names like "impl" will match
phases containing "IMPLEMENT". Multiple words narrow the search.

If no registered festivals are found, falls back to nearest festivals/.

```
fest go [target] [flags]
```

### Options

```
      --all         list all registered festivals directories
  -h, --help        help for go
      --json        output in JSON format
      --print       print path only (for shell integration, scripts, and agents)
      --workspace   show which workspace was detected
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go fest

Navigate back to festival from linked project

### Synopsis

Navigate back to the festival that is linked to the current project directory.

This is the reverse of 'fgo project'.

```
fest go fest [flags]
```

### Options

```
  -h, --help    help for fest
      --print   accepted for shell integration compatibility
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go link

Link current festival to a project directory (or vice versa)

### Synopsis

Create a bidirectional link between a festival and a project directory.

When run inside a festival:
  - Links the festival to the specified project directory
  - If no path provided, prompts for directory input

When run inside a project directory (non-festival):
  - Shows an interactive picker to select a festival to link
  - Links the current project to the selected festival

After linking:
  - 'fgo' in the festival jumps to the project
  - 'fgo' in the project jumps to the festival

Examples:
```bash
  # Inside a festival, link to project:
  fgo link /path/to/project
  fgo link .                    # Link to current directory (if not in festival)

  # Inside a project, show festival picker:
  fgo link
```

```
fest go link [path] [flags]
```

### Options

```
  -h, --help   help for link
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go list

List navigation shortcuts and links

### Synopsis

Display all navigation shortcuts and festival-project links.

SHORTCUTS are user-defined with 'fest go map'.
LINKS are festival-project associations created with 'fest link'.

Use --interactive (-i) to select a destination with an interactive picker.
When used with shell integration (fgo list), this will navigate to the selected path.

```
fest go list [flags]
```

### Examples

```
  fest go list           # List all shortcuts and links
  fest go list --json    # Output in JSON format
  fest go list -i        # Interactive picker (with fgo: navigates to selection)
```

### Options

```
  -h, --help          help for list
  -i, --interactive   interactive picker mode
      --json          output in JSON format
      --print         accepted for shell integration compatibility
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go map

Create a navigation shortcut

### Synopsis

Create a shortcut for quick navigation using fgo.

If path is omitted, the current directory is used.
Shortcut names must be alphanumeric (with underscores), 1-20 characters.

Usage with fgo:
  fgo -<name>    Navigate to the shortcut

```
fest go map <name> [path] [flags]
```

### Examples

```
  fest go map n                   # Create shortcut 'n' to current directory
  fest go map api /path/to/api    # Create shortcut 'api' to specific path

  # Then navigate with:
  fgo -n      # Navigate to notes
  fgo -api    # Navigate to API directory
```

### Options

```
  -h, --help   help for map
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go move

Move files between festival and linked project

### Synopsis

Move or copy files between a festival and its linked project directory.

The command automatically detects which direction to move based on your
current directory:

  - In festival directory: moves TO linked project
  - In linked project: moves TO festival

Examples:
```bash
  # In project directory, move file to festival
  fest move ./analysis.md

  # In festival directory, move file to project
  fest move ./specs/api.go --to-project

  # Copy instead of move (keeps original)
  fest move --copy ./notes.md

  # Force overwrite existing files
  fest move --force ./config.yml
```

Requirements:
  - Festival must have project_path set in fest.yaml
  - Must be in either festival or linked project directory

```
fest go move <source> [destination] [flags]
```

### Options

```
  -c, --copy         copy instead of move
  -f, --force        overwrite existing files
  -h, --help         help for move
      --json         output in JSON format
      --to-project   move from festival to project
  -v, --verbose      show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest go project

Navigate to linked project directory

### Synopsis

Navigate to the project directory linked to the current festival.

Use 'fest link <path>' to create a link from within a festival.

```
fest go project [flags]
```

### Options

```
  -h, --help    help for project
      --print   accepted for shell integration compatibility
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest go unmap

Remove a navigation shortcut

### Synopsis

Remove a previously created navigation shortcut.

```
fest go unmap <name> [flags]
```

### Examples

```
  fest go unmap n     # Remove shortcut 'n'
  fest go unmap api   # Remove shortcut 'api'
```

### Options

```
  -h, --help   help for unmap
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest id

Show the festival ID for the current context

### Synopsis

Display the festival ID for the current location.

Works from inside a festival directory or from a project linked to one.
The ID is read from fest.yaml metadata, falling back to the directory name.

Examples:
```bash
  fest id          # Print the festival ID (e.g., SR0001)
  fest id --json   # Output as JSON with id, name, and path
```

```
fest id [flags]
```

### Options

```
  -h, --help   help for id
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index

Manage festival indices

### Synopsis

Generate and validate festival indices for Guild integration.

The index file (.festival/index.json) provides a machine-readable representation
of the festival structure, including phases, sequences, and tasks.

For workspace-wide indexing (Guild v3), use the 'tree' subcommand.

### Options

```
  -h, --help   help for index
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index diff

Compare tree indexes to detect changes

### Synopsis

Compare two tree indexes to detect changes between them.

This is useful for tracking progress over time or detecting changes
since the last sync.

```
fest index diff [flags]
```

### Options

```
  -h, --help         help for diff
      --json         Output as JSON
      --old string   Path to old tree index file (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index show

Show festival index contents

### Synopsis

Display the contents of the festival index file.

```
fest index show [festival-path] [flags]
```

### Options

```
  -h, --help   help for show
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index tree

Generate workspace-wide tree index

### Synopsis

Generate a tree index of all festivals in the workspace.

The tree index groups festivals by status (planning, active, completed, dungeon)
and provides a complete hierarchical view for Guild v3 integration.

```
fest index tree [flags]
```

### Options

```
  -h, --help            help for tree
      --json            Output as JSON
  -o, --output string   Save tree index to file
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index validate

Validate festival index against filesystem

### Synopsis

Validate that the festival index matches the actual filesystem structure.

Reports:
- Entries in index that don't exist on disk (missing)
- Files on disk that aren't in the index (extra)
- Missing goal files (warnings)

```
fest index validate [festival-path] [flags]
```

### Options

```
  -h, --help           help for validate
  -i, --index string   Path to index file (default: .festival/index.json)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest index write

Generate festival index

### Synopsis

Generate a festival index from the filesystem structure.

The index is written to .festival/index.json within the festival directory.
Use --output to write to a different location.

```
fest index write [festival-path] [flags]
```

### Options

```
  -h, --help            help for write
  -o, --output string   Output path (default: .festival/index.json)
      --pretty          Pretty print JSON output (default true)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest init

Initialize a new festival directory structure

### Synopsis

Initialize a new festival directory structure in the current or specified directory.

This command copies the festival template structure from your local cache
(populated by 'fest sync') and creates initial checksum tracking.

Workspace Registration:
  Use --register to mark an existing festivals/ directory as your active workspace.
  This enables 'fest go' to navigate directly to it from anywhere in the project.

  Use --unregister to remove the workspace marker, making the festivals/
  directory invisible to 'fest go' (useful for source repositories).

```
fest init [path] [flags]
```

### Examples

```
  fest init                      # Initialize in current directory
  fest init ./my-project         # Initialize in specified directory
  fest init --force              # Overwrite existing festival
  fest init --minimal            # Create minimal structure only
  fest init --register           # Register existing festivals as workspace
  fest init --unregister         # Remove workspace registration
```

### Options

```
      --force          overwrite existing festival directory
      --from string    source directory (default: ~/.obey/fest)
  -h, --help           help for init
      --minimal        create minimal structure only
      --no-checksums   skip checksum generation
      --register       register existing festivals as active workspace
      --unregister     remove workspace registration
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest insert

Insert new festival elements

### Synopsis

Insert a new phase, sequence, or task and renumber subsequent elements.

This command creates a new element and automatically renumbers all
following elements to maintain proper ordering.

### Options

```
      --backup    create backup before changes
      --dry-run   preview changes without applying them (default true)
  -h, --help      help for insert
      --verbose   show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest insert phase

Insert a new phase

### Synopsis

Insert a new phase after the specified number and renumber subsequent phases.
		
The new phase will be created with the proper 3-digit numbering format.

```
fest insert phase [festival-dir] [flags]
```

### Examples

```
  fest insert phase --after 1 --name "DESIGN_REVIEW"
  fest insert phase ./my-festival --after 2 --name "TESTING"
  fest insert phase --after 0 --name "REQUIREMENTS" # Insert at beginning
```

### Options

```
      --after int     insert after this phase number (0 for beginning)
  -h, --help          help for phase
      --name string   name of the new phase
```

### Options inherited from parent commands

```
      --backup          create backup before changes
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest insert sequence

Insert a new sequence within a phase

### Synopsis

Insert a new sequence after the specified number and renumber subsequent sequences.
		
The new sequence will be created with the proper 2-digit numbering format.

```
fest insert sequence [flags]
```

### Examples

```
  fest insert sequence --phase 001_PLAN --after 1 --name "validation"
  fest insert sequence --phase ./003_IMPLEMENT --after 0 --name "setup"
```

### Options

```
      --after int      insert after this sequence number (0 for beginning)
  -h, --help           help for sequence
      --name string    name of the new sequence
      --phase string   phase directory to insert sequence in
```

### Options inherited from parent commands

```
      --backup          create backup before changes
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest insert task

Insert a new task within a sequence

### Synopsis

Insert a new task after the specified number and renumber subsequent tasks.
		
The new task will be created with the proper 2-digit numbering format.
Note: Tasks are markdown files, so .md extension will be added automatically.

```
fest insert task [flags]
```

### Examples

```
  fest insert task --sequence 001_PLAN/01_requirements --after 1 --name "validate_input"
  fest insert task --sequence ./path/to/sequence --after 0 --name "setup"
```

### Options

```
      --after int         insert after this task number (0 for beginning)
  -h, --help              help for task
      --name string       name of the new task (without .md extension)
      --sequence string   sequence directory to insert task in
```

### Options inherited from parent commands

```
      --backup          create backup before changes
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest intro

Getting started guide for fest CLI and common workflows

### Synopsis

Display a getting started guide for AI agents using the fest CLI.

This command provides essential information for quickly becoming productive
with Festival Methodology and the fest CLI commands.

SUBCOMMANDS:
```bash
  fest intro             Show the getting started guide
  fest intro workflows   Show common workflow patterns
```

After reading the intro, explore deeper with:
```bash
  fest understand methodology    Core principles and philosophy
  fest understand structure      3-level hierarchy explained
  fest understand tasks          When to create task files
```

```
fest intro [flags]
```

### Options

```
  -h, --help   help for intro
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest intro workflows

Common fest workflow patterns

### Synopsis

Display common workflow patterns for using fest CLI effectively.

Covers workflows for:
  - Starting a new project
  - Executing existing festivals
  - Adding structure to festivals
  - Checking and fixing structure
  - Navigation shortcuts
  - Machine-readable output

```
fest intro workflows [flags]
```

### Options

```
  -h, --help   help for workflows
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest link

Link festival to project directory (context-aware)

### Synopsis

Link a festival to a project directory with context-aware behavior.

When run inside a festival:
  - Links the festival to the specified project path
  - If no path provided, prompts for directory input

When run inside a project directory (non-festival):
  - Shows an interactive picker to select a festival to link
  - Links the current project to the selected festival

After linking, use 'fgo' to navigate between them.

The link is stored centrally in ~/.config/fest/navigation.yaml.
Use 'fest links' to see all festival-project links.
Use 'fest unlink' to remove the link for current festival.

```
fest link [path] [flags]
```

### Examples

```
  fest link /path/to/project   # Inside festival: link to project
  fest link .                  # Inside festival: link to cwd
  fest link                    # Inside festival: prompt for path
  fest link                    # Inside project: show festival picker
  fest link --show             # Display current link
```

### Options

```
  -h, --help   help for link
      --json   output in JSON format
      --show   show current link
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest links

List all festival-project links

### Synopsis

Display all festival-project links.

Shows a table of all festivals that have been linked to project directories.

```
fest links [flags]
```

### Examples

```
  fest links        # List all links
  fest links --json # List in JSON format
```

### Options

```
  -h, --help   help for links
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest list

List festivals by status

### Synopsis

List festivals filtered by status.

Works from anywhere - finds the festivals workspace automatically.

STATUS can be: active, planning, completed, dungeon, dungeon/completed, dungeon/archived, dungeon/someday

By default, shows only active and planning festivals.
Use --all to include completed and dungeon festivals.

```
fest list [status] [flags]
```

### Examples

```
  fest list                                       # List active and planning festivals
  fest list --all                                  # List all festivals
  fest list --filter-project camp                  # Festivals linked to "camp" project
  fest list --since 2026-01-01                     # Festivals created since Jan 1
  fest list --since 2026-01-01 --until 2026-02-01  # Created in January 2026
  fest list --filter-project fest --status active   # Active festivals for "fest" project
  fest list --json                                 # Output in JSON format
```

### Options

```
      --all                     include completed and dungeon festivals
      --alpha                   sort alphabetically by name instead of by date
      --filter-project string   filter festivals linked to a project path (substring match)
  -h, --help                    help for list
      --json                    output in JSON format
      --progress                show detailed progress for each festival
      --since string            show festivals created on or after this date (YYYY-MM-DD or RFC3339)
      --sort string             sort by: date|status|progress|name|created|updated
      --status string           filter by status: active|planning|completed|dungeon
      --until string            show festivals created on or before this date (YYYY-MM-DD or RFC3339)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest markers

Manage template markers in festival files

### Synopsis

View and manage unfilled template markers in festival files.

Template markers are placeholders that must be replaced with actual content:
  [FILL: description]    - Write actual content
  [REPLACE: guidance]    - Replace with your content
  [GUIDANCE: hint]       - Remove and write real content
  {{ placeholder }}      - Fill in the value

Use subcommands to list markers or fill them interactively.

### Options

```
  -h, --help          help for markers
      --json          Output results as JSON
      --path string   Festival path (default: current directory)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest markers count

Count unfilled template markers

### Synopsis

Show a summary count of unfilled template markers by type.

```
fest markers count [flags]
```

### Options

```
  -h, --help   help for count
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```
---

## fest markers list

List all unfilled template markers

### Synopsis

Scan festival files and list all unfilled template markers with their locations.

```
fest markers list [flags]
```

### Options

```
  -h, --help   help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```
---

## fest markers next

Show the next file with unfilled markers

### Synopsis

Show the next file that needs markers filled, with context hierarchy.

Files are presented in priority order:
1. Festival-level files (FESTIVAL_GOAL.md, FESTIVAL_OVERVIEW.md, TODO.md)
2. Phase-level files (PHASE_GOAL.md for each phase)
3. Sequence-level files (SEQUENCE_GOAL.md for each sequence)
4. Task files (within each sequence)

The context hierarchy is shown to help understand how the file relates to
the overall festival goals.

```
fest markers next [flags]
```

### Options

```
  -h, --help   help for next
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```
---

## fest markers scaffold

Generate marker JSON from template

### Synopsis

Generate a JSON or YAML file with all template markers pre-populated as keys.

This allows agents to fill marker values without manually typing hint strings,
eliminating typos and reducing token usage.

Examples:
```bash
  # Generate from built-in template
  fest markers scaffold --template task-simple

  # Generate from existing file
  fest markers scaffold --file PHASE_GOAL.md

  # Output as YAML to a file
  fest markers scaffold --template sequence --format yaml --output markers.yaml
```

Available template aliases:
  task, task-simple, task-minimal    Task templates
  sequence, sequence-minimal         Sequence templates
  phase, phase-impl, phase-planning  Phase templates
  festival, festival-overview        Festival templates
  gate-testing, gate-review          Quality gate templates

```
fest markers scaffold [flags]
```

### Options

```
      --file string       Path to file with markers
      --format string     Output format: json or yaml (default "json")
  -h, --help              help for scaffold
      --output string     Output file path (default: stdout)
      --template string   Built-in template name (e.g., task, phase, sequence)
      --with-hints        Include hint descriptions as comments
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```
---

## fest markers validate

Validate marker JSON against template

### Synopsis

Validate a marker JSON or YAML file against a template to detect issues.

This command checks for:
  - Missing required markers (present in template but not in file)
  - Empty marker values
  - Unknown markers (possible typos)

In strict mode (--strict), unknown markers cause validation to fail.

Examples:
```bash
  # Validate against built-in template
  fest markers validate --file markers.json --template task-simple

  # Validate against existing file
  fest markers validate --file markers.json --source PHASE_GOAL.md

  # Strict mode - fail on unknown markers
  fest markers validate --file markers.json --template task --strict
```

```
fest markers validate [flags]
```

### Options

```
      --file string       Marker file to validate (required)
  -h, --help              help for validate
      --source string     Source file to validate against
      --strict            Fail on unknown markers
      --template string   Template to validate against
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```
---

## fest migrate

Migrate festival documents

### Synopsis

Migrate festival documents to add missing features or update formats.

Available migrations:
  frontmatter   Add YAML frontmatter to existing documents
  metadata      Add ID and metadata to existing festivals
  times         Populate time tracking data from file modification times

Examples:
```bash
  fest migrate frontmatter              # Add frontmatter to all docs
  fest migrate frontmatter --dry-run    # Preview changes
  fest migrate frontmatter --fix        # Auto-fix existing frontmatter
  fest migrate metadata                 # Add IDs to all festivals
  fest migrate metadata --dry-run       # Preview ID migrations
  fest migrate times                    # Populate time data from file stats
  fest migrate times --dry-run          # Preview time migrations
```

### Options

```
  -h, --help   help for migrate
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest migrate frontmatter

Add YAML frontmatter to existing documents

### Synopsis

Add YAML frontmatter to festival documents that don't have it.

This command walks through all festival documents and adds frontmatter
to any that are missing it. Existing frontmatter is preserved.

Examples:
```bash
  fest migrate frontmatter              # Add frontmatter to all docs
  fest migrate frontmatter --dry-run    # Preview changes without writing
  fest migrate frontmatter --fix        # Update/fix existing frontmatter
  fest migrate frontmatter --verbose    # Show detailed progress
```

```
fest migrate frontmatter [flags]
```

### Options

```
      --dry-run   preview changes without writing
      --fix       update/fix existing frontmatter
  -h, --help      help for frontmatter
      --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest migrate metadata

Add metadata to existing festivals

### Synopsis

Migrate existing festivals to use the ID system.

This command:
1. Generates a unique ID for festivals without one
2. Adds metadata to fest.yaml (ID, UUID, creation time)
3. Renames the festival directory to include the ID suffix

The migration is idempotent - running it multiple times is safe.

Examples:
```bash
  fest migrate metadata                    # Migrate all festivals
  fest migrate metadata ./active/my-fest   # Migrate specific festival
  fest migrate metadata --dry-run          # Preview changes only
```

```
fest migrate metadata [path] [flags]
```

### Options

```
      --dry-run   preview changes without making them
  -h, --help      help for metadata
  -v, --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest migrate times

Populate time tracking data from file modification times

### Synopsis

Retroactively populate time tracking data for existing festivals.

This command walks through festivals and uses file modification times to
infer task completion times for tasks that don't have explicit time data.

The migration:
- Finds all festivals in the specified path (or current directory)
- For each completed task without time data, infers time from file stats
- Updates progress.yaml with the inferred times
- Calculates total work time for the festival

Use --dry-run to preview changes without modifying files.

```
fest migrate times [path] [flags]
```

### Examples

```
  fest migrate times                    # Migrate current festival
  fest migrate times festivals/         # Migrate all festivals in directory
  fest migrate times --dry-run          # Preview changes
  fest migrate times --verbose          # Show detailed progress
```

### Options

```
      --dry-run   preview changes without modifying files
  -h, --help      help for times
      --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest move

Move files between festival and linked project

### Synopsis

Move or copy files between a festival and its linked project directory.

The command automatically detects which direction to move based on your
current directory:

  - In festival directory: moves TO linked project
  - In linked project: moves TO festival

Examples:
```bash
  # In project directory, move file to festival
  fest move ./analysis.md

  # In festival directory, move file to project
  fest move ./specs/api.go --to-project

  # Copy instead of move (keeps original)
  fest move --copy ./notes.md

  # Force overwrite existing files
  fest move --force ./config.yml
```

Requirements:
  - Festival must have project_path set in fest.yaml
  - Must be in either festival or linked project directory

```
fest move <source> [destination] [flags]
```

### Options

```
  -c, --copy         copy instead of move
  -f, --force        overwrite existing files
  -h, --help         help for move
      --json         output in JSON format
      --to-project   move from festival to project
  -v, --verbose      show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest next

Find the next task to work on

### Synopsis

Determine the next task to work on based on dependencies and progress.

The command analyzes the festival structure, checks task completion status,
and recommends the next task following the priority order:

1. Tasks in current sequence with satisfied dependencies
2. Next incomplete task in current phase
3. First incomplete task in earliest phase
4. Quality gates before phase transitions

By default, shows layered goals and full task content inline to provide
complete context for execution.

Output Modes:
  (default)      Layered goals + full task content inline
  --no-context   Hide inline content, show minimal output
  --path         Just the task file path (relative, for piping)
  --short        Task path with status message
  --cd           Directory path for shell cd
  --json         Full result as JSON
  --verbose      Detailed human-readable output

Examples:
```bash
  fest next                    # Find next task with full context
  fest next --no-context       # Minimal output without task content
  fest next --sequence         # Only consider current sequence
  fest next --json             # Output as JSON
  fest next --verbose          # Detailed output
  fest next --short            # Just the task path
  fest next --cd               # Output directory for shell cd
  fest next --path             # Just the relative file path
```

```
fest next [flags]
```

### Options

```
      --cd            output directory path for cd command
  -h, --help          help for next
      --json          output as JSON
  -m, --mode string   override phase type detection (implementation|plan|research|review|action|ingest)
      --navigator     use guidance navigator for output formatting
      --no-context    hide inline content (show minimal output)
      --path          output only the relative task file path
      --sequence      only consider current sequence
      --short         output only the task path
      --verbose       show detailed information
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest parse

Parse festival documents into structured output

### Synopsis

Parse festival documents into structured JSON or YAML output.

This command walks the festival hierarchy and produces structured output
suitable for external tool integration (e.g., Guild v3, visualization tools).

Examples:
```bash
  fest parse                         # Parse current festival as JSON
  fest parse --format yaml           # Output as YAML
  fest parse --type task             # Output flat list of tasks
  fest parse --type gate             # Output only gates
  fest parse --all                   # Parse all festivals
  fest parse --compact               # Summary only (no children)
  fest parse --full                  # Include document content
  fest parse -o output.json          # Write to file
```

```
fest parse [path] [flags]
```

### Options

```
      --all             parse all festivals in workspace
      --compact         compact output (summary only)
      --format string   output format (json, yaml) (default "json")
      --full            include document content
  -h, --help            help for parse
      --infer           infer frontmatter when missing (default true)
  -o, --output string   write output to file
      --type string     filter by entity type (task, gate, phase, sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest progress

Track and display festival execution progress

### Synopsis

Track and display progress for festival execution.

When run without flags, shows an overview of festival progress.
Use flags to update task progress, report blockers, or mark tasks complete.

PROGRESS OVERVIEW:
```bash
  fest progress              Show festival progress summary
  fest progress --json       Output progress in JSON format
```

TASK UPDATES:
```bash
  fest progress --task <id> --update 50%     Update task progress
  fest progress --task <id> --complete       Mark task as complete
  fest progress --task <id> --in-progress    Mark task as in progress
  fest progress --task <id> --blocker "msg"  Report a blocker
  fest progress --task <id> --clear          Clear blocker
  fest progress --path <task_path> --complete
  fest progress --phase <phase> --sequence <seq> --task <id> --complete
```

Task IDs can be festival-relative paths (e.g. 002_FOUNDATION/01_project_scaffold/01_design.md)
or absolute paths. Use --path or --phase/--sequence to disambiguate duplicates.
Use --festival to run outside a festival directory.

```
fest progress [flags]
```

### Examples

```
  fest progress                          # Show overall progress
  fest progress --task 01_setup.md --update 75%
  fest progress --path 002_FOUNDATION/01_project_scaffold/01_design.md --complete
  fest progress --phase 002_FOUNDATION --sequence 01_project_scaffold --task 01_design.md --complete
  fest progress --festival festivals/active/guild-chat-GC0001 --task 01_setup.md --update 75%
  fest progress --task 02_impl.md --blocker "Waiting on API spec"
  fest progress --task 02_impl.md --clear
```

### Options

```
      --blocker string      report a blocker with message
      --clear               clear blocker for task
      --complete            mark task as complete
      --festival string     festival root path (directory containing fest.yaml)
  -h, --help                help for progress
      --in-progress         mark task as in progress
      --interval duration   refresh interval for watch mode (default 2s)
      --json                output in JSON format
      --path string         task path (festival-relative or absolute)
      --phase string        phase directory name for task path
      --sequence string     sequence directory name for task path
      --task string         task ID to update
      --update string       update progress percentage (e.g., 50%)
      --watch               continuously refresh progress display
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest promote

Promote a festival to the next lifecycle status

### Synopsis

Promote moves a festival through the lifecycle: planning → ready → active → completed.

Each transition validates readiness:
  planning → ready:    Festival goal must be defined
  ready → active:      Festival is ready to begin execution
  active → completed:  All tasks must be completed

Use --dungeon to send a festival directly to a dungeon status:
```bash
  fest promote --dungeon someday     Shelve for later
  fest promote --dungeon archived    Archive the festival
  fest promote --dungeon completed   Mark as completed (skips task validation)
```

```
fest promote [flags]
```

### Options

```
      --dungeon string   send to dungeon status (completed, archived, someday)
      --force            skip readiness validation
  -h, --help             help for promote
      --json             output as JSON
      --no-commit        skip auto-commit after promotion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest remove

Remove festival elements and renumber

### Synopsis

Remove a phase, sequence, or task and automatically renumber subsequent elements.

This command safely removes elements and maintains proper numbering
for all following elements in the hierarchy.

### Options

```
      --backup    create backup before removal
      --dry-run   preview changes without applying them (default true)
      --force     skip confirmation prompts
  -h, --help      help for remove
      --verbose   show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest remove phase

Remove a phase and renumber subsequent phases

### Synopsis

Remove a phase by number or path and automatically renumber all following phases.
		
Warning: This will permanently delete the phase and all its contents!

```
fest remove phase [phase-number|phase-path] [flags]
```

### Examples

```
  fest remove phase 2                    # Remove phase 002
  fest remove phase 002_DEFINE_INTERFACES # Remove by directory name
  fest remove phase ./002_DEFINE          # Remove by path
```

### Options

```
  -h, --help   help for phase
```

### Options inherited from parent commands

```
      --backup          create backup before removal
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest remove sequence

Remove a sequence and renumber subsequent sequences

### Synopsis

Remove a sequence by number or name and automatically renumber all following sequences.

Warning: This will permanently delete the sequence and all its contents!

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest remove sequence [sequence-number|sequence-name] [flags]
```

### Examples

```
  fest remove sequence 2                   # Use current phase (if inside one)
  fest remove sequence --phase 1 2          # Numeric shortcut for phase 001_*
  fest remove sequence --phase 001_PLAN 2   # Remove sequence 02
  fest remove sequence --phase 001_PLAN 02_architecture
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before removal
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest remove task

Remove a task and renumber subsequent tasks

### Synopsis

Remove a task by number or name and automatically renumber all following tasks.

Warning: This will permanently delete the task file!

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.

```
fest remove task [task-number|task-name] [flags]
```

### Examples

```
  fest remove task 2                              # Use current sequence (if inside one)
  fest remove task --sequence 1 2                 # Numeric shortcut for sequence 01_*
  fest remove task --phase 1 --sequence 2 3       # Phase 001_*, sequence 02_*
  fest remove task --sequence ./path/to/seq 02_validate.md
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before removal
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --verbose         show detailed output
```
---

## fest renumber

Renumber festival elements

### Synopsis

Renumber phases, sequences, or tasks in a festival structure.

This command helps maintain proper numbering when elements are added,
removed, or reordered in the festival hierarchy.

### Options

```
      --backup         create backup before renumbering
      --dry-run        preview changes without applying them (default true)
  -h, --help           help for renumber
      --skip-dry-run   skip preview and apply changes immediately
      --start int      starting number for renumbering (default 1)
      --verbose        show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest renumber phase

Renumber phases in a festival

### Synopsis

Renumber all phases starting from the specified number (default: 1).
		
Phases are numbered with 3 digits (001, 002, 003, etc.).

```
fest renumber phase [festival-dir] [flags]
```

### Examples

```
  fest renumber phase                    # Renumber phases in current directory (dry-run preview)
  fest renumber phase ./my-festival      # Renumber phases in specified directory
  fest renumber phase --start 2          # Start numbering from 002
  fest renumber phase --skip-dry-run     # Skip preview and apply changes immediately
```

### Options

```
  -h, --help   help for phase
```

### Options inherited from parent commands

```
      --backup          create backup before renumbering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --start int       starting number for renumbering (default 1)
      --verbose         show detailed output
```
---

## fest renumber sequence

Renumber sequences within a phase

### Synopsis

Renumber all sequences in a phase starting from the specified number (default: 1).

Sequences are numbered with 2 digits (01, 02, 03, etc.).

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest renumber sequence [flags]
```

### Examples

```
  fest renumber sequence                            # Use current phase (if inside one)
  fest renumber sequence --phase 1                  # Numeric shortcut for phase 001_*
  fest renumber sequence --phase 001_PLAN           # Renumber sequences in phase
  fest renumber sequence --phase ./003_IMPLEMENT    # Use path to phase
  fest renumber sequence --phase 001_PLAN --start 2 # Start from 02
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before renumbering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --start int       starting number for renumbering (default 1)
      --verbose         show detailed output
```
---

## fest renumber task

Renumber tasks within a sequence

### Synopsis

Renumber all tasks in a sequence starting from the specified number (default: 1).

Tasks are numbered with 2 digits (01, 02, 03, etc.).
Parallel tasks (multiple tasks with the same number) are preserved.

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.
Use --phase to specify the phase when using numeric sequence shortcuts.

```
fest renumber task [flags]
```

### Examples

```
  fest renumber task                              # Use current sequence (if inside one)
  fest renumber task --sequence 1                 # Numeric shortcut for sequence 01_*
  fest renumber task --phase 1 --sequence 2       # Phase 001_*, sequence 02_*
  fest renumber task --sequence 01_requirements   # Use sequence name
  fest renumber task --sequence ./path/to/seq     # Use path to sequence
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before renumbering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --start int       starting number for renumbering (default 1)
      --verbose         show detailed output
```
---

## fest reorder

Reorder festival elements

### Synopsis

Reorder phases, sequences, or tasks by moving an element from one position to another.

This command moves an element to a new position and shifts other elements
accordingly to maintain proper ordering.

### Options

```
      --backup         create backup before reordering
      --dry-run        preview changes without applying them (default true)
      --force          skip confirmation prompts
  -h, --help           help for reorder
      --skip-dry-run   skip preview and apply changes immediately
      --verbose        show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```
---

## fest reorder phase

Reorder phases in a festival

### Synopsis

Move a phase from one position to another within a festival.

Elements between the source and destination positions are shifted accordingly.
For example, moving phase 3 to position 1 will shift phases 1 and 2 down.

```
fest reorder phase <from> <to> [festival-dir] [flags]
```

### Examples

```
  fest reorder phase 3 1                    # Move phase 003 to position 001 (dry-run preview)
  fest reorder phase 1 3 ./my-festival      # Move phase 001 to position 003
  fest reorder phase 4 2 --skip-dry-run     # Apply immediately without preview
```

### Options

```
  -h, --help   help for phase
```

### Options inherited from parent commands

```
      --backup          create backup before reordering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --verbose         show detailed output
```
---

## fest reorder sequence

Reorder sequences within a phase

### Synopsis

Move a sequence from one position to another within a phase.

Elements between the source and destination positions are shifted accordingly.

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest reorder sequence <from> <to> [flags]
```

### Examples

```
  fest reorder sequence 3 1                            # Use current phase (if inside one)
  fest reorder sequence --phase 1 3 1                  # Numeric shortcut for phase 001_*
  fest reorder sequence --phase 001_PLAN 3 1           # Move sequence 03 to position 01
  fest reorder sequence --phase ./003_IMPLEMENT 1 4    # Move sequence 01 to position 04
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before reordering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --verbose         show detailed output
```
---

## fest reorder task

Reorder tasks within a sequence

### Synopsis

Move a task from one position to another within a sequence.

Elements between the source and destination positions are shifted accordingly.
Parallel tasks (multiple tasks with the same number) are moved together.

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.

```
fest reorder task <from> <to> [flags]
```

### Examples

```
  fest reorder task 3 1                               # Use current sequence (if inside one)
  fest reorder task --sequence 1 3 1                  # Numeric shortcut for sequence 01_*
  fest reorder task --phase 1 --sequence 2 3 1        # Phase 001_*, sequence 02_*
  fest reorder task --sequence ./path/to/sequence 1 5
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before reordering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --verbose         show detailed output
```
---

## fest research

Manage research phase documents

### Synopsis

Manage research documents within research phases.

Research phases use flexible subdirectory structures instead of numbered
sequences. This command group helps create, organize, and link research
documents.

Available Commands:
  create    Create a new research document from template
  summary   Generate summary/index of research documents
  link      Link research findings to implementation phases

### Options

```
  -h, --help   help for research
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest research create

Create a new research document from template

### Synopsis

Create a new research document using one of the research templates.

Available document types:
  investigation  - Exploring unknowns, gathering information
  comparison     - Evaluating options, making decisions
  analysis       - Deep-dive technical analysis
  specification  - Defining requirements and design

```
fest research create [flags]
```

### Examples

```
  fest research create --type investigation --title "API Authentication Options"
  fest research create --type comparison --title "Database Selection"
  fest research create --type analysis --title "Performance Baseline"
  fest research create --type specification --title "User API Design"
```

### Options

```
  -h, --help           help for create
      --json           Output in JSON format
  -p, --path string    Destination directory (default ".")
      --title string   Document title (required)
  -t, --type string    Document type (investigation|comparison|analysis|specification)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest research link

Link research findings to implementation phases/tasks

### Synopsis

Link a research document to phases, sequences, or tasks.

This creates references in the research document's frontmatter that indicate
which implementation work is informed by this research. With --bidirectional,
it also adds a reference in the target documents.

```
fest research link <research-doc> [flags]
```

### Examples

```
  fest research link api-auth.md --phase 002_IMPLEMENT
  fest research link db-choice.md --sequence 002_IMPLEMENT/01_core
  fest research link spec.md --task 002_IMPLEMENT/01_core/03_design.md --bidirectional
```

### Options

```
  -b, --bidirectional      Create bidirectional references
  -h, --help               help for link
      --json               Output in JSON format
      --phase strings      Phase to link (can be repeated)
      --sequence strings   Sequence to link (can be repeated)
      --task strings       Task to link (can be repeated)
  -u, --unlink             Remove the specified links
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest research summary

Generate summary/index of research documents

### Synopsis

Generate a summary of all research documents in a research phase or festival.

The summary includes document counts by type and status, and a list of all
research documents with their metadata.

```
fest research summary [flags]
```

### Examples

```
  fest research summary
  fest research summary --phase 001_RESEARCH
  fest research summary --festival
  fest research summary --format json --output research_index.json
```

### Options

```
  -f, --festival        Summarize entire festival
      --format string   Output format (markdown|json) (default "markdown")
  -h, --help            help for summary
      --json            Output in JSON format (shorthand for --format json)
  -o, --output string   Write to file (default: stdout)
  -p, --phase string    Phase to summarize
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest ritual

Manage repeatable ritual festivals

### Options

```
  -h, --help   help for ritual
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest ritual run

Create a new run of a ritual festival in active/

### Synopsis

Copy a ritual festival from ritual/ to active/ with a hex run counter.

The ritual template stays in ritual/ untouched. A new copy is placed
in active/ with an appended hex counter (e.g., -0001, -000A, -00FF).

The counter auto-increments by scanning active/ and dungeon/completed/
for existing runs.

```
fest ritual run <ritual-name-or-id> [flags]
```

### Options

```
  -h, --help   help for run
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest rules

Display festival rules for the current festival

### Synopsis

Reads and displays the FESTIVAL_RULES.md file for the current festival.

```
fest rules [flags]
```

### Options

```
  -h, --help   help for rules
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest scaffold

Generate festival structures from plans

### Synopsis

Generate complete festival structures from plan documents.

The scaffold command reads a markdown plan document (like STRUCTURE.md) and
generates the corresponding festival directory structure with phases, sequences,
and tasks pre-populated from the plan.

Examples:
```bash
  fest scaffold from-plan --plan path/to/STRUCTURE.md --name my-festival
  fest scaffold from-plan --plan STRUCTURE.md --dry-run
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --json
```

### Options

```
  -h, --help   help for scaffold
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest scaffold from-plan

Generate festival structure from a plan document

### Synopsis

Read a markdown plan document and generate the corresponding festival structure.

The plan document should follow the STRUCTURE.md format with a hierarchy section
containing phases, sequences, and tasks.

Examples:
```bash
  # Generate from a plan document
  fest scaffold from-plan --plan path/to/STRUCTURE.md --name my-festival

  # Preview what would be created
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --dry-run

  # Agent mode with JSON output
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --agent
```

```
fest scaffold from-plan [flags]
```

### Options

```
      --agent         Agent mode: JSON output
      --dest string   Destination: active or planning (default "active")
      --dry-run       Preview without creating files
  -h, --help          help for from-plan
      --json          Emit JSON output
      --name string   Festival name (required)
      --plan string   Path to the plan document (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest search

Search festivals by name, ID, or goal text

### Synopsis

Search across all festivals in the workspace using fuzzy matching.

Matches against:
  - Festival directory names
  - Festival IDs (from frontmatter)
  - Goal text (from FESTIVAL_OVERVIEW.md)

Results are ranked by relevance with exact and prefix matches scored highest.

```
fest search <query> [flags]
```

### Examples

```
  fest search intents           # Find festivals matching "intents"
  fest search --status active   # Search only active festivals
  fest search RI0001            # Search by festival ID
  fest search --json deploy     # JSON output for scripting
```

### Options

```
  -h, --help            help for search
      --json            output results as JSON
      --limit int       maximum number of results (default 20)
      --status string   limit search to status: active|planning|completed|dungeon
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest shell-init

Output shell integration code for festival helpers

### Synopsis

Output shell code that provides shell helper functions.

This command outputs shell-specific code that creates helper functions:
- fgo: Wraps 'fest go' to change your working directory
- fls: Wraps 'fest list' for quick festival listing

SETUP (one-time):
```bash
  # For zsh, add to ~/.zshrc:
  eval "$(fest shell-init zsh)"

  # For bash, add to ~/.bashrc:
  eval "$(fest shell-init bash)"

  # For fish, add to ~/.config/fish/config.fish:
  fest shell-init fish | source
```

After setup, reload your shell or run: source ~/.zshrc

USAGE - fgo (navigation):
  fgo              Smart navigation (linked project ↔ festival, or festivals root)
  fgo 002          Navigate to phase 002
  fgo 2/1          Navigate to phase 2, sequence 1
  fgo active       Navigate to active directory
  fgo link         Link current festival to project (or vice versa)
  fgo --help       Show fgo help

USAGE - fls (listing):
  fls              List all festivals grouped by status
  fls active       List active festivals only
  fls --json       List festivals in JSON format
  fls --help       Show fest list help

```
fest shell-init <shell> [flags]
```

### Examples

```
  # Output zsh integration code
  fest shell-init zsh

  # Add to your shell config (zsh)
  eval "$(fest shell-init zsh)"

  # After setup, use the helpers:
  fgo              # Go to festivals root
  fgo 2            # Go to phase 002
  fls              # List all festivals
  fls active       # List active festivals
```

### Options

```
  -h, --help   help for shell-init
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show

Display festival information

### Synopsis

Display festival information by status or show details of a specific festival.

When run inside a festival directory, shows the current festival's details.
When run with a status argument, lists all festivals with that status.

SUBCOMMANDS:
```bash
  fest show              Show current festival (detect from cwd)
  fest show active       List festivals in active/ directory
  fest show planning     List festivals in planning/ directory
  fest show completed    List festivals in completed/ directory
  fest show dungeon      List festivals in dungeon/ directory
  fest show all          List all festivals grouped by status
  fest show <name>       Show details of a specific festival by name
  fest show --festival <selector>  Show a festival by explicit selector (campaign workspace)
```

```
fest show [status|festival-name] [flags]
```

### Options

```
      --collapsed         show collapsed tree with counters only
      --festival string   festival selector (name or ID) from within a campaign workspace
      --goals             show goals for phases and sequences
  -h, --help              help for show
      --inprogress        expand only in-progress phases and sequences
      --json              output in JSON format
      --roadmap           show full execution roadmap with task statuses
      --summary           show aggregate summary instead of tree view
      --watch             continuously refresh display
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show active

List festivals in active/ directory

```
fest show active [flags]
```

### Options

```
  -h, --help   help for active
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show all

List all festivals grouped by status

```
fest show all [flags]
```

### Options

```
  -h, --help   help for all
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show completed

List completed festivals

```
fest show completed [flags]
```

### Options

```
  -h, --help   help for completed
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show dungeon

List festivals in dungeon/ directory

### Synopsis

List festivals in dungeon/ directory.

Optionally specify a substatus: completed, archived, someday.
Without a substatus, lists all dungeon festivals.

```
fest show dungeon [substatus] [flags]
```

### Options

```
  -h, --help   help for dungeon
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest show planning

List festivals in planning/ directory

```
fest show planning [flags]
```

### Options

```
  -h, --help   help for planning
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest status

Manage and query festival entity statuses

### Synopsis

Manage and query status for festivals, phases, sequences, tasks, and gates.

When run without arguments, shows the status of the current entity based on
your working directory location.

EXAMPLES:
```bash
  fest status                                  # Status from current directory
  fest status ./festivals/active/my-festival   # Status for specific path
  fest status active/my-festival               # Relative to festivals/ root
```

SUBCOMMANDS:
```bash
  fest status              Show current entity status
  fest status set <status> Change entity status
  fest status list         List entities by status
  fest status history      View status change history
```

```
fest status [path] [flags]
```

### Options

```
  -h, --help          help for status
      --json          output in JSON format
      --type string   entity type to query (festival, phase, sequence, task, gate)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest status history

View status change history

### Synopsis

View the history of status changes for the current entity.

History is stored in .fest/status_history.json within each festival.

```
fest status history [flags]
```

### Examples

```
  fest status history            # Show status history
  fest status history --limit 10 # Show last 10 changes
```

### Options

```
  -h, --help        help for history
      --json        output in JSON format
      --limit int   maximum number of entries to show (default 20)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest status list

List entities by status

### Synopsis

List festivals, phases, sequences, or tasks filtered by status.

Without filters, lists all festivals grouped by status.

```
fest status list [flags]
```

### Examples

```
  fest status list                     # List all festivals by status
  fest status list --status active     # List active festivals only
  fest status list --type task --status pending  # List pending tasks
```

### Options

```
  -h, --help            help for list
      --json            output in JSON format
      --status string   filter by status
      --type string     entity type (festival, phase, sequence, task) (default "festival")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest status set

Change entity status

### Synopsis

Change the status of the current entity.

CONTEXT-AWARE BEHAVIOR:
When no explicit level flag is provided, the command auto-detects the
appropriate level based on your current directory:

  Festival root  → Sets festival status (planning/active/completed/dungeon)
  Phase directory → Sets phase status (pending/in_progress/completed)
  Sequence directory → Sets sequence status (pending/in_progress/completed)
  Task directory → Shows hint (task status requires explicit --task flag)

For festivals, this will move the directory between status folders.
If not inside a festival, an interactive selector will be shown.

EXPLICIT TARGETING:
Use flags to override auto-detection:
  --phase    Target a specific phase
  --sequence Target a specific sequence
  --task     Target a specific task
  --path     Target by explicit file path

These flags are mutually exclusive - only one level can be targeted at a time.

```
fest status set <status> [flags]
```

### Examples

```
  fest status set ready                # Set current festival to ready
  fest status set active               # Set current festival to active
  fest status set active -i            # Force interactive selection
  fest status set planning --force     # Override without prompts (e.g., backward transition)
  fest status set in_progress          # Set phase/sequence/task status

  # Level-specific status setting:
  fest status set --phase 001_CRITICAL completed
  fest status set --phase 001 in_progress
  fest status set --sequence 01_api_design completed
  fest status set --sequence 002/01 pending
  fest status set --task 01_analyze.md in_progress
  fest status set --task 001/01/02_impl.md completed
  fest status set --path ./002/01/task.md blocked
```

### Options

```
      --force             skip all prompts including non-standard transition warnings
  -h, --help              help for set
  -i, --interactive       force interactive festival selection
      --json              output in JSON format
      --no-commit         skip auto-commit after status change
      --path string       explicit file path for status change
      --phase string      target phase by name or number (e.g., '001_CRITICAL' or '001')
      --sequence string   target sequence by name (e.g., '01_api_design' or '002/01')
      --task string       target task by filename or path (e.g., '01_analyze.md' or '001/01/02_impl.md')
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest system

Manage fest tool configuration and templates

### Synopsis

Commands for maintaining the fest tool itself.

These commands manage fest's templates, configuration, and methodology
files - NOT your festival content. Use these to keep fest up to date.

Available subcommands:
  config - Manage fest configuration settings (TUI)
  sync   - Download latest templates from GitHub
  update - Update .festival/ files from cached templates
  repair - Fix festival directory layout issues

### Options

```
  -h, --help   help for system
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest system config

Manage fest configuration settings

### Synopsis

Interactive TUI for managing fest configuration.

Navigate to a setting to edit it. Changes are saved immediately.
Configuration is stored in ~/.config/fest/config.json.

Use arrow keys or j/k to navigate, Enter to select, Esc to exit.

```
fest system config [flags]
```

### Examples

```
  fest system config           # Open configuration TUI
  fest system config --show    # Display current configuration
```

### Options

```
  -h, --help   help for config
      --show   display current configuration as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest system repair

Fix festival directory layout issues

### Synopsis

Repair the festivals/ directory by detecting and fixing common issues.

This command analyzes your festival directory structure and fixes:
  - Renames planned/ → planning/ (old naming convention)
  - Moves completed/ → dungeon/completed/ (old layout)
  - Creates missing directories (ready/, ritual/, dungeon/ subdirs)
  - Creates .workflow.yaml if missing
  - Moves orphan festivals from dungeon/ root → dungeon/archived/
  - Converts legacy progress.yaml → progress_events.jsonl

The repair command is safe to run multiple times - it only makes changes
when issues are detected.

```
fest system repair [flags]
```

### Options

```
      --dry-run   preview changes without executing
      --force     skip confirmation prompt
  -h, --help      help for repair
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest system sync

System: Download latest fest templates from GitHub

### Synopsis

Download the latest fest methodology templates from GitHub to ~/.obey/fest/

This is a SYSTEM command that maintains fest itself, not your festival content.
It fetches the complete .festival/ template structure from the configured
repository and stores it locally for use with 'fest init' and 'fest system update'.

Run this periodically to get the latest methodology templates and documentation.

```
fest system sync [flags]
```

### Examples

```
  fest system sync                              # Use defaults (channel-based)
  fest system sync --channel stable               # Sync latest stable tag
  fest system sync --tag v0.1.0                   # Sync exact tag
  fest system sync --branch main                  # Sync from branch
  fest system sync --source github.com/user/repo  # Sync from specific repo
  fest system sync --force                        # Overwrite existing cache
```

### Options

```
      --branch string    Git branch to sync from (default: from config or 'main')
      --channel string   Release channel: stable or dev
      --dry-run          show what would be downloaded
      --force            overwrite existing files without checking
  -h, --help             help for sync
      --retry int        number of retry attempts (default 3)
      --source string    GitHub repository URL
      --tag string       Exact git tag to sync from (e.g., v0.1.0)
      --timeout int      timeout in seconds (default 30)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest system update

System: Update fest methodology files from templates

### Synopsis

Update the .festival/ methodology files from latest templates.

This is a SYSTEM command that updates fest's methodology files (templates,
documentation, agents) in your workspace - NOT your festival content.

It compares your .festival/ files with the latest templates and updates
only the files you haven't modified. For modified files, it will prompt you
for action unless --no-interactive is specified.

Your actual festivals (phases, sequences, tasks) are never modified by this command.

```
fest system update [path] [flags]
```

### Examples

```
  fest system update                  # Interactive update
  fest system update --dry-run        # Preview changes
  fest system update --no-interactive # Skip all modified files
  fest system update --backup         # Create backups before updating
```

### Options

```
      --backup           create backups before updating
      --diff             show diffs for modified files
      --dry-run          show what would be updated without making changes
      --force            update all files regardless of modifications
  -h, --help             help for update
      --interactive      prompt for each modified file (default true)
      --no-interactive   update only unchanged files, skip modified
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task

Manage task status (show, edit, complete, block, reset)

### Synopsis

Commands for managing individual task status within a festival.

These commands provide a simpler interface for viewing, editing, marking
tasks complete, blocked, or resetting them. Each mutation requires
interactive confirmation to ensure agents verify their work before proceeding.

Task Resolution:
  When [task] is omitted, the command auto-detects the current task:
    1. Finds the current in_progress task from the progress store
    2. Falls back to the next pending task (same logic as 'fest next')
    3. Errors if neither is found

  When [task] is provided, it resolves via:
    - Full relative path: 002_FOUNDATION/01_scaffold/01_design.md
    - Bare filename: 01_design.md (searches for unique match)

Examples:
```bash
  fest task show                          # Show current task details
  fest task show 01_design.md             # Show specific task
  fest task edit                          # Open current task in editor
  fest task completed                     # Mark current task complete (Y/n)
  fest task blocked --reason "need API"   # Mark task blocked (Y/n)
  fest task reset                         # Reset task to pending (Y/n)
```

### Options

```
  -h, --help   help for task
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task blocked

Mark a task as blocked (requires confirmation)

```
fest task blocked [task] [flags]
```

### Options

```
  -h, --help            help for blocked
      --json            output as JSON (blocks: interactive confirmation required)
      --reason string   reason for the blocker (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task completed

Mark a task as complete (requires confirmation)

```
fest task completed [task] [flags]
```

### Options

```
  -h, --help   help for completed
      --json   output as JSON (blocks: interactive confirmation required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task edit

Open the current task in your editor

```
fest task edit [task] [flags]
```

### Options

```
  -h, --help   help for edit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task reset

Reset a task to pending (requires confirmation)

```
fest task reset [task] [flags]
```

### Options

```
  -h, --help   help for reset
      --json   output as JSON (blocks: interactive confirmation required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest task show

Show task details and status

```
fest task show [task] [flags]
```

### Options

```
  -h, --help         help for show
      --json         output as JSON
      --no-context   hide task markdown content
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest templates

Manage agent-created templates within a festival

### Synopsis

Create, apply, and manage templates for repetitive tasks.

Agent templates use simple {{variable}} syntax for substitution.
Templates are stored in .templates/ within the festival directory.

Examples:
```bash
  fest templates create component_test
  fest templates apply component_test --vars '{"name": "UserService"}'
  fest templates list
```

### Options

```
  -h, --help   help for templates
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest templates apply

Apply a template with variables

### Synopsis

Apply a template, substituting {{variables}} with provided values.

Variables can be provided as:
  - JSON string: --vars '{"name": "value"}'
  - File reference: --vars @variables.json

Examples:
```bash
  fest templates apply component_test --vars '{"name": "UserService"}'
  fest templates apply api_endpoint -o ./api.md --vars @vars.json
```

```
fest templates apply <name> [flags]
```

### Options

```
  -h, --help            help for apply
  -o, --output string   output file path (default: stdout)
      --preview         show result without writing
      --vars string     JSON object or @file with variable values (default "{}")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest templates create

Create a new template

### Synopsis

Create a new agent template in the current festival.

The template will be stored in .templates/<name>.md

Example template content:
```bash
  # {{component_name}} Test

  ## Setup
  {{setup_steps}}

  ## Test Cases
  - {{test_case_1}}
  - {{test_case_2}}
```

```
fest templates create <name> [flags]
```

### Options

```
      --from-file string   create from existing file
  -h, --help               help for create
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest templates list

List available templates

### Synopsis

List all agent templates available in the current festival.

Templates are stored in .templates/ within the festival directory.

```
fest templates list [flags]
```

### Options

```
  -h, --help   help for list
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest tui

Interactive UI (Charm) for festival creation and editing

```
fest tui [flags]
```

### Options

```
  -h, --help   help for tui
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types

Discover and explore template types

### Synopsis

Explore available template types at each festival level.

Template types define the structure and purpose of festivals, phases,
sequences, and tasks. Custom types can be added in .festival/templates/.

Examples:
```bash
  fest types list                        # List all available types
  fest types list --level task           # List task-level types only
  fest types show feature                # Show details about a type
  fest types show implementation --level phase
```

### Options

```
  -h, --help   help for types
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types festival

Discover festival types

### Synopsis

Discover available festival types and their phase structures.

Festival types define the workflow structure for different kinds of projects:
  - standard: Full planning and implementation phases
  - implementation: Direct implementation without planning
  - research: Research-focused workflow
  - quick: Fast, minimal overhead workflow
  - ritual: Simple repeating patterns

Examples:
```bash
  fest types festival                    # List all festival types
  fest types festival list               # Same as above
  fest types festival standard           # Show details for standard type
  fest types festival show implementation # Show details for implementation type
  fest types festival --phases standard  # Show only phases for standard type
  fest types festival --json             # Machine-readable JSON output
```

```
fest types festival [type-name] [flags]
```

### Options

```
  -h, --help     help for festival
      --json     Output as JSON
      --phases   Show only phases for the specified type
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types festival list

List all festival types

### Synopsis

List all available festival types with their descriptions.

Shows all festival types defined in the configuration, marking the default type.

Examples:
```bash
  fest types festival list        # List all festival types
  fest types festival list --json # JSON output
```

```
fest types festival list [flags]
```

### Options

```
  -h, --help   help for list
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types festival show

Show details for a festival type

### Synopsis

Display detailed information about a specific festival type.

Shows the type's description, phase structure, auto-scaffolded phases,
and manually-created phases.

Examples:
```bash
  fest types festival show standard           # Show standard type details
  fest types festival show implementation     # Show implementation type
  fest types festival show standard --phases  # Show only phases
  fest types festival show quick --json       # JSON output
```

```
fest types festival show <type-name> [flags]
```

### Options

```
  -h, --help     help for show
      --json     Output as JSON
      --phases   Show only phases
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types list

List available template types

### Synopsis

List all template types available at each festival level.

Types are discovered from:
  - Built-in templates (~/.config/fest/templates/)
  - Custom templates (.festival/templates/ in a festival)

Examples:
```bash
  fest types list                  # List all types grouped by level
  fest types list --level task     # List task-level types only
  fest types list --custom         # Show only custom types
  fest types list --all            # Include marker counts
  fest types list --json           # Machine-readable output
```

```
fest types list [flags]
```

### Options

```
  -a, --all            Show additional details including marker counts
  -c, --custom         Show only custom (user-defined) types
  -h, --help           help for list
      --json           Output as JSON
  -l, --level string   Filter by level (festival, phase, sequence, task)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest types show

Show details about a template type

### Synopsis

Display detailed information about a specific template type.

Shows the type's level, description, number of markers, template files,
and example usage.

Examples:
```bash
  fest types show feature                   # Show feature type details
  fest types show implementation --level phase  # Show phase-level implementation
  fest types show simple --level task --json    # JSON output
```

```
fest types show <type-name> [flags]
```

### Options

```
  -h, --help           help for show
      --json           Output as JSON
  -l, --level string   Filter by level (disambiguate if same name at multiple levels)
  -t, --template       Show raw template content
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand

Learn methodology FIRST - run before executing festival tasks

### Synopsis

Learn about Festival Methodology - a goal-oriented project management
system designed for AI agent development workflows.

START HERE if you're new to Festival Methodology:
```bash
  fest understand methodology    Core principles and philosophy
  fest understand structure      3-level hierarchy explained
  fest understand tasks          CRITICAL: When to create task files
```

QUICK REFERENCE:
```bash
  fest understand checklist      Validation checklist before starting
  fest understand rules          Naming conventions for automation
  fest understand workflow       Just-in-time reading pattern
```

The understand command helps you grasp WHEN and WHY to use specific
approaches. For command syntax, use --help on any command.

Content is pulled from your local .festival/ directory when available,
ensuring you see the current methodology design and any customizations.

```
fest understand [flags]
```

### Options

```
  -h, --help   help for understand
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand checklist

Quick festival validation checklist

### Synopsis

Show a quick checklist for validating your festival structure.

This is a quick reference. For full validation, run 'fest validate checklist'.

Checklist:
  1. FESTIVAL_OVERVIEW.md exists and is filled out
  2. Each phase has PHASE_GOAL.md
  3. Each sequence has SEQUENCE_GOAL.md
  4. Implementation sequences have TASK FILES (not just goals!)
  5. Quality gates present in implementation sequences
  6. No unfilled template markers ([FILL:], {{ }})

```
fest understand checklist [flags]
```

### Options

```
  -h, --help   help for checklist
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand context

CONTEXT.md - session memory for AI agents (CREATE FIRST)

### Synopsis

Learn about CONTEXT.md - the "memory" document that preserves decisions,
blockers, and handoff notes between AI sessions.

CREATE CONTEXT.md FIRST when planning a new festival. It captures WHY
the festival exists and prevents agents from losing focus on purpose.

```
fest understand context [flags]
```

### Options

```
  -h, --help   help for context
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand extensions

Show loaded extensions

### Synopsis

Show all methodology extensions loaded from various sources.

Extensions are workflow pattern packs containing templates, agents, and rules.
They are loaded from three sources with the following precedence:

  1. Project-local: .festival/extensions/ (highest priority)
  2. User config: ~/.config/fest/active/festivals/.festival/extensions/
  3. Built-in: ~/.config/fest/festivals/.festival/extensions/ (lowest priority)

Higher priority sources override lower ones when extensions have the same name.

```
fest understand extensions [flags]
```

### Options

```
  -h, --help   help for extensions
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand gates

Show quality gate configuration

### Synopsis

Show the quality gate policy that will be applied to sequences.

Quality gates are tasks automatically appended to implementation sequences.
The default gates are: testing_and_verify, code_review, review_results_iterate, commit.

Gates can be customized at multiple levels:
  1. Built-in defaults (always available)
  2. User config repo (~/.config/fest/active/user/policies/gates/)
  3. Project-local (.festival/policies/gates/)
  4. Phase override (.fest.gates.yml in phase directory)

```
fest understand gates [flags]
```

### Options

```
  -h, --help   help for gates
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand methodology

Core principles - START HERE for new agents

### Synopsis

Learn the core principles of Festival Methodology.

This is the STARTING POINT for agents new to Festival Methodology.
Covers goal-oriented development, requirements-driven implementation,
and quality gates.

After reading this, proceed to:
```bash
  fest understand structure   - Learn the 3-level hierarchy
  fest understand tasks       - Learn when to create task files
```

```
fest understand methodology [flags]
```

### Options

```
  -h, --help   help for methodology
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand nodeids

Node reference system for code traceability

### Synopsis

Learn about the node reference system for tracing code changes back to
specific festival tasks.

Node references like GU0001:P002.S01.T03 create a clear audit trail
connecting code comments to planning documents.

```
fest understand nodeids [flags]
```

### Options

```
  -h, --help   help for nodeids
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand plugins

Show discovered plugins

### Synopsis

Show all plugins discovered from various sources.

Plugins extend fest with additional commands. They are discovered from:
  1. User config repo manifest (~/.config/fest/active/user/plugins/manifest.yml)
  2. User config repo bin directory (~/.config/fest/active/user/plugins/bin/)
  3. System PATH (executables named fest-*)

Plugin executables follow the naming convention:
  fest-<group>-<name>  →  "fest <group> <name>"
  fest-export-jira     →  "fest export jira"

```
fest understand plugins [flags]
```

### Options

```
  -h, --help   help for plugins
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand resources

What's in the .festival/ directory

### Synopsis

List the templates, agents, and examples available in your .festival/ directory.

```
fest understand resources [flags]
```

### Options

```
  -h, --help   help for resources
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand rules

MANDATORY structure rules for automation

### Synopsis

Learn the RIGID structure requirements that enable Festival automation: naming conventions, required files, quality gates, and parallel execution.

```
fest understand rules [flags]
```

### Options

```
  -h, --help   help for rules
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand structure

3-level hierarchy: Festival → Phase → Sequence → Task

### Synopsis

Understand the Festival Methodology structure.

HIERARCHY:
  Festival    - A complete project with a goal
  └─ Phase    - Major milestone (001_PLANNING, 002_IMPLEMENTATION)
     └─ Sequence - Related tasks grouped together
        └─ Task   - Individual executable work item

Includes visual scaffold examples for simple, standard, and complex festivals.

```
fest understand structure [flags]
```

### Options

```
  -h, --help   help for structure
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand tasks

When and how to create task files (CRITICAL)

### Synopsis

Learn when to create task files vs. goal documents.

THIS IS THE MOST COMMON MISTAKE: Creating sequences with only
SEQUENCE_GOAL.md but no task files.

  Goals define WHAT to achieve.
  Tasks define HOW to execute.

AI agents EXECUTE TASK FILES. Without them, agents know the
objective but don't know what specific work to perform.

```
fest understand tasks [flags]
```

### Options

```
  -h, --help   help for tasks
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand templates

Template variables that save tokens

### Synopsis

Learn how to pass variables to fest create commands to generate pre-filled documents, minimizing post-creation editing and saving tokens.

```
fest understand templates [flags]
```

### Options

```
  -h, --help   help for templates
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest understand workflow

Just-in-time reading and execution patterns

### Synopsis

Learn the just-in-time approach to reading templates and documentation, preserving context for actual work.

```
fest understand workflow [flags]
```

### Options

```
  -h, --help   help for workflow
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest unlink

Remove festival-project link (context-aware)

### Synopsis

Remove the project link for the current location.

Context-aware behavior:
  - Inside a festival: unlinks that festival from its project
  - Inside a linked project: unlinks the project from its festival

This removes the association between the festival and its project directory.

```
fest unlink [flags]
```

### Examples

```
  fest unlink   # Remove link for current festival or project
```

### Options

```
  -h, --help   help for unlink
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate

Check festival structure - find missing task files and issues

### Synopsis

Validate that a festival follows the methodology correctly.

Unlike 'fest index validate' which checks index-to-filesystem sync,
this command validates METHODOLOGY COMPLIANCE:

  • Required files exist (FESTIVAL_OVERVIEW.md, goal files)
  • Implementation sequences have TASK FILES (not just goals)
  • Quality gates are present in implementation sequences
  • Naming conventions are followed
  • Templates have been filled out (no [FILL:] markers)

AI agents execute TASK FILES, not goals. If your sequences only have
SEQUENCE_GOAL.md without task files, agents won't know HOW to execute.

Use --fix to automatically apply safe fixes (like adding quality gates).

```
fest validate [festival-path] [flags]
```

### Options

```
      --fix    Automatically apply safe fixes
  -h, --help   help for validate
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate checklist

Post-completion questionnaire

### Synopsis

Run through post-completion checklist to ensure methodology compliance.

Checks (auto-verified where possible):
  1. Did you fill out ALL templates? (auto-check for markers)
  2. Does this plan achieve project goals? (manual review)
  3. Are items in order of operation? (auto-check)
  4. Did you follow parallelization standards? (auto-check)
  5. Did you create TASK FILES for implementation? (auto-check)

```
fest validate checklist [festival-path] [flags]
```

### Options

```
  -h, --help   help for checklist
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate completeness

Validate required files exist

### Synopsis

Validate that all required files exist:

  • FESTIVAL_OVERVIEW.md (required)
  • PHASE_GOAL.md in each phase (required)
  • SEQUENCE_GOAL.md in each sequence (required)
  • FESTIVAL_RULES.md (recommended)

```
fest validate completeness [festival-path] [flags]
```

### Options

```
  -h, --help   help for completeness
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate ordering

Validate sequential numbering (gap detection)

### Synopsis

Validate that festival elements are sequentially numbered without gaps.

This checks:
  • Phases are sequential: 001, 002, 003... (no gaps, must start at 001)
  • Sequences within each phase: 01, 02, 03... (no gaps, must start at 01)
  • Tasks within each sequence: 01, 02, 03... (no gaps, must start at 01)

Parallel work (same number) is allowed if items are CONSECUTIVE:
  VALID:   01_task_a.md, 01_task_b.md, 02_task_c.md
  INVALID: 01_task_a.md, 02_task_b.md, 01_task_c.md

Gaps break agent execution order - agents rely on sequential numbering
to determine which phase/sequence/task to work on next.

```
fest validate ordering [festival-path] [flags]
```

### Options

```
  -h, --help   help for ordering
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate quality-gates

Validate quality gates exist

### Synopsis

Validate that implementation sequences have quality gate tasks.

Only implementation phases are checked. Other phase types are skipped.

Required implementation gates:
  • testing
  • review
  • iterate
  • commit

Use --fix to automatically add missing quality gates.
Sequences matching excluded patterns (*_planning, *_research, etc.) are skipped.

```
fest validate quality-gates [festival-path] [flags]
```

### Options

```
      --fix    Automatically add missing quality gates
  -h, --help   help for quality-gates
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate structure

Validate naming conventions and hierarchy

### Synopsis

Validate that festival structure follows naming conventions:

  • Phases: NNN_PHASE_NAME (3-digit prefix, UPPERCASE)
  • Sequences: NN_sequence_name (2-digit prefix, lowercase)
  • Tasks: NN_task_name.md (2-digit prefix, lowercase, .md extension)

```
fest validate structure [festival-path] [flags]
```

### Options

```
  -h, --help   help for structure
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest validate tasks

Validate task files exist (CRITICAL)

### Synopsis

Validate that implementation sequences have TASK FILES.

THIS IS THE MOST COMMON MISTAKE: Creating sequences with only
SEQUENCE_GOAL.md but no task files.

  Goals define WHAT to achieve.
  Tasks define HOW to execute.

AI agents EXECUTE TASK FILES. Without them, agents know the objective
but don't know what specific work to perform.

CORRECT STRUCTURE:
  02_api/
  ├── SEQUENCE_GOAL.md          ← Defines objective
  ├── 01_design_endpoints.md    ← Task: design work
  ├── 02_implement_crud.md      ← Task: implementation
  └── 03_testing_and_verify.md  ← Quality gate

INCORRECT STRUCTURE (common mistake):
  02_api/
  └── SEQUENCE_GOAL.md          ← No task files!

```
fest validate tasks [festival-path] [flags]
```

### Options

```
  -h, --help   help for tasks
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest version

Show version information

### Synopsis

Show fest version, build information, and runtime details.

Examples:
```bash
  fest version           Show full version info
  fest version --short   Show only version number
  fest version --json    Output as JSON
```

```
fest version [flags]
```

### Options

```
  -h, --help    help for version
      --json    output as JSON
  -s, --short   show only version number
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest wizard

Interactive guidance and assistance for festival creation

### Synopsis

The wizard command provides interactive guidance for festival creation.

SUBCOMMANDS:
  fill <file>    Interactively fill REPLACE markers in a file

EXAMPLES:
```bash
  # Fill markers in a specific file
  fest wizard fill PHASE_GOAL.md

  # Fill markers in all files in current directory
  fest wizard fill .

  # Preview changes without writing
  fest wizard fill FESTIVAL_GOAL.md --dry-run
```

The wizard subcommands help automate tedious tasks and guide users
through the festival creation process step by step.

### Options

```
  -h, --help   help for wizard
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest wizard fill

Interactively fill REPLACE markers in festival files

### Synopsis

Interactively fill [REPLACE: hint] markers in festival files.

This command scans for REPLACE markers in the specified file (or all .md files
in the directory) and provides multiple modes for filling them.

MODES:
  Interactive (TTY):  Opens files in configured editor for manual filling
  Batch Discovery:    Lists all markers as JSON (--list-markers)
  Batch Processing:   Applies JSON replacements in single pass (--batch-input)
  Sequential:         Text prompts for each marker (non-TTY stdin)

MARKER SYNTAX:
  [REPLACE: hint text]           Regular text input
  [REPLACE: Yes|No]              Select from options (pipe-separated)
  [REPLACE: Option A|Option B]   Multiple choice selection

EDITOR MODES (Interactive):
  buffer   Files loaded as buffers, navigate with :bn/:bp (default)
  tab      Each file in separate tab, navigate with gt/gT
  split    Vertical splits (previous default)
  hsplit   Horizontal splits

BATCH WORKFLOW (for agents):
  1. Discovery:  fest wizard fill --list-markers . > markers.json
  2. Edit markers.json to add "value" fields for each marker
  3. Apply:      fest wizard fill --batch-input markers.json

EXAMPLES:
```bash
  # Interactive with buffer mode (default)
  fest wizard fill .

  # Interactive with tabs
  fest wizard fill --editor-mode tab .

  # Custom editor flags
  fest wizard fill --editor-flags="-p" .

  # Batch workflow
  fest wizard fill --list-markers . > markers.json
  # ... edit markers.json to add values ...
  fest wizard fill --batch-input markers.json

  # Preview without writing changes
  fest wizard fill PHASE_GOAL.md --dry-run

  # Output results as JSON
  fest wizard fill PHASE_GOAL.md --json
```

The fill wizard transforms tedious manual editing into a guided experience,
ensuring all template markers are properly completed.

```
fest wizard fill [file-or-directory] [flags]
```

### Options

```
      --batch-input string     Batch JSON input file ('-' for stdin)
      --dry-run                Preview changes without writing
      --editor-flags strings   Custom editor flags (overrides mode)
      --editor-mode string     Editor window mode: buffer, tab, split, hsplit
  -h, --help                   help for fill
      --json                   Output results as JSON
      --list-markers           Output all markers as JSON for batch processing
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest workflow

Manage workflow-based phase execution

### Synopsis

Commands for managing step-based phase navigation (workflows and phase gates).

These commands work with WORKFLOW.md files (step-by-step guidance for workflow phases)
and GATES.md files (phase-level quality gates for all phase types). Use 'fest next'
to see the current step, then these commands to advance.

Workflow Steps:
  Workflows are defined in WORKFLOW.md files within phase directories.
  Each step has a goal, actions to complete, expected output, and an optional checkpoint.

Phase Gates:
  Gates are defined in GATES.md files and run after all other phase work is complete.
  Each gate step poses a quality/compliance question requiring approval before the
  phase can advance. Gates are available for all phase types.

Checkpoints:
  Some steps require user approval before proceeding. Use 'fest workflow approve'
  to approve or 'fest workflow reject' to request revisions.

State:
  Progress is tracked in <festival>/.fest/progress_events.jsonl.
  Use 'fest workflow status' to view current progress.

Running from Festival Root:
  When run from the festival root (not inside a phase directory), the command
  auto-detects the first incomplete navigable phase (workflow or gate).
  Use --phase to specify a particular phase.

Auto-Routing:
  Commands automatically target the correct document:
  - WORKFLOW.md if incomplete (takes priority)
  - GATES.md if workflow is complete/absent and phase work is done

Examples:
```bash
  fest workflow status              # Show workflow or gate progress
  fest workflow status --phase 001_INGEST  # Show specific phase
  fest workflow advance             # Complete current step and move to next
  fest workflow skip --reason "already completed externally" # Operator override
  fest workflow approve             # Approve a blocking checkpoint
  fest workflow reject              # Reject checkpoint with feedback
  fest workflow reset               # Reset workflow or gate to step 1
  fest workflow show                # Display the current step details
```

### Options

```
  -h, --help           help for workflow
      --phase string   specify phase directory (e.g., 001_INGEST)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```
---

## fest workflow advance

Complete current step and move to next

### Synopsis

Mark the current workflow step as complete and advance to the next step.

This command:
  1. Marks the current step as completed
  2. Advances the workflow to the next step
  3. Saves the updated state

Note: If the current step has a blocking checkpoint, use 'fest workflow approve' instead.

```
fest workflow advance [flags]
```

### Options

```
  -h, --help   help for advance
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow approve

Approve a blocking checkpoint

### Synopsis

Approve a blocking checkpoint and proceed to the next step.

Some workflow steps require explicit user approval before proceeding.
This is typically used for review gates or major decision points.

After approval:
  - The current step is marked as approved
  - The workflow advances to the next step

```
fest workflow approve [flags]
```

### Options

```
  -h, --help   help for approve
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow reject

Reject checkpoint with feedback

### Synopsis

Reject a blocking checkpoint and provide feedback.

When a step's work doesn't meet requirements, use this command
to reject and request revisions.

The feedback will be recorded in the workflow state for reference.

```
fest workflow reject [flags]
```

### Options

```
  -h, --help            help for reject
  -r, --reason string   reason for rejection (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow reset

Reset workflow to step 1

### Synopsis

Reset the workflow state back to step 1.

This clears all step progress and starts the workflow from the beginning.
Use with caution as this cannot be undone.

```
fest workflow reset [flags]
```

### Options

```
      --force   Skip confirmation prompt
  -h, --help    help for reset
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow show

Display current step details

### Synopsis

Display detailed information about the current workflow step.

If a step number is provided, shows that specific step.
Otherwise, shows the current step.

Shows:
  - Step number and name
  - Goal/objective
  - Actions to complete
  - Expected output
  - Checkpoint type if applicable

```
fest workflow show [step] [flags]
```

### Options

```
  -h, --help   help for show
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow skip

Operator override: mark workflow steps as skipped/completed

### Synopsis

Mark remaining steps in a workflow phase with an explicit terminal state.

Use this when work was already completed outside the normal fest next loop and
you need a documented operator override with an audit reason.
Example: backfilling earlier phases for ai-investor-outreach-system-AI0001.

Security:
  - Human operator only (excluded from agent manifest access)
  - Requires an interactive TTY
  - Requires --reason for auditability

```
fest workflow skip [flags]
```

### Options

```
      --as string       terminal state to apply: skipped or completed (default "skipped")
  -h, --help            help for skip
  -r, --reason string   human-readable reason for operator override (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
---

## fest workflow status

Show workflow progress

### Synopsis

Display the current progress of the workflow in this phase.

Shows:
  - Current step number and name
  - Completed steps
  - Remaining steps
  - Checkpoint status if applicable

```
fest workflow status [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```
