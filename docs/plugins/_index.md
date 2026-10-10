---
title: "Plugin Marketplace"
description: "Find CLI plugins for Camp and Fest, with installation instructions, practical examples, and release availability."
hideChildList: true
---

Extend Camp and Fest with tools for exploring your work, sharing progress, measuring effort, and recording the plan behind a commit. Each plugin runs as a familiar `camp` or `fest` subcommand.

These are **CLI plugins** from the [official Obedience marketplace](https://github.com/Obedience-Corp/marketplace). For skills and hooks that run inside your coding agent, use [agent setup]({{< ref "/getting-started/agents" >}}).

## Released Camp plugins

The plugins below have published downloads for macOS and Linux, on Apple Silicon/ARM64 and Intel/AMD64. Each page links to its releases and explains any additional requirements.

{{< cards >}}
{{< card title="Camp Graph" link="/plugins/camp-graph/" >}}
Build and explore a knowledge graph of projects, festivals, intents, and code. Search related work or export a graph to share.
{{< /card >}}
{{< card title="Camp Buzz" link="/plugins/camp-buzz/" >}}
Send camp and festival status updates to a Buzz channel through your own Buzz CLI and relay.
{{< /card >}}
{{< card title="Camp Leverage All" link="/plugins/camp-leverage-all/" >}}
See your estimated development effort across registered camps, with shared repositories counted once.
{{< /card >}}
{{< /cards >}}

## Fest plugins

[Fest Direction]({{< ref "/plugins/fest-direction" >}}) records a stable fingerprint of a festival's written plan and connects it to Git commits. It is listed in the catalog, but **does not have a published release yet**. Its page covers the source-build preview; there are no released Fest plugins in this catalog as of October 9, 2026.

## Install a plugin

First [install the Festival suite]({{< ref "/getting-started/installation" >}}). Open the manager to browse the catalog:

```bash
festival
```

Choose **Browse**, select a compatible plugin, and press Enter to install it. Wait for installation to finish, then quit the manager.

To list catalog entries by host from your shell:

```bash
festival browse --kind plugin --product camp
festival browse --kind plugin --product fest
```

The installer resolves the package, verifies its artifact, and records an installation receipt. A catalog entry alone does not guarantee a downloadable release; check the plugin's availability and requirements on its page.

Check what the host CLIs discover on your PATH:

```bash
camp plugins
fest plugins
```

A package named `camp-graph` runs as `camp graph`; a package named `fest-direction` runs as `fest direction`.

## If a plugin is missing

- Refresh cached catalog data with `festival marketplace refresh`, then browse again. `festival marketplace list` shows the registered marketplaces.
- If installation reports no compatible release, check the plugin's release page for your operating system and architecture. Fest Direction currently requires a source build.
- If a plugin is installed but absent from `camp plugins` or `fest plugins`, check that its executable is on your shell's PATH.
- If the command starts but a service or dependency is missing, follow that plugin's requirements. Camp Buzz, for example, needs a separately configured Buzz relay.

`festival update` updates the suite, not its plugins. Refreshing the catalog also does not update installed plugins. See [Installer & Plugins]({{< ref "/getting-started/festival-manager" >}}) for manager behavior and marketplace registration.

## Build your own

A plugin can be any executable with the right name on your PATH. Start with [writing Camp and Fest plugins]({{< ref "/guides/plugin-authoring" >}}) for dispatch rules, manifests, and runtime assets.
