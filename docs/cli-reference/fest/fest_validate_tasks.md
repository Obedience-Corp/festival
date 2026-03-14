---
title: "fest validate tasks"
linkTitle: "fest validate tasks"
description: "Validate task files exist (CRITICAL)"
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

### SEE ALSO

* [fest validate](../fest_validate/)	 - Check festival structure - find missing task files and issues
