---
title: "fest version"
linkTitle: "fest version"
description: "Show version information"
---

## fest version

Show version information

### Synopsis

Show fest version, build information, and runtime details.

With --check, compare this build's Festival suite release against the latest
stable release on github.com/Obedience-Corp/festival and print how to upgrade.
The result is cached for 24 hours in ~/.obey/update-check/suite.json, shared
with camp. fest also mentions a newer release on stderr after human commands
such as fest status and fest list, once per release; set
FESTIVAL_NO_UPDATE_CHECK=1 to turn that off. fest never updates itself.
--check takes precedence over --short.

Examples:
```bash
  fest version                  Show full version info
  fest version --short          Show only version number
  fest version --json           Output as JSON
  fest version --check          Check for a newer Festival suite release
  fest version --check --json   Output the check result as JSON
```

```
fest version [flags]
```

### Options

```
      --check   check for a newer Festival suite release
  -h, --help    help for version
      --json    output as JSON
  -s, --short   show only version number
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
