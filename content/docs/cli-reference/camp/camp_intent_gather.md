## camp intent gather

Gather related intents into a unified document

### Synopsis

Gather multiple related intents into a single unified document.

DISCOVERY MODES:
  By IDs      Explicitly specify intent IDs to gather
  --tag       Find intents with a specific frontmatter tag
  --hashtag   Find intents containing a specific #hashtag
  --similar   Find intents similar to a given ID (TF-IDF)

The gather process:
  1. Find related intents using the specified discovery method
  2. Merge their content with full metadata preservation
  3. Create a new unified intent in inbox status
  4. Archive source intents (unless --no-archive)

Source intents are preserved with a 'gathered_into' reference.

Examples:
  # Gather by explicit IDs
  camp intent gather id1 id2 id3 --title "Auth System"

  # Find and gather by tag
  camp intent gather --tag auth --title "Auth System"

  # Find and gather by hashtag
  camp intent gather --hashtag login --title "Login System"

  # Find similar intents and gather
  camp intent gather --similar auth-feature --title "Auth Unified"

  # Gather without archiving sources
  camp intent gather id1 id2 --title "Combined" --no-archive

  # Dry run to preview what would be gathered
  camp intent gather --tag auth --title "Auth System" --dry-run

```
camp intent gather [ids...] [flags]
```

### Options

```
      --concept string    Override concept path
      --dry-run           Preview gather without making changes
      --hashtag string    Find intents by content hashtag
  -h, --help              help for gather
      --horizon string    Override horizon (now, next, later, someday)
      --min-score float   Minimum similarity score (0.0-1.0) (default 0.1)
      --no-archive        Don't archive source intents
      --no-commit         Don't create a git commit
      --priority string   Override priority (low, medium, high)
      --similar string    Find intents similar to this ID
      --tag string        Find intents by frontmatter tag
  -t, --title string      Title for the gathered intent (required)
      --type string       Override type (idea, feature, bug, research)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

