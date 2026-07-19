---
title: "camp machine"
linkTitle: "camp machine"
description: "Manage remote machines (~/.obey/machines.yaml)"
---

## camp machine

Manage remote machines (~/.obey/machines.yaml)

### Synopsis

Manage the fleet of remote machines camp can reach for 'camp switch machine:campaign'
and 'camp list --remote'.

Machines are stored in ~/.obey/machines.yaml. The current machine is always
implicitly available as "local" and is never written to that file.

'camp machine diagnose' inspects the per-machine ssh ControlMaster sockets and
can clear a stale one (the state a sleep or network flap can leave behind, which
would otherwise hang the next hop until ControlPersist expires).

Run without a subcommand in a terminal to manage the fleet interactively: add,
discover, edit, and remove machines, and see each one's socket state. The
subcommands stay the interface for scripts and agents, and remain what a
non-terminal 'camp machine' prints help for.

```
camp machine [flags]
```

### Examples

```
  camp machine
  camp machine list
  camp machine add devbox --host devbox.tailnet.ts.net --auth tailscale-ssh
  camp machine add --discover
  camp machine remove devbox
  camp machine diagnose
  camp machine diagnose devbox --reset
```

### Options

```
  -h, --help   help for machine
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp machine add](../camp_machine_add/)	 - Add or update a machine
* [camp machine diagnose](../camp_machine_diagnose/)	 - Inspect (and optionally clear) ssh ControlMaster sockets
* [camp machine list](../camp_machine_list/)	 - List configured machines
* [camp machine remove](../camp_machine_remove/)	 - Remove a machine
