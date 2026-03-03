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

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

