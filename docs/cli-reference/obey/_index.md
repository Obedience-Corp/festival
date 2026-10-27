---
title: "obey CLI"
description: "Command reference generated from the public Obey v0.2.3 stable binary."
weight: 54
---

These command pages are generated from the **public Obey v0.2.3 stable binary**.
Start with the [root command]({{< ref "/cli-reference/obey/obey" >}}),
[session commands]({{< ref "/cli-reference/obey/obey_session" >}}), or
[provider commands]({{< ref "/cli-reference/obey/obey_providers" >}}).

For installation and examples, read the [Obey guides]({{< ref "/obey" >}}).
The companion developer CLI has its own [ob reference]({{< ref "/cli-reference/ob" >}}).

## Updating this reference

Download the public stable binary for your platform from the
[v0.2.3 release](https://github.com/Obedience-Corp/obey-releases/releases/tag/v0.2.3)
and verify it against that release's checksums. From a Festival checkout, run:

```sh
just docs obey /absolute/path/to/obey
```

The recipe checks the version, generates Markdown, and normalizes it for the
site. The pages are checked in, so ordinary site builds need neither the Obey
binary nor its private source repository. When adopting another release, update
the recipe's version check and the guides together. `ob` does not expose a
documentation generator in this release; its reference is maintained from the
public binary's help.
