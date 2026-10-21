---
title: "camp settings document rename"
linkTitle: "camp settings document rename"
description: "Rename a camp document"
---

## camp settings document rename

Rename a camp document

### Synopsis

Rename one document to <destination> inside .campaign.

A non-empty --expected-revision is required. An existing destination is refused.
The response is the destination snapshot.

```
camp settings document rename <path> <destination> [flags]
```

### Examples

```
  camp settings document rename notes/readme.md notes/done.md --expected-revision sha256:abc
  camp settings document rename notes/readme.md notes/done.md --expected-revision sha256:abc --json
  camp settings document rename notes/readme.md notes/done.md --campaign my-camp --expected-revision sha256:abc --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for rename
      --json                       emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
