---
title: "fest understand checklist"
linkTitle: "fest understand checklist"
description: "Quick festival validation checklist"
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

### SEE ALSO

* [fest understand](../fest_understand/)	 - Learn methodology FIRST - run before executing festival tasks
