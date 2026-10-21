---
title: "festival setup integrations"
linkTitle: "festival setup integrations"
description: "Configure or repair terminal helpers and Obey provider hooks"
---

## festival setup integrations

Configure or repair terminal helpers and Obey provider hooks

### Synopsis

Configure camp/fest shell helpers and Obey wrapping, preserving unrelated settings. Existing terminals need reopening. Use --check for read-only inspection or --disable to remove owned startup blocks and remember the opt-out.

```
festival setup integrations [flags]
```

### Options

```
      --check          inspect without changing configuration
      --disable        remove owned startup blocks and remember the opt-out
      --enable         enable automatic integration after an opt-out
  -h, --help           help for integrations
      --json           emit a structured readiness report
      --shell string   shell name or absolute executable (defaults to login shell; both installed PowerShell editions on Windows)
```

### Options inherited from parent commands

```
      --managed   use a separate Festival-managed toolchain without modifying package-owned files
```

### SEE ALSO

* [festival setup](../festival_setup/)	 - Create your first festival camp once
