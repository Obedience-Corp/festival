---
title: "camp register"
linkTitle: "camp register"
description: "Register a camp in the global registry"
---

## camp register

Register a camp in the global registry

### Synopsis

Register an existing camp in the global registry.

This adds the camp to the registry at ~/.obey/campaign/registry.json,
enabling it to appear in 'camp list' and be accessible via navigation commands.

Note: 'camp init' automatically registers new camps. This command is for
registering existing camps that weren't created with camp or were unregistered.

If the specified path is not a camp (has no .campaign/ directory),
you'll be offered the option to initialize it.

Examples:
  camp register                          # Register current directory
  camp register ~/Dev/my-project         # Register specified path
  camp register . --name custom-name     # Override the camp name
  camp register . --type research        # Override the camp type

```
camp register [path] [flags]
```

### Options

```
  -h, --help          help for register
  -n, --name string   Override camp name
  -t, --type string   Override camp type (product, research, tools, personal)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
