---
title: "Camp Leverage All"
description: "Estimate your development effort across registered camps, deduplicate shared repositories, and inspect contribution timelines with Camp Leverage All."
weight: 30
---

See estimated development effort across all your registered camps in one report. Camp Leverage All groups your author identities and counts repositories shared between camps or worktrees once, using normalized Git remotes.

**Host:** Camp · **Command:** `camp leverage-all` · **Release covered:** [v0.3.0](https://github.com/Obedience-Corp/camp-leverage-all/releases/tag/v0.3.0)

This is an experimental plugin. Its effort and dollar figures are model estimates, not recorded labor costs or revenue.

## Install

With the [Festival manager]({{< ref "/getting-started/festival-manager" >}}) installed, open its interactive launchpad:

```bash
festival
```

Choose **Browse**, select `obedience-corp/camp-leverage-all`, and press Enter to install it. Wait for installation to finish, then quit the manager and check that Camp discovers the plugin:

```bash
camp plugins
```

Published archives support macOS and Linux on ARM64 and AMD64. They bundle Python and `scc`; Git must be available on your PATH. [Camp Leverage All releases](https://github.com/Obedience-Corp/camp-leverage-all/releases) provide the archives and Python packages. Installing from source requires Python 3.11 or newer and `scc` 3.7 or newer.

## Read your report

```bash
camp leverage-all
```

The plugin scans registered camps and their repositories, then reports attributed lines of code, estimated effort, estimated development cost, and a contribution timeline. It reads camp leverage author settings and Git's `user.email` to identify your contributions. Normal runs are read-only and do not write camp leverage caches.

For a smaller report, repeat `--camp` with names or IDs from your camp registry:

```bash
camp leverage-all --camp personal --camp consulting
```

Replace those example names with your own. Use `camp list` to find registered camps.

## Include your other author identities

Add identities used in older commits or another work account:

```bash
camp leverage-all --author-email "me@work.example"
camp leverage-all --author-name "my-automation-account"
```

These repeatable flags add to the discovered identities. Persistent identity groups live in each camp's `.campaign/leverage/authors.json`; see the [plugin reference](https://github.com/Obedience-Corp/camp-leverage-all) for its format.

## Choose an output

```bash
camp leverage-all --timeline quarter
camp leverage-all --timeline none
camp leverage-all --json
```

Timeline intervals can be `month`, `quarter`, `year`, or `none`. Without a flag, the plugin chooses an interval automatically. JSON output is useful for your own reporting tools.

The timeline distributes today's effort estimate using historical contribution weights. It is not a set of historical code snapshots, and a dollar estimate is not a claim about what a project earned.

## Troubleshooting and reference

If a camp is absent, check `camp list`. If your contributions are absent, check your author identities. A missing dependency, invalid input, or incomplete scan exits with status `2`; a complete successful report exits with `0`.

See the [source and measurement reference](https://github.com/Obedience-Corp/camp-leverage-all) for the attribution model and JSON contract. Return to the [Plugin Marketplace]({{< ref "/plugins" >}}) for other Camp and Fest extensions.
