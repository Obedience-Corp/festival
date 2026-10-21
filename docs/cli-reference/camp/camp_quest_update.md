---
title: "camp quest update"
linkTitle: "camp quest update"
description: "Update quest metadata"
---

## camp quest update

Update quest metadata

### Synopsis

Update quest metadata without opening an editor.

Omitted fields are left unchanged. Provide an empty value to clear a field.

Examples:
  camp quest update platform-launch --purpose "harden launch path"
  camp quest update platform-launch --description ""
  camp quest update platform-launch --purpose "..." --description "..."

```
camp quest update <quest> [flags]
```

### Options

```
      --description string   Full description
  -h, --help                 help for update
      --no-commit            Don't create a git commit
      --purpose string       Short purpose statement
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
