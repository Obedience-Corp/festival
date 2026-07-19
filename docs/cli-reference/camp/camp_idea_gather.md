---
title: "camp idea gather"
linkTitle: "camp idea gather"
description: "Gather related ideas into a unified document"
---

## camp idea gather

Gather related ideas into a unified document

### Synopsis

Gather multiple related ideas into a single unified document.

DISCOVERY MODES:
  By IDs      Explicitly specify idea IDs to gather
  --tag       Find ideas with a specific frontmatter tag
  --hashtag   Find ideas containing a specific #hashtag
  --similar   Find ideas similar to a given ID (TF-IDF)

The gather process:
  1. Find related ideas using the specified discovery method
  2. Merge their content with full metadata preservation
  3. Create a new unified idea in inbox status
  4. Archive source ideas (unless --no-archive)

Source ideas are preserved with a 'gathered_into' reference.

Examples:
  # Gather by explicit IDs
  camp idea gather id1 id2 id3 --title "Auth System"

  # Find and gather by tag
  camp idea gather --tag auth --title "Auth System"

  # Find and gather by hashtag
  camp idea gather --hashtag login --title "Login System"

  # Find similar ideas and gather
  camp idea gather --similar auth-feature --title "Auth Unified"

  # Gather without archiving sources
  camp idea gather id1 id2 --title "Combined" --no-archive

  # Dry run to preview what would be gathered
  camp idea gather --tag auth --title "Auth System" --dry-run

```
camp idea gather [ids...] [flags]
```

### Options

```
      --concept string    Override concept path
      --dry-run           Preview gather without making changes
      --hashtag string    Find ideas by content hashtag
  -h, --help              help for gather
      --horizon string    Override horizon (now, next, later, someday)
      --min-score float   Minimum similarity score (0.0-1.0) (default 0.1)
      --no-archive        Don't archive source ideas
      --no-commit         Don't create a git commit
      --priority string   Override priority (low, medium, high)
      --similar string    Find ideas similar to this ID
      --tag string        Find ideas by frontmatter tag
  -t, --title string      Title for the gathered idea (required)
      --type string       Override type (idea, feature, bug, research)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
