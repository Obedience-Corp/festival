---
title: "camp transfer"
linkTitle: "camp transfer"
description: "Copy files between campaigns (and machines)"
---

## camp transfer

Copy files between campaigns (and machines)

### Synopsis

Copy files between campaigns, and between this machine and a registered
fleet machine.

Transfer always copies — it never moves or deletes the source.

Local forms:
  campaign:path     another registered campaign on this machine
  path              relative to the current campaign root
  local:campaign:path
                    force the campaign reading when campaign name collides
                    with a registered machine id

Machine forms (one side only; both-remote is refused):
  machine:campaign:path
                    file on a machine registered in ~/.obey/machines.yaml

See docs/transfer.md for the full grammar, transport, and skew guidance.

At least one side must reference a different campaign or machine. For copies
within the same campaign on this machine, use 'camp copy' instead.

```
camp transfer <src> <dest> [flags]
```

### Examples

```
  camp transfer docs/my-doc.md other-campaign:docs/my-doc.md     # local push
  camp transfer other-campaign:docs/my-doc.md docs/              # local pull
  camp transfer other:festivals/plan.md festivals/planned/       # pull into dir
  camp transfer docs/x.md archdtop:obey-campaign:docs/x.md       # push to machine
  camp transfer archdtop:obey-campaign:docs/x.md docs/x.md       # pull from machine
  camp transfer local:other:docs/x.md archdtop:camp:docs/x.md    # local: escape hatch
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for transfer
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
