---
title: "camp approvals path"
linkTitle: "camp approvals path"
description: "Print the directory of a request's source"
---

## camp approvals path

Print the directory of a request's source

### Synopsis

Print the absolute directory a request's source lives in, and nothing else,
so a shell can use it:

  cd "$(camp approvals path <id>)"

It fails when the directory is not on this machine or is not inside this camp.

```
camp approvals path <id> [flags]
```

### Options

```
  -h, --help   help for path
```

### Options inherited from parent commands

```
      --json       Emit a structured JSON result
      --no-color   disable colored output
```

### SEE ALSO

* [camp approvals](../camp_approvals/)	 - See what in this camp is waiting on your approval
