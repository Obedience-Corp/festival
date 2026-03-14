---
title: "fest understand gates"
linkTitle: "fest understand gates"
description: "Show quality gate configuration"
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

### SEE ALSO

* [fest understand](../fest_understand/)	 - Learn methodology FIRST - run before executing festival tasks
