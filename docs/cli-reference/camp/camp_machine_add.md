---
title: "camp machine add"
linkTitle: "camp machine add"
description: "Add or update a machine"
---

## camp machine add

Add or update a machine

### Synopsis

Add a machine to ~/.obey/machines.yaml, or update it if the id already exists
(idempotent on id: a second 'add' with the same id replaces the entry rather
than duplicating it).

With --discover, camp runs 'tailscale status --json' and lets you pick a
tailnet device (network identity only). Default auth is OpenSSH keys/agent
(ssh-agent); pass --auth tailscale-ssh for Tailscale identity login. --user and
--identity are honored with --discover. Pass an id positionally with --discover
to select that device by its derived id non-interactively (skips the picker),
or use --yes to take the first discovered device.

```
camp machine add [id] [flags]
```

### Examples

```
  camp machine add buildbox --host 10.0.0.12 --auth ssh-agent --user ci
  camp machine add devbox --host devbox.tailnet.ts.net --auth tailscale-ssh
  camp machine add --discover
  camp machine add --discover --auth tailscale-ssh --user lance
  camp machine add devbox --discover
  camp machine add --discover --yes
```

### Options

```
      --auth string       Auth method: tailscale-ssh, ssh-agent, ssh-password (default "ssh-agent")
      --discover          Discover devices via 'tailscale status --json' and pick one
  -h, --help              help for add
      --host string       SSH host or Tailscale MagicDNS name (required unless --discover)
      --identity string   Path to SSH identity file
      --label string      Human-readable label
      --user string       SSH user
      --yes               With --discover, take the first discovered device non-interactively
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp machine](../camp_machine/)	 - Manage remote machines (~/.obey/machines.yaml)
