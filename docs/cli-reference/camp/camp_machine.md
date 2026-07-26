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

Network vs login: Tailscale (or LAN) is how you reach the host; SSH auth is how
you log in. Prefer OpenSSH keys/agent (auth_method=ssh-agent) by default;
Tailscale SSH (auth_method=tailscale-ssh) is opt-in identity login. Terminal
hops always use BatchMode (agents never hang on password prompts).

'camp machine diagnose' reports auth mode, a copy-paste ssh probe, and
ControlMaster socket state (and can clear a stale socket with --reset).

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
  camp machine add buildbox --host 10.0.0.12 --auth ssh-agent --user ci
  camp machine add devbox --host devbox.tailnet.ts.net --auth tailscale-ssh
  camp machine add --discover
  camp machine add --discover --auth tailscale-ssh --user lance
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
* [camp machine diagnose](../camp_machine_diagnose/)	 - Inspect machine auth, probe line, and ssh ControlMaster sockets
* [camp machine list](../camp_machine_list/)	 - List configured machines
* [camp machine remove](../camp_machine_remove/)	 - Remove a machine
