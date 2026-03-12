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

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest validate checklist](fest_validate_checklist.md)	 - Post-completion questionnaire
* [fest validate completeness](fest_validate_completeness.md)	 - Validate required files exist
* [fest validate ordering](fest_validate_ordering.md)	 - Validate sequential numbering (gap detection)
* [fest validate quality-gates](fest_validate_quality-gates.md)	 - Validate quality gates exist
* [fest validate structure](fest_validate_structure.md)	 - Validate naming conventions and hierarchy
* [fest validate tasks](fest_validate_tasks.md)	 - Validate task files exist (CRITICAL)

