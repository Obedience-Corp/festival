# Festival shell integration for bash.
# Source this file from ~/.bashrc after installing Festival.

if command -v camp >/dev/null 2>&1; then
  eval "$(camp shell-init bash)"
fi

if command -v fest >/dev/null 2>&1; then
  eval "$(fest shell-init bash)"
fi
