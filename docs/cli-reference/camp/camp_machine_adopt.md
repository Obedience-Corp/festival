---
title: "camp machine adopt"
linkTitle: "camp machine adopt"
description: "Register the machine this session was hopped from"
---

## camp machine adopt

Register the machine this session was hopped from

### Synopsis

Register the machine this session was hopped from, after showing you exactly
what will be written.

A hop carries its origin in CAMP_HOP_ORIGIN. This reads that value and offers to
add the origin to your machines file so hops and completion work in the other
direction too. The hop itself never registers anything: adopting is an explicit,
interactive act, and there is no flag that skips the confirmation.

Adopting records how to REACH a machine. It does not make that machine reachable:
that depends on its own sshd or tailnet policy. Verify with 'camp machine diagnose'.

Answering No is remembered, so hints stay quiet until you ask again. Esc/cancel
aborts without writing decline memory. Re-running this command always works;
--force only skips the reminder that you declined before.

```
camp machine adopt [flags]
```

### Options

```
      --force   Skip the reminder that you declined this origin before (never skips the confirmation)
  -h, --help    help for adopt
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp machine](../camp_machine/)	 - Manage remote machines (~/.obey/machines.yaml)
