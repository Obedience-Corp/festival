---
title: "camp settings document set"
linkTitle: "camp settings document set"
description: "Replace a camp document from stdin"
---

## camp settings document set

Replace a camp document from stdin

### Synopsis

Replace one document with the raw UTF-8 bytes from stdin.

--stdin and a non-empty --expected-revision are required. The write is refused
when the current revision differs. The response is the persisted snapshot.

```
camp settings document set <path> [flags]
```

### Examples

```
  camp settings document set settings/jumps.yaml --expected-revision sha256:abc --stdin
  camp settings document set settings/jumps.yaml --expected-revision sha256:abc --stdin --json
  camp settings document set settings/jumps.yaml --campaign my-camp --expected-revision sha256:abc --stdin --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for set
      --json                       emit a structured JSON result
      --stdin                      read the request body from stdin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
