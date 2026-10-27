---
title: "Obey and ob"
description: "Install and configure the Obey daemon and its developer CLI, then use them with your camps and agents."
weight: 44
---

# Obey and ob

Obey keeps a local record of your agent sessions and can launch and manage agents
inside your camps. The Obey package installs two commands:

| Command | Use it for |
| --- | --- |
| `obey` | Running the daemon, connecting providers, tracking sessions, and inspecting their activity. |
| `ob` | Developer tasks such as planning, reviewing a diff, and generating a commit message through that daemon. |

Obey is a separate product installed by Festival. Installing the Festival suite
alone gives you `festival`, `camp`, and `fest`; add Obey with:

```sh
festival install obey
```

This installs **both** `obey` and `ob`. Obey's source repository is private, but
the product archives and checksums are [publicly downloadable](https://github.com/Obedience-Corp/obey-releases/releases/tag/v0.2.3).
You do not need source access or a GitHub login to install them through the
official marketplace. Provider sign-in or API credentials are separate.

These guides describe **Obey v0.2.3**, used with Festival v0.3.25.

- [Get started]({{< ref "/obey/getting-started" >}}): install, check the daemon, and choose a provider.
- [Configuration]({{< ref "/obey/configuration" >}}): provider profiles, credentials, defaults, and per-camp settings.
- [Everyday use]({{< ref "/obey/usage" >}}): observe sessions, run prompts, and use the developer commands.
- [Troubleshooting]({{< ref "/obey/troubleshooting" >}}): resolve installation, connection, provider, and session problems.
- [obey reference]({{< ref "/cli-reference/obey" >}}) and [ob reference]({{< ref "/cli-reference/ob" >}}): command syntax and flags.
