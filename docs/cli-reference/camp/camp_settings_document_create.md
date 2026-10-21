---
title: "camp settings document create"
linkTitle: "camp settings document create"
description: "Create a camp document from stdin"
---

## camp settings document create

Create a camp document from stdin

### Synopsis

Create one absent document from the raw UTF-8 bytes on stdin.

--stdin and --expected-revision absent are required. An existing path is refused.
The response is the persisted snapshot.

```
camp settings document create <path> [flags]
```

### Examples

```
  camp settings document create notes/readme.md --expected-revision absent --stdin
  camp settings document create notes/readme.md --expected-revision absent --stdin --json
  camp settings document create notes/readme.md --campaign my-camp --expected-revision absent --stdin --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for create
      --json                       emit a structured JSON result
      --stdin                      read the request body from stdin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
