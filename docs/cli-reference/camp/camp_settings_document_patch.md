---
title: "camp settings document patch"
linkTitle: "camp settings document patch"
description: "Patch a camp document from stdin"
---

## camp settings document patch

Patch a camp document from stdin

### Synopsis

Apply a JSON patch from stdin to one document.

The body is {"changes":[{"op":"set"|"remove","path":["key"],"value":...}]}.
--stdin and a non-empty --expected-revision are required. Comments and unknown
keys are preserved. The response is the persisted snapshot.

```
camp settings document patch <path> [flags]
```

### Examples

```
  camp settings document patch settings/jumps.yaml --expected-revision sha256:abc --stdin
  camp settings document patch settings/jumps.yaml --expected-revision sha256:abc --stdin --json
  camp settings document patch settings/jumps.yaml --campaign my-camp --expected-revision sha256:abc --stdin --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for patch
      --json                       emit a structured JSON result
      --stdin                      read the request body from stdin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
