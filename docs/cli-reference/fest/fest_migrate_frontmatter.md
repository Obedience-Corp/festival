---
title: "fest migrate frontmatter"
linkTitle: "fest migrate frontmatter"
description: "Add YAML frontmatter to existing documents"
---

## fest migrate frontmatter

Add YAML frontmatter to existing documents

### Synopsis

Add YAML frontmatter to festival documents that don't have it.

This command walks through all festival documents and adds frontmatter
to any that are missing it. Existing frontmatter is preserved.

Examples:
```bash
  fest migrate frontmatter              # Add frontmatter to all docs
  fest migrate frontmatter --dry-run    # Preview changes without writing
  fest migrate frontmatter --fix        # Update/fix existing frontmatter
  fest migrate frontmatter --verbose    # Show detailed progress
```

```
fest migrate frontmatter [flags]
```

### Options

```
      --dry-run   preview changes without writing
      --fix       update/fix existing frontmatter
  -h, --help      help for frontmatter
      --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest migrate](../fest_migrate/)	 - Migrate festival documents
