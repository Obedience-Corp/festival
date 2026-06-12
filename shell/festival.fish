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

if test -f "$_festival_completion_dir/camp.fish"
    source "$_festival_completion_dir/camp.fish"
end

if test -f "$_festival_completion_dir/fest.fish"
    source "$_festival_completion_dir/fest.fish"
end
