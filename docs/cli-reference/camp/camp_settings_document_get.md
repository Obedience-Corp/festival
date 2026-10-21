---
title: "camp settings document get"
linkTitle: "camp settings document get"
description: "Print one camp document"
---

## camp settings document get

Print one camp document

### Synopsis

Print one document under the selected camp's .campaign directory.

<path> is a relative path or a known catalog ID. Missing files stay absent.
Nothing is created or rewritten.

```
camp settings document get <path> [flags]
```

### Examples

```
  camp settings document get campaign.yaml
  camp settings document get settings/local.json --json
  camp settings document get campaign.yaml --campaign my-camp --json
```

### Options

```
  -c, --campaign string   Target camp by exact registered name or ID (independent of cwd)
  -h, --help              help for get
      --json              emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings document](../camp_settings_document/)	 - Read and edit camp documents
