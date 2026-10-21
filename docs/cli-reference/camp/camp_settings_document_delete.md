---
title: "camp settings document delete"
linkTitle: "camp settings document delete"
description: "Delete a camp document"
---

## camp settings document delete

Delete a camp document

### Synopsis

Delete one document inside .campaign.

A non-empty --expected-revision is required. The response is an absent snapshot
for the original path.

```
camp settings document delete <path> [flags]
```

### Examples

```
  camp settings document delete notes/done.md --expected-revision sha256:abc
  camp settings document delete notes/done.md --expected-revision sha256:abc --json
  camp settings document delete notes/done.md --campaign my-camp --expected-revision sha256:abc --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for delete
      --json                       emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
