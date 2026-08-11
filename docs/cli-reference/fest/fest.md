---
title: "fest"
linkTitle: "fest"
description: "Festival Methodology CLI - goal-oriented project management for AI agents"
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
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
  -h, --help            help for fest
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest apply](../fest_apply/)	 - Apply a local template to a destination file (copy or render)
* [fest chain](../fest_chain/)	 - Manage festival chains (inter-festival dependencies)
* [fest commit](../fest_commit/)	 - Create git commit with task reference
* [fest completion](../fest_completion/)	 - Generate shell completion scripts
* [fest config](../fest_config/)	 - Manage fest configuration repositories
* [fest context](../fest_context/)	 - Get context for the current location or task
* [fest create](../fest_create/)	 - Create festivals, phases, sequences, or tasks (TUI)
* [fest deps](../fest_deps/)	 - Show task dependencies
* [fest feedback](../fest_feedback/)	 - Manage structured feedback collection
* [fest gates](../fest_gates/)	 - Manage quality gates - validation steps at sequence end
* [fest go](../fest_go/)	 - Navigate to festivals/ - use 'fgo' after shell-init setup
* [fest hooks](../fest_hooks/)	 - Inspect resolved lifecycle hooks
* [fest id](../fest_id/)	 - Show the festival ID for the current context
* [fest index](../fest_index/)	 - Manage festival indices
* [fest init](../fest_init/)	 - Initialize a new festival directory structure
* [fest insert](../fest_insert/)	 - Insert new festival elements
* [fest intro](../fest_intro/)	 - Getting started guide for fest CLI and common workflows
* [fest link](../fest_link/)	 - Link festival to project directory (context-aware)
* [fest links](../fest_links/)	 - List all festival-project links
* [fest list](../fest_list/)	 - List festivals by status
* [fest markers](../fest_markers/)	 - Manage template markers in festival files
* [fest migrate](../fest_migrate/)	 - Migrate festival documents
* [fest move](../fest_move/)	 - Move files between festival and linked project
* [fest next](../fest_next/)	 - Find the next task to work on
* [fest pack](../fest_pack/)	 - Pack a festival or ritual directory into a .festival bundle
* [fest parse](../fest_parse/)	 - Parse festival documents into structured output
* [fest plugins](../fest_plugins/)	 - List discovered fest plugins
* [fest progress](../fest_progress/)	 - Track and display festival execution progress
* [fest promote](../fest_promote/)	 - Promote a festival to the next lifecycle status
* [fest remove](../fest_remove/)	 - Remove festival elements and renumber
* [fest renumber](../fest_renumber/)	 - Renumber festival elements
* [fest reorder](../fest_reorder/)	 - Reorder festival elements
* [fest research](../fest_research/)	 - Manage research phase documents
* [fest ritual](../fest_ritual/)	 - Manage repeatable ritual festivals
* [fest rules](../fest_rules/)	 - Display festival rules for the current festival
* [fest scaffold](../fest_scaffold/)	 - Generate festival structures from plans
* [fest search](../fest_search/)	 - Search festivals by name, ID, or goal text
* [fest shell-init](../fest_shell-init/)	 - Output shell integration code for festival helpers
* [fest show](../fest_show/)	 - Display festival information
* [fest status](../fest_status/)	 - Manage and query festival entity statuses
* [fest system](../fest_system/)	 - Manage fest tool configuration and templates
* [fest task](../fest_task/)	 - Manage task status (show, edit, complete, block, reset)
* [fest templates](../fest_templates/)	 - Manage agent-created templates within a festival
* [fest tokens](../fest_tokens/)	 - Count planning-corpus tokens for a festival or the whole workspace
* [fest types](../fest_types/)	 - Discover types for fest create
* [fest unbundle](../fest_unbundle/)	 - Unbundle a .festival archive into a directory
* [fest understand](../fest_understand/)	 - Learn methodology FIRST - run before executing festival tasks
* [fest unlink](../fest_unlink/)	 - Remove festival-project link (context-aware)
* [fest validate](../fest_validate/)	 - Check festival structure - find missing task files and issues
* [fest version](../fest_version/)	 - Show version information
* [fest walk](../fest_walk/)	 - Guided overview of a festival or workflow
* [fest watch](../fest_watch/)	 - Watch a festival's in-progress work
* [fest wizard](../fest_wizard/)	 - Interactive guidance and assistance for festival creation
* [fest workflow](../fest_workflow/)	 - Manage workflow-based phase execution
