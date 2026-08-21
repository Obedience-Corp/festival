# Festival shell integration for fish.
# Source this file from ~/.config/fish/config.fish after installing Festival.

set -l _festival_shell_dir (dirname (status --current-filename))
set -l _festival_completion_dir "$_festival_shell_dir/../completions"

if command -q camp
    camp shell-init fish | source
end

if command -q fest
    fest shell-init fish | source
end

if test -d "$_festival_completion_dir"
    for _festival_completion_file in $_festival_completion_dir/*.fish
        if test -f "$_festival_completion_file"
            source "$_festival_completion_file"
        end
    end
end
