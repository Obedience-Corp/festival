## fest completion

Generate shell completion scripts

### Synopsis

Generate shell completion scripts for fest.

This command generates shell-specific completion scripts that enable
tab completion for commands, flags, and arguments.

SETUP:

  Bash:
```bash
    # Add to ~/.bashrc:
    source <(fest completion bash)

    # Or save to a file:
    fest completion bash > /usr/local/etc/bash_completion.d/fest

  Zsh:
    # Add to ~/.zshrc:
    source <(fest completion zsh)

    # Or save to completions directory:
    fest completion zsh > "${fpath[1]}/_fest"

  Fish:
    fest completion fish | source

    # Or save to completions directory:
    fest completion fish > ~/.config/fish/completions/fest.fish

  PowerShell:
    fest completion powershell | Out-String | Invoke-Expression
```

CUSTOM COMPLETIONS:

After setup, you can tab-complete:
```bash
  fest status act<TAB>     → fest status active/
  fest show pla<TAB>       → fest show plan
  fest create <TAB>        → festival, phase, sequence, task
```

```
fest completion [bash|zsh|fish|powershell]
```

### Options

```
  -h, --help   help for completion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

