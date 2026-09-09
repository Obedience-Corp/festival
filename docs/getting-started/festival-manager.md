---
title: "Festival Installer and Plugin Manager"
linkTitle: "Installer & Plugins"
description: "Use the festival binary to install and update the suite, check installation health, and discover executable camp and fest plugins."
---

# Festival Installer and Plugin Manager

The `festival` binary is the suite's installer, launchpad, and CLI plugin manager. It helps you get the right tools on your PATH and find extensions when you need them.

If you have not installed the suite yet, choose your platform in the [installation guide]({{< ref "/getting-started/installation" >}}), then return here to manage it.

The suite has three commands with different jobs:

- `festival` installs and updates the `camp` and `fest` suite, checks it,
  locates binaries, and browses registered marketplaces.
- `fest` plans work with phases, sequences, tasks, and approval gates.
- `camp` holds projects, worktrees, planning files, and navigation shortcuts.

Run `festival` with no arguments in a terminal to open its interactive
launchpad. Starting `camp` or `fest` there runs the real CLI process; quitting
it returns to the launchpad.

## Check the suite you are running

Start with read-only checks when a command is missing, a shell wrapper seems to
point to the wrong program, or a recent update did not take effect:

```bash
festival doctor
festival which camp
festival which fest --show-all
```

`festival doctor` reports PATH, package sources, and receipts. `festival which`
resolves the executable behind a suite tool and can show both the active and
installer-managed locations. Shell integration may define `camp` and `fest` as
functions, so a plain `which camp` may show a function instead of a binary.

For a suite installed by the Festival manager, an update is:

```bash
festival update festival
```

The suite moves together: `festival update camp` and `festival update fest` are
accepted aliases, not independent component updates. The manager does not
replace a Homebrew, npm, or AUR installation; it preserves package-manager
ownership. The [installation guide]({{< ref "/getting-started/installation" >}})
lists direct upgrade commands. Check the
[doctor reference]({{< ref "/cli-reference/festival/festival_doctor" >}}),
[which reference]({{< ref "/cli-reference/festival/festival_which" >}}), and
[update reference]({{< ref "/cli-reference/festival/festival_update" >}}) before
changing an installation.

## Browse and install CLI plugins

The manager can register a Git marketplace and display packages from the
marketplaces already registered on this machine:

```bash
festival marketplace list
festival browse
festival browse --kind plugin --product fest
festival browse --kind plugin --product camp
```

`--kind` filters package classes. `--product` filters by the host product in
package metadata: `fest`, `camp`, or `obey`. To add a marketplace, use
`festival marketplace add <git-url>`; refresh its cached data with
`festival marketplace refresh [name]`. Both change local state.

In the interactive manager, open **Browse**, select a compatible `camp-*` or
`fest-*` plugin, and press Enter to install it. These executable extensions are
not agent plugins. The manager resolves the selected package, checks its
compatibility, verifies its artifact, activates it, and records a receipt.
Review the package source and compatibility information before installing an
executable extension.

`festival update` updates the `camp` and `fest` suite together, not plugins. In Browse, `r`
refreshes marketplace data; it does not update an installed plugin. The
[browse reference]({{< ref "/cli-reference/festival/festival_browse" >}}) and
[marketplace reference]({{< ref "/cli-reference/festival/festival_marketplace" >}})
cover the non-interactive discovery commands.

## Keep CLI plugins separate from agent integrations

A **CLI plugin** is an executable extension named for its host, such as a
`camp-*` or `fest-*` package. Festival discovers and installs these from its
own marketplaces. `camp plugins` and `fest plugins` show what their CLIs find.

An **agent integration package** belongs to an AI coding product, not Festival.
It may contain skills, hooks, commands, or agent definitions, and its product
controls installation and updates. A **skill** is an instruction unit an agent
loads for a kind of work. Neither is a `camp-*` or `fest-*` executable plugin.

Use the [agent setup guides]({{< ref "/getting-started/agents" >}}) for an
agent integration's installation path. Use `festival browse` and the Browser
for marketplace CLI plugins. `obey` metadata is a catalog filter, not a signal
that Festival can install it as a `camp` or `fest` plugin.

For planning help, start in a camp with `fest intro` or `fest understand methodology`. For project and navigation work, use `camp`. For suite health,
updates, and package discovery, return to `festival`.
