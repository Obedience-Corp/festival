# Festival shell integration for zsh.
# Source this file from ~/.zshrc after installing Festival.

# The bundled CLI helpers register zsh and bash-style completions. Initialize
# zsh completion first so older bundled camp/fest versions do not emit compdef
# or complete errors when this helper is sourced early in .zshrc.
autoload -Uz compinit bashcompinit
if (( $+functions[compinit] )); then
  compinit -u 2>/dev/null
fi
if (( $+functions[bashcompinit] )); then
  bashcompinit 2>/dev/null
fi

if command -v camp >/dev/null 2>&1; then
  eval "$(camp shell-init zsh)"
fi

if command -v fest >/dev/null 2>&1; then
  eval "$(fest shell-init zsh)"
fi
