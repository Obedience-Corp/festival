---
title: "camp doctor"
linkTitle: "camp doctor"
description: "Diagnose and fix camp health issues"
---

## camp doctor

Diagnose and fix camp health issues

### Synopsis

Check camp for common issues and optionally fix them.

CHECKS PERFORMED:
  orphan      Orphaned gitlinks in index (no .gitmodules entry)
  url         URL consistency between .gitmodules and .git/config
  integrity   Submodule integrity (empty/broken directories)
  head        HEAD states (detached with local work)
  working     Working directory cleanliness
  commits     Parent-submodule commit alignment
  lock        Stale git index.lock files
  jobs        Failed, stuck, or lost deferred commits

EXIT CODES:
  0  All checks passed (no warnings or errors)
  1  Warnings or errors found
  2  Usage error (bad flags or args)
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
  -c, --check strings     Run specific check(s) only (orphan, url, integrity, head, working, commits, lock, artifacts, jobs, bigfiles)
  -f, --fix               Attempt automatic fixes for detected issues
  -h, --help              help for doctor
      --json              Output results as JSON
      --no-drain          Do not wait for camp's queued commits first
      --submodules-only   Only check submodule health
  -v, --verbose           Show detailed information for each check
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
