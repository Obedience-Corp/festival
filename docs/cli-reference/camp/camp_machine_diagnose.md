---
title: "camp machine diagnose"
linkTitle: "camp machine diagnose"
description: "Inspect machine auth, probe line, and ssh ControlMaster sockets"
---

## camp machine diagnose

Inspect machine auth, probe line, and ssh ControlMaster sockets

### Synopsis

Report how each configured machine is set up to hop (or one machine if an id
is given):

  auth     OpenSSH (keys/agent) or Tailscale SSH (identity)
  probe    copy-paste BatchMode ssh line to test outside camp
  socket   ControlMaster multiplex state:
             none   no socket — the next hop opens a fresh master
             live   socket present and the master answers 'ssh -O check'
             stale  socket present but the master no longer answers

A stale socket is what a sleep or network flap can leave behind; until it is
removed (or ControlPersist expires) the next 'camp switch machine:...' or
'camp list --remote' hop to that machine can hang. Pass --reset to tear down
stale sockets so the next hop reconnects cleanly. Live and absent sockets are
left untouched.

```
camp machine diagnose [id] [flags]
```

### Examples

```
  camp machine diagnose
  camp machine diagnose devbox
  camp machine diagnose --reset
  camp machine diagnose devbox --reset --json
```

### Options

```
  -h, --help    help for diagnose
      --json    Output as JSON
      --reset   Tear down stale ControlMaster sockets so the next hop reconnects
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp machine](../camp_machine/)	 - Manage remote machines (~/.obey/machines.yaml)
