---
title: "camp settings catalog"
linkTitle: "camp settings catalog"
description: "List camp documents"
---

## camp settings catalog

List camp documents

### Synopsis

List documents under the selected camp's .campaign directory.

Prints the settings-documents/v1alpha1 catalog, including known schemas that
are absent. Nothing is created or rewritten.

```
camp settings catalog [flags]
```

### Examples

```
  camp settings catalog
  camp settings catalog --json
  camp settings catalog --campaign my-camp --json
```

### Options

```
  -c, --campaign string   Target camp by exact registered name or ID (independent of cwd)
  -h, --help              help for catalog
      --json              emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings](../camp_settings/)	 - Manage camp configuration
