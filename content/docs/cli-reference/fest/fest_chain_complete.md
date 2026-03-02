## fest chain complete

Complete and archive a chain

### Synopsis

Mark a chain as completed and move it to festivals/dungeon/completed/chains/.

All festivals in the chain must be completed unless --force is used.

```
fest chain complete <chain-id> [flags]
```

### Options

```
      --force          complete even if not all festivals are done
  -h, --help           help for complete
      --notes string   completion notes for the status history
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest chain](fest_chain.md)	 - Manage festival chains (inter-festival dependencies)

