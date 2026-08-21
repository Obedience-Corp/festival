# Festival shell integration for zsh.
# Source this file from ~/.zshrc after installing Festival.

_festival_setup_zsh_completions() {
  local shell_dir completion_dir path_seen path_entry

  shell_dir="${${(%):-%x}:A:h}"
  completion_dir="${shell_dir:h}/completions"

  if [[ -d "$completion_dir" ]]; then
    path_seen=0
    for path_entry in "${fpath[@]}"; do
      if [[ "$path_entry" == "$completion_dir" ]]; then
        path_seen=1
        break
      fi
    done
    (( path_seen )) || fpath=("$completion_dir" $fpath)
  fi

  autoload -Uz compinit bashcompinit
  if (( ! $+functions[compdef] && $+functions[compinit] )); then
    compinit -i 2>/dev/null
  fi
  if (( ! $+builtins[complete] && ! $+functions[complete] && $+functions[bashcompinit] )); then
    bashcompinit 2>/dev/null
  fi
}

_festival_register_zsh_cli_completions() {
  local shell_dir completion_dir

  shell_dir="${${(%):-%x}:A:h}"
  completion_dir="${shell_dir:h}/completions"

  if (( $+functions[compdef] )) && [[ -d "$completion_dir" ]]; then
    if [[ -f "$completion_dir/_camp" ]]; then
      autoload -Uz _camp
      compdef _camp camp
    fi
    if [[ -f "$completion_dir/_fest" ]]; then
      autoload -Uz _fest
      compdef _fest fest
    fi
    if [[ -f "$completion_dir/_festival" ]]; then
      autoload -Uz _festival
      compdef _festival festival
    fi
  fi
}

_festival_setup_zsh_completions

if command -v camp >/dev/null 2>&1; then
  eval "$(camp shell-init zsh)"
fi

if command -v fest >/dev/null 2>&1; then
  eval "$(fest shell-init zsh)"
fi

_festival_register_zsh_cli_completions
unfunction _festival_setup_zsh_completions _festival_register_zsh_cli_completions
