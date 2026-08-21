# Festival shell integration for bash.
# Source this file from ~/.bashrc after installing Festival.

_festival_shell_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
_festival_completion_dir="${_festival_shell_dir}/../completions"

if command -v camp >/dev/null 2>&1; then
  eval "$(camp shell-init bash)"
fi

if command -v fest >/dev/null 2>&1; then
  eval "$(fest shell-init bash)"
fi

if type complete >/dev/null 2>&1; then
  for _festival_completion_file in "${_festival_completion_dir}"/*.bash; do
    [ -f "${_festival_completion_file}" ] && source "${_festival_completion_file}"
  done
  unset _festival_completion_file
fi

unset _festival_shell_dir _festival_completion_dir
