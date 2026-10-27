---
title: "Get started with Obey"
description: "Install the public Obey package, check its background service, and configure your first provider."
weight: 1
---

# Get started with Obey

## Install the two commands

First [install Festival]({{< ref "/getting-started/installation" >}}). Then run:

```sh
festival install obey
festival which obey
festival which ob
festival status
```

Festival verifies the official marketplace metadata, downloads the platform
archive, checks its checksum, and installs both binaries. Obey v0.2.3 has public
archives for macOS, Linux, and Windows on x64 and ARM64. Choose a supported
Festival installation method for your platform; the Festival suite and Obey have
separate release versions and platform packages.

Installation also attempts to install the daemon service and configure provider
hooks and terminal integration. Read any reported setup issues. Open a new
terminal after setup so PATH and shell integration changes take effect.

```sh
obey version
ob --version
```

The `ob` binary in the v0.2.3 package reports its internal version as `0.1.0`.
Use `festival status` to check the installed **Obey package** version and receipt.

## Check the daemon

```sh
obey service status
obey ping
obey doctor
ob doctor
```

The service uses launchd on macOS, `systemd --user` on Linux, and a per-user
Task Scheduler task on Windows. It starts at login and restarts after a crash.
If installation reported a service setup problem, repair it with:

```sh
obey service install
obey service status
```

In an environment without a user service manager, such as a minimal Linux
container, the binaries can still install. Run the daemon in one terminal and
use the client commands in another:

```sh
obey serve --foreground --no-network
```

`--no-network` disables LAN/Tailscale listeners, discovery, and the hub connection.
Owner-local commands still work. See [configuration]({{< ref "/obey/configuration" >}})
for normal service operation and network settings.

## Choose a provider

Install and sign in to the agent CLI you want to use, or have the credentials
and endpoint for an API provider ready. Obey does not supply a provider account.

```sh
obey providers
ob providers
```

`obey providers` lists the daemon's providers. `ob providers` opens the provider
manager, where you can inspect status, configure a profile, test it, and select
a model. CLI providers can be discovered from PATH without a YAML profile;
API providers need configuration. The provider must be available to the daemon's
environment, which can differ from an interactive shell.

For an installed and authenticated Claude Code CLI, for example:

```sh
ob settings set provider claude-code
ob settings set model sonnet
ob config show
```

Use a provider and model you have access to. These settings choose what **ob**
uses; the daemon's default for other clients is configured separately.

## Run from your camp

Navigate into an existing camp or project. Camp-scoped session commands use the
current directory to find the camp.

```sh
obey session list
obey top
```

To try a developer command without sending anything to a provider, create a
small `spec.md` describing a change and preview its prompt:

```sh
ob plan spec.md --show-prompt
```

When you are ready to send that prompt to the configured provider:

```sh
ob plan spec.md
```

Continue with [everyday use]({{< ref "/obey/usage" >}}) for session control,
reviewing code, and working across multiple prompts.

## Update Obey

```sh
festival update obey
obey service status
obey version
```

`festival update` by itself updates the Festival suite. Specify `obey` to update
the package containing `obey` and `ob`. Updating Obey normally restarts its
daemon; that ends running supervised sessions. To place the new binaries and
defer a running daemon's restart, use `festival update obey --no-restart`, then
run `obey service restart` when those sessions can be interrupted.
