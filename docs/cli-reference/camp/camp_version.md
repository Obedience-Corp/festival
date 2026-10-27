---
title: "camp version"
linkTitle: "camp version"
description: "Show version information"
---

## camp version

Show version information

### Synopsis

Show camp version, build information, and runtime details.

When both --short and --json are provided, --json wins.

--check compares the Festival suite release this camp shipped in against the
latest stable release of github.com/Obedience-Corp/festival and names the
upgrade command. It reuses a result less than a day old from
~/.obey/update-check/suite.json, the cache camp and fest share; otherwise it
asks GitHub. A camp built outside a suite release has nothing to compare and
says so. --check takes precedence over --short.

Human commands at a terminal print a two-line notice on stderr, at most once
per new suite release, when this camp is behind it. Set
FESTIVAL_NO_UPDATE_CHECK=1 to turn off that notice and the GitHub request
behind it; version --check still checks.

Examples:
  camp version                  Show full version info
  camp version --short          Show only version number
  camp version --json           Output as JSON
  camp version --check          Check for a newer Festival suite release
  camp version --check --json   Output the suite check as JSON

```
camp version [flags]
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
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
