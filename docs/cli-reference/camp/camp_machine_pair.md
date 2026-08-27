---
title: "camp machine pair"
linkTitle: "camp machine pair"
description: "Exchange ssh keys with a machine so hops work both ways"
---

## camp machine pair

Exchange ssh keys with a machine so hops work both ways

### Synopsis

Exchange ssh keys with a registered machine so hops work in both directions,
after showing you exactly what will be written on each side.

Run this from the machine that can ALREADY reach the other one. One working
direction is enough to pair both: camp installs this machine's key over there,
reads that machine's key back, and installs it here. That is what makes a GUI
macOS peer reachable afterwards, since it cannot serve Tailscale SSH at all.

Camp creates dedicated ed25519 keys under ~/.obey/keys, one per direction of
one pair, so a pairing can be revoked on its own. It never touches ~/.ssh/id_*,
and it never enables a login service: if the reverse direction needs sshd or
macOS Remote Login turned on, camp tells you and stops.

Pairing is an explicit, interactive act. There is no flag that skips the
confirmation, and it cannot run without a terminal.

```
camp machine pair <machine> [flags]
```

### Examples

```
  camp machine pair mac-studio    # from the machine that can already reach it
```

### Options

```
  -h, --help   help for pair
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp machine](../camp_machine/)	 - Manage remote machines (~/.obey/machines.yaml)
