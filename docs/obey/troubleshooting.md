---
title: "Troubleshoot Obey"
description: "Resolve missing commands, daemon connection failures, provider setup, and session discovery problems."
weight: 4
---

# Troubleshoot Obey

## A command is missing or the wrong copy runs

```sh
festival which obey
festival which ob
festival status
festival doctor
```

Install with `festival install obey` if the package is absent. Open a new
terminal after installation. Check the paths reported by Festival before
replacing a binary that may belong to another installation.

The v0.2.3 package's `ob --version` prints `0.1.0`; that is its internal binary
version. `festival status` reports the Obey package receipt.

## The daemon is unreachable

```sh
obey service status
obey ping
obey socket-path
ob config show
ob doctor
```

Confirm that both clients use the same endpoint. `ob` normally tries to start
the default local daemon when needed. It does not start a different daemon for
an explicit `--socket` or `socket_path` override. `OB_NO_AUTOSTART` disables
automatic startup when set to any value.

Repair a failed service installation with `obey service install`. On Linux,
the service needs a working `systemd --user` session. If no user service manager
is available, run `obey serve --foreground --no-network` in a separate terminal.
Festival reports this case as a service warning even though the binaries were
installed successfully.

`ob` prompt commands use exit status **75** when the daemon cannot be reached
after startup was attempted. The prompt has not run; restore the connection
before retrying. Inspect `obey logs` for daemon startup problems.

## No provider or model is usable

```sh
obey providers
ob providers
ob settings get provider
ob settings get model
ob commands show plan
```

Check the underlying CLI's installation and sign-in, or the API profile's
endpoint and credential. A daemon launched at login may have a different PATH
from your current shell. Select a model that your provider accepts; a displayed
model catalog can be a built-in list rather than a live query.

Use `ob commands show COMMAND` when a prompt template selects a different
provider or model. Changing the daemon's default alone does not change `ob`'s
own preferences. After installing a provider CLI or changing startup
environment variables, restart the daemon when active work can be interrupted.

## Sessions are missing or cannot receive input

```sh
obey bridge status
obey bridge doctor
festival setup integrations --check --json
obey session list --all
```

Run camp-scoped commands from the correct camp, or pass their `--campaign`
flag explicitly. Sessions started outside a camp are unassigned.

If Obey says the camp at the current directory is not registered, run
`camp register` from its root. `camp init` normally registers a new camp;
copied camps or camps initialized with `--no-register` need this step.

Repair terminal integration with `festival setup integrations`, open a new
terminal, and relaunch the provider. Reconcile existing sessions with
`obey bridge reconcile`; this discovers sessions but does not give an
already-running terminal a new input channel. An undelivered note means the
provider did not receive a sent message.

## An update has not changed the running daemon

```sh
festival update obey
obey version
obey service status
```

If you used `--no-restart`, the old process remains active until
`obey service restart`. Restarting interrupts its supervised sessions. Use
`festival update obey` for the Obey package; plain `festival update` selects
the Festival suite.

## macOS blocks a downloaded binary

The [Obey v0.2.3 release notes](https://github.com/Obedience-Corp/obey-releases/releases/tag/v0.2.3)
state that these macOS artifacts are not Developer ID signed or notarized.
macOS may require **Open Anyway** after a direct download. Confirm the release
source and checksum before allowing the binary; daemon configuration cannot
resolve an operating-system execution block.
