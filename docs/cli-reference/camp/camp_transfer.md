## camp transfer

Copy files between campaigns

### Synopsis

Copy files between different campaigns using campaign:path syntax.

Transfer always copies — it never moves or deletes the source.
Either the source or destination (or both) can use "campaign:path"
notation to reference a different registered campaign. Paths without
a campaign prefix resolve relative to the current campaign root.

At least one side must reference a different campaign. For copies
within the same campaign, use 'camp copy' instead.

```
camp transfer <src> <dest> [flags]
```

### Examples

```
  camp transfer docs/my-doc.md other-campaign:docs/my-doc.md     # push
  camp transfer other-campaign:docs/my-doc.md docs/              # pull
  camp transfer other:festivals/plan.md festivals/planned/       # pull into dir
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for transfer
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

