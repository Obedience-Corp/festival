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

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

