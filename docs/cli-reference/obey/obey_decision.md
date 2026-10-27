---
title: "obey decision"
linkTitle: "obey decision"
description: "Ask a decision provider typed questions about some state"
---

## obey decision

Ask a decision provider typed questions about some state

### Synopsis

A decision sends a piece of state and a set of typed questions to a decision
provider and returns one typed answer per question: the probability of yes for
a yes_no question, an option with its distribution for a choice, and a level
with its distribution for a score.

Get started:
  obey decision init                        write a starter decisions.yaml and check the provider
  obey decision list                        show the named decisions
  obey decision ask <name> --state '...'    ask one and print the answers as JSON

Decision providers are configured in daemon.yaml like any other provider, with
type: typesafe. They never run sessions. When several are enabled,
decisions.default_provider in daemon.yaml names the one to use. Named decisions
live in decisions.yaml next to daemon.yaml and in
<campaign>/.obey/decisions.yaml; a campaign definition replaces a user
definition of the same name.

These commands run in this process. They read daemon.yaml and the provider
credential the same way the daemon does, and do not need a running daemon.

This is not the fest approval judge (ob judge), which runs an agent session to
approve or reject festival work.

### Options

```
  -h, --help   help for decision
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey decision ask](../obey_decision_ask/)	 - Ask a named or ad hoc decision and print the answers as JSON
* [obey decision init](../obey_decision_init/)	 - Write a starter decisions.yaml and show what the provider setup still needs
* [obey decision list](../obey_decision_list/)	 - List named decisions and the file each was loaded from
