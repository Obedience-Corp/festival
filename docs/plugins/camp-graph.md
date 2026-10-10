---
title: "Camp Graph"
description: "Install Camp Graph to build, search, browse, and export a knowledge graph of the projects and planning files in your camp."
weight: 10
---

Turn the files in your camp into a knowledge graph. Camp Graph connects projects, festivals, intents, designs, chains, and code so you can find related work without remembering where everything lives.

**Host:** Camp · **Command:** `camp graph` · **Release covered:** [v0.1.3](https://github.com/Obedience-Corp/camp-graph/releases/tag/v0.1.3)

## Install

With the [Festival manager]({{< ref "/getting-started/festival-manager" >}}) installed, open its interactive launchpad:

```bash
festival
```

Choose **Browse**, select `obedience-corp/camp-graph`, and press Enter to install it. Wait for installation to finish, then quit the manager and check that Camp discovers the plugin:

```bash
camp plugins
```

Published archives support macOS and Linux on ARM64 and AMD64. You can also download an archive from [Camp Graph releases](https://github.com/Obedience-Corp/camp-graph/releases) and put the `camp-graph` executable on your PATH.

## Build and browse your graph

Run these commands inside an initialized camp containing a `projects/` directory:

```bash
camp graph build
camp graph status --json
camp graph browse
```

The build reads your camp and creates its graph database at `.campaign/graph.db`. The browser lets you explore the graph in the terminal. After changing files, refresh the index:

```bash
camp graph refresh --json
```

## Find related work

Search for a topic, narrow results to projects, or return structured output for an agent:

```bash
camp graph query "authentication"
camp graph query "authentication" --type project --mode hybrid
camp graph query "authentication" --limit 10 --json
```

To find neighbors of a particular file, pass its path relative to the camp root. Replace the example with a file in your camp:

```bash
camp graph related --path "docs/architecture.md" --limit 10 --json
```

## Export a graph

Create a standalone HTML graph to open in a browser or share:

```bash
camp graph render -f html -o graph.html
```

The output path is relative to the camp root. You can also export DOT for graph tooling with `camp graph render -f dot`.

## Troubleshooting and reference

If a command cannot find a camp, run it from the camp root or one of its directories. Build the graph before querying it; use `refresh` when results no longer match the files on disk.

See the [source and command examples](https://github.com/Obedience-Corp/camp-graph) for filtering, graph context, and other export formats. Return to the [Plugin Marketplace]({{< ref "/plugins" >}}) for other Camp and Fest extensions.
