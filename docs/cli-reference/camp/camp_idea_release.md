---
title: "camp idea release"
linkTitle: "camp idea release"
description: "Release an intent's assignment"
---

## camp idea release

Release an intent's assignment

### Synopsis

Clear an intent's assigned_to and assigned_at, returning it to the
unclaimed pool. Any recorded work_ref entries (PR URLs, branches, festival
paths) are left in place so a later camp intent sync can still resolve them.

Examples:
  camp intent release add-dark

```
camp idea release <id> [flags]
```

### Options

```
  -h, --help        help for release
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas
