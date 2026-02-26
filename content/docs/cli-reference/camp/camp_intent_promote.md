## camp intent promote

Promote an intent to a Festival

### Synopsis

Promote a ready intent to a Festival.

The intent should be in 'ready' status before promotion. Use --force to
promote from any status.

After promotion, the intent will be moved to 'done' status with a reference
to the created Festival.

Examples:
  camp intent promote add-dark           Promote by partial ID
  camp intent promote add-dark --force   Force promote from any status
  camp intent promote add-dark --dry-run Preview without changes

```
camp intent promote <id> [flags]
```

### Options

```
      --dry-run     Preview promotion without making changes
      --force       Promote even if not in ready status
  -h, --help        help for promote
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

