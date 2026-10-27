---
title: "obey models fits"
linkTitle: "obey models fits"
description: "Show which installed models fit on this node, and how well"
---

## obey models fits

Show which installed models fit on this node, and how well

### Synopsis

Print one row per installed model with the context tier obey would pin for it
and an honest fit label.

Memory fit is necessary and not sufficient. A large model on a node with no
accelerator technically fits and is an order of magnitude below interactive
speed, so it is labelled slow rather than fits: a label that hides that is the
silent degradation this design rejects.

  fits    the footprint at that tier is inside the budget with room to spare
  tight   it fits, but leaves no room for a second resident model
  slow    it fits, but this node has no accelerator for a model this size
  no fit  it does not fit at that tier; the largest tier that would is named
  unknown obey could not read this model's header, so it claims no tier and
          no fit for it rather than printing the class default as if it had
          been verified

With an empty catalog, or when a workload has no fitting installed model, the
same view prints the starter suggestions for this node's budget with the exact
pull commands. obey does not download models.

```
obey models fits [flags]
```

### Options

```
  -h, --help             help for fits
      --json             emit the report as JSON
      --node string      filter to one node; this daemon serves exactly one
      --role string      filter to one workload: interactive, unattended, or bulk
      --runtime string   filter to one local runtime: ollama or llamacpp
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey models](../obey_models/)	 - Inspect the models this node can run
