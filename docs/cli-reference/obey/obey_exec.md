---
title: "obey exec"
linkTitle: "obey exec"
description: "Execute a command through the daemon"
---

## obey exec

Execute a command through the daemon

### Synopsis

Execute a command through the daemon in a campaign context.

This allows running CLI tools (fest, camp, just, git) through the daemon,
which handles working directory resolution and command validation.

Every execution is campaign-scoped for security. If --campaign is omitted, the
campaign is inferred from the current working directory. --workdir is an optional
override that must resolve inside the campaign boundary; it does not select the
campaign on its own.

Only allowlisted commands run. The daemon ships a default allowlist (fest, camp,
just, git, and similar tooling). A campaign can extend or replace it via
.campaign/settings/allowlist.json. A denied command fails with "command not
allowed".

The command must be prefixed with -- to separate it from exec flags.

```
obey exec [flags] -- <command> [args...]
```

### Examples

```
  # Execute in the current campaign (inferred from the working directory)
  obey exec -- fest status

  # Execute in a named campaign
  obey exec --campaign obey-platform -- fest status

  # Execute just build with streaming output
  obey exec --campaign obey-platform --follow -- just build

  # Execute in a sub-directory of the campaign (--workdir must be inside it)
  obey exec --campaign obey-platform --workdir path/to/project -- fest next
```

### Options

```
  -c, --campaign string   campaign name or ID
  -f, --follow            stream output (default: wait for completion)
  -h, --help              help for exec
  -t, --timeout int       timeout in seconds (0 = no timeout)
  -w, --workdir string    working directory (overrides campaign path)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
