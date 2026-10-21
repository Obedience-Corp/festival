---
title: "camp settings document action"
linkTitle: "camp settings document action"
description: "Run an owner action on a camp document"
---

## camp settings document action

Run an owner action on a camp document

### Synopsis

Run one supported owner action. The JSON body is read from stdin.

--stdin and a non-empty --expected-revision are required. The response is the
persisted snapshot with applied:true. Unsupported actions are errors.

```
camp settings document action <path> <action> [flags]
```

### Examples

```
  camp settings document action settings/pins.json pin --expected-revision absent --stdin
  camp settings document action settings/pins.json unpin --expected-revision sha256:abc --stdin --json
  camp settings document action settings/workitems.json workitem-priority --campaign my-camp --expected-revision absent --stdin --json
```

### Options

```
  -c, --campaign string            Target camp by exact registered name or ID (independent of cwd)
      --expected-revision string   Revision the edit must match (absent or sha256:<hex>)
  -h, --help                       help for action
      --json                       emit a structured JSON result
      --stdin                      read the request body from stdin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
