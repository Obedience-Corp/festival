---
title: "camp settings document validate"
linkTitle: "camp settings document validate"
description: "Validate camp document source from stdin"
---

## camp settings document validate

Validate camp document source from stdin

### Synopsis

Validate candidate document bytes without writing them.

<path> is a relative path or a known catalog ID. --stdin is required and reads
raw UTF-8 source. An invalid candidate is a result with valid:false.
Nothing is created or rewritten.

```
camp settings document validate <path> [flags]
```

### Examples

```
  camp settings document validate campaign.yaml --stdin
  camp settings document validate settings/local.json --stdin --json
  camp settings document validate campaign.yaml --campaign my-camp --stdin --json
```

### Options

```
  -c, --campaign string   Target camp by exact registered name or ID (independent of cwd)
  -h, --help              help for validate
      --json              emit a structured JSON result
      --stdin             read document source from stdin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
