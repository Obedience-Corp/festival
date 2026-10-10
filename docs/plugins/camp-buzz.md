---
title: "Camp Buzz"
description: "Install Camp Buzz and connect a camp to your own Buzz relay for channel updates with festival, task, path, and gate context."
weight: 20
---

Post camp and festival progress to a Buzz channel. Camp Buzz adds festival, task, path, and gate context to messages so a channel can follow work happening in your camp.

**Host:** Camp · **Command:** `camp buzz` · **Release covered:** [v0.1.2](https://github.com/Obedience-Corp/camp-buzz/releases/tag/v0.1.2)

## Requirements

Camp Buzz needs an operator-provided `buzz` CLI, a reachable Buzz HTTP relay, and a configured `BUZZ_PRIVATE_KEY`. Set the private key in your environment; the camp binding contains only non-secret connection settings. Set `BUZZ_BIN` if the Buzz executable is not available as `buzz` on your PATH.

The plugin does not provide a hosted relay. This is an independent integration, unaffiliated with Block.

## Install

With the [Festival manager]({{< ref "/getting-started/festival-manager" >}}) installed:

```bash
festival install camp-buzz
camp plugins
```

Published archives support macOS and Linux on ARM64 and AMD64. [Camp Buzz releases](https://github.com/Obedience-Corp/camp-buzz/releases) also provide archives for manual installation. Festival v0.3.2 and newer install the plugin's runtime assets under `~/.obey/plugins/camp-buzz/`.

## Bind a channel

Run from your camp. Set the relay URL and channel ID to values from your Buzz setup; the values below are examples:

```bash
export BUZZ_RELAY_URL="http://localhost:3000"
export BUZZ_CHANNEL_ID="your-channel-uuid"
camp buzz bind --channel "$BUZZ_CHANNEL_ID" --relay "$BUZZ_RELAY_URL"
camp buzz show
camp buzz doctor
```

`bind` saves the connection in `.campaign/integrations/buzz.yaml`. `show` displays the binding with secrets redacted, and `doctor` checks whether the local setup is ready. Configure `BUZZ_PRIVATE_KEY` through your existing secret environment before posting.

## Send an update

After `doctor` succeeds, post to the bound channel:

```bash
camp buzz post --message "Implementation is ready for review"
```

To attach work context, supply your actual festival ID and a camp-relative path:

```bash
camp buzz post --message "Validation passed" --festival EX0001 --path "projects/example" --gate pass
```

The message is sent through your Buzz CLI and relay. Optional `--task` context can identify a specific task.

## Connect festival hooks

```bash
camp buzz hook-install
```

This prints example Fest hook YAML; it does not modify your festival's hooks. Review and adapt the example to your festival before enabling automatic posts.

## Troubleshooting and reference

Start with `camp buzz doctor` when posting fails. Check the Buzz executable, relay reachability, private-key environment, and channel binding. Re-run `bind` when the channel or relay changes.

See the [source and setup reference](https://github.com/Obedience-Corp/camp-buzz) for relay setup, hook examples, and all message options. Return to the [Plugin Marketplace]({{< ref "/plugins" >}}) for other Camp and Fest extensions.
