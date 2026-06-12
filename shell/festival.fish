# Festival shell integration for fish.
# Source this file from ~/.config/fish/config.fish after installing Festival.

if command -q camp
    camp shell-init fish | source
end

if command -q fest
    fest shell-init fish | source
end
