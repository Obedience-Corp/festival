---
title: "festival update"
linkTitle: "festival update"
description: "Update the installed festival suite to the channel-latest release"
---

## festival update

Update the installed festival suite to the channel-latest release

### Synopsis

update brings the installed festival suite (camp + fest) to the channel-latest release.

The target argument is optional and defaults to "festival", which updates the whole
suite. camp and fest are accepted as aliases: they are not published independently, so
passing either one still updates the whole suite and prints a notice saying so.

```
festival update [festival|camp|fest] [flags]
```

### Options

```
      --allow-unverified   allow updating from unsigned content without prompting
      --channel string     override the release channel (default: the installed channel)
  -h, --help               help for update
      --json               emit JSON output
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
