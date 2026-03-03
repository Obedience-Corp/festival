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

### SEE ALSO

* [fest apply](fest_apply.md)	 - Apply a local template to a destination file (copy or render)
* [fest chain](fest_chain.md)	 - Manage festival chains (inter-festival dependencies)
* [fest commit](fest_commit.md)	 - Create git commit with task reference
* [fest commits](fest_commits.md)	 - Query commits by festival element
* [fest completion](fest_completion.md)	 - Generate shell completion scripts
* [fest config](fest_config.md)	 - Manage fest configuration repositories
* [fest context](fest_context.md)	 - Get context for the current location or task
* [fest create](fest_create.md)	 - Create festivals, phases, sequences, or tasks (TUI)
* [fest deps](fest_deps.md)	 - Show task dependencies
* [fest explore](fest_explore.md)	 - Interactive festival explorer with hierarchy drilldown
* [fest feedback](fest_feedback.md)	 - Manage structured feedback collection
* [fest gates](fest_gates.md)	 - Manage quality gates - validation steps at sequence end
* [fest go](fest_go.md)	 - Navigate to festivals/ - use 'fgo' after shell-init setup
* [fest id](fest_id.md)	 - Show the festival ID for the current context
* [fest index](fest_index.md)	 - Manage festival indices
* [fest init](fest_init.md)	 - Initialize a new festival directory structure
* [fest insert](fest_insert.md)	 - Insert new festival elements
* [fest intro](fest_intro.md)	 - Getting started guide for fest CLI and common workflows
* [fest link](fest_link.md)	 - Link festival to project directory (context-aware)
* [fest links](fest_links.md)	 - List all festival-project links
* [fest list](fest_list.md)	 - List festivals by status
* [fest markers](fest_markers.md)	 - Manage template markers in festival files
* [fest migrate](fest_migrate.md)	 - Migrate festival documents
* [fest move](fest_move.md)	 - Move files between festival and linked project
* [fest next](fest_next.md)	 - Find the next task to work on
* [fest parse](fest_parse.md)	 - Parse festival documents into structured output
* [fest progress](fest_progress.md)	 - Track and display festival execution progress
* [fest promote](fest_promote.md)	 - Promote a festival to the next lifecycle status
* [fest remove](fest_remove.md)	 - Remove festival elements and renumber
* [fest renumber](fest_renumber.md)	 - Renumber festival elements
* [fest reorder](fest_reorder.md)	 - Reorder festival elements
* [fest research](fest_research.md)	 - Manage research phase documents
* [fest ritual](fest_ritual.md)	 - Manage repeatable ritual festivals
* [fest rules](fest_rules.md)	 - Display festival rules for the current festival
* [fest scaffold](fest_scaffold.md)	 - Generate festival structures from plans
* [fest search](fest_search.md)	 - Search festivals by name, ID, or goal text
* [fest shell-init](fest_shell-init.md)	 - Output shell integration code for festival helpers
* [fest show](fest_show.md)	 - Display festival information
* [fest status](fest_status.md)	 - Manage and query festival entity statuses
* [fest system](fest_system.md)	 - Manage fest tool configuration and templates
* [fest task](fest_task.md)	 - Manage task status (show, edit, complete, block, reset)
* [fest templates](fest_templates.md)	 - Manage agent-created templates within a festival
* [fest tui](fest_tui.md)	 - Interactive UI (Charm) for festival creation and editing
* [fest types](fest_types.md)	 - Discover and explore template types
* [fest understand](fest_understand.md)	 - Learn methodology FIRST - run before executing festival tasks
* [fest unlink](fest_unlink.md)	 - Remove festival-project link (context-aware)
* [fest validate](fest_validate.md)	 - Check festival structure - find missing task files and issues
* [fest version](fest_version.md)	 - Show version information
* [fest wizard](fest_wizard.md)	 - Interactive guidance and assistance for festival creation
* [fest workflow](fest_workflow.md)	 - Manage workflow-based phase execution

