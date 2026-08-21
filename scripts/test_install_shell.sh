#!/usr/bin/env bash
# Unit tests for install.sh login-profile PATH writes.
#
# Sources install.sh (main() is guarded so sourcing only defines functions)
# and exercises configure_shell_startup against an isolated HOME. No network,
# no real user rc files. Invoked by `just test install-shell`.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=../install.sh
source "$repo_root/install.sh"

fail=0
HOME_DIR=""

cleanup() {
    if [ -n "${HOME_DIR:-}" ] && [ -d "$HOME_DIR" ]; then
        rm -rf "$HOME_DIR"
    fi
}
trap cleanup EXIT

fail_msg() {
    printf 'FAIL %s\n' "$1" >&2
    fail=1
}

pass_msg() {
    printf 'ok   %s\n' "$1"
}

new_home() {
    cleanup
    HOME_DIR="$(mktemp -d "${TMPDIR:-/tmp}/festival-install-shell.XXXXXX")"
    export HOME="$HOME_DIR"
    unset ZDOTDIR
    INSTALL_DIR="$HOME/.local/bin"
    SHELL_SETUP=1
}

file_contains() { # $1 file $2 needle
    grep -Fq "$2" "$1"
}

count_marker() { # $1 file $2 marker
    grep -F "$2" "$1" | wc -l | tr -d ' '
}

# --- posix_path_block is a guarded prepend of INSTALL_DIR ---
new_home
block="$(posix_path_block)"
case "$block" in
    *"export PATH=\"${INSTALL_DIR}:\$PATH\""*) pass_msg "posix_path_block exports INSTALL_DIR" ;;
    *) fail_msg "posix_path_block missing PATH export: $block" ;;
esac
case "$block" in
    *"\":${INSTALL_DIR}:\""*) pass_msg "posix_path_block is idempotent at runtime" ;;
    *) fail_msg "posix_path_block missing PATH membership guard" ;;
esac

# --- shell_login_profiles ---
new_home
got="$(shell_login_profiles zsh)"
if [ "$got" = "$HOME/.zprofile" ]; then
    pass_msg "zsh login profile is ~/.zprofile"
else
    fail_msg "zsh login profile want=$HOME/.zprofile got=$got"
fi

got="$(shell_login_profiles bash)"
if [ "$got" = "$HOME/.profile" ]; then
    pass_msg "bash login profile is ~/.profile when bash_profile is absent"
else
    fail_msg "bash login profile want=$HOME/.profile got=$got"
fi

touch "$HOME/.bash_profile"
got="$(shell_login_profiles bash)"
want="$HOME/.profile
$HOME/.bash_profile"
if [ "$got" = "$want" ]; then
    pass_msg "bash also targets an existing ~/.bash_profile"
else
    fail_msg "bash login profiles want existing bash_profile, got=$got"
fi

if shell_login_profiles fish >/dev/null 2>&1; then
    fail_msg "fish should not have a separate login profile"
else
    pass_msg "fish has no extra login profile"
fi

export ZDOTDIR="$HOME/zdot"
got="$(shell_login_profiles zsh)"
if [ "$got" = "$HOME/zdot/.zprofile" ]; then
    pass_msg "zsh login profile honors ZDOTDIR"
else
    fail_msg "ZDOTDIR zprofile want=$HOME/zdot/.zprofile got=$got"
fi
unset ZDOTDIR

# --- zsh: rc gets helpers, zprofile gets PATH only ---
new_home
export SHELL=/bin/zsh
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null

if [ ! -f "$HOME/.zshrc" ]; then
    fail_msg "zshrc was not created"
else
    if file_contains "$HOME/.zshrc" "source \"$HOME/.local/share/festival/shell/festival.zsh\""; then
        pass_msg "zshrc sources festival.zsh"
    else
        fail_msg "zshrc missing helper source"
    fi
    if file_contains "$HOME/.zshrc" "export PATH=\"${INSTALL_DIR}:\$PATH\""; then
        pass_msg "zshrc still has PATH"
    else
        fail_msg "zshrc missing PATH"
    fi
fi

if [ ! -f "$HOME/.zprofile" ]; then
    fail_msg "zprofile was not created"
else
    if file_contains "$HOME/.zprofile" ">>> festival path >>>"; then
        pass_msg "zprofile has PATH marker"
    else
        fail_msg "zprofile missing PATH marker"
    fi
    if file_contains "$HOME/.zprofile" "export PATH=\"${INSTALL_DIR}:\$PATH\""; then
        pass_msg "zprofile has PATH prepend"
    else
        fail_msg "zprofile missing PATH prepend"
    fi
    if file_contains "$HOME/.zprofile" "festival.zsh"; then
        fail_msg "zprofile should not source interactive helpers"
    else
        pass_msg "zprofile does not source helpers"
    fi
fi

if [ -f "$HOME/.profile" ] || [ -f "$HOME/.bash_profile" ]; then
    fail_msg "zsh setup wrote bash profile files"
else
    pass_msg "zsh setup does not touch bash profiles"
fi

# --- idempotent rerun ---
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null
if [ "$(count_marker "$HOME/.zprofile" ">>> festival path >>>")" = "1" ]; then
    pass_msg "zprofile PATH write is idempotent"
else
    fail_msg "zprofile PATH marker count is not 1 after rerun"
fi
if [ "$(count_marker "$HOME/.zshrc" ">>> festival shell integration >>>")" = "1" ]; then
    pass_msg "zshrc helper write is idempotent"
else
    fail_msg "zshrc helper marker count is not 1 after rerun"
fi

# --- upgrade: existing rc block still gets login PATH ---
new_home
export SHELL=/bin/zsh
mkdir -p "$HOME"
cat > "$HOME/.zshrc" <<EOF
# existing rc
# >>> festival shell integration >>>
source "$HOME/.local/share/festival/shell/festival.zsh"
# <<< festival shell integration <<<
EOF
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null
if [ "$(count_marker "$HOME/.zshrc" ">>> festival shell integration >>>")" = "1" ]; then
    pass_msg "upgrade does not duplicate rc block"
else
    fail_msg "upgrade duplicated rc block"
fi
if file_contains "$HOME/.zprofile" ">>> festival path >>>"; then
    pass_msg "upgrade writes login PATH even when rc already configured"
else
    fail_msg "upgrade did not write zprofile PATH"
fi

# --- bash: bashrc + profile; bash_profile only if it already exists ---
new_home
export SHELL=/bin/bash
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null
if [ -f "$HOME/.bashrc" ] && file_contains "$HOME/.bashrc" "festival.bash"; then
    pass_msg "bashrc sources festival.bash"
else
    fail_msg "bashrc missing helper source"
fi
if [ -f "$HOME/.profile" ] && file_contains "$HOME/.profile" ">>> festival path >>>"; then
    pass_msg "bash writes PATH to ~/.profile"
else
    fail_msg "bash did not write ~/.profile PATH"
fi
if [ -f "$HOME/.bash_profile" ]; then
    fail_msg "bash created ~/.bash_profile which would shadow .bashrc"
else
    pass_msg "bash does not create ~/.bash_profile"
fi

new_home
export SHELL=/bin/bash
printf '# existing bash_profile\n' > "$HOME/.bash_profile"
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null
if file_contains "$HOME/.profile" ">>> festival path >>>" && \
   file_contains "$HOME/.bash_profile" ">>> festival path >>>"; then
    pass_msg "existing bash_profile also gets PATH"
else
    fail_msg "existing bash_profile did not get PATH"
fi
if file_contains "$HOME/.bash_profile" "# existing bash_profile"; then
    pass_msg "existing bash_profile content is preserved"
else
    fail_msg "existing bash_profile content was overwritten"
fi

# --- fish: config.fish only ---
new_home
export SHELL=/usr/bin/fish
configure_shell_startup "$HOME/.local/share/festival/shell" >/dev/null
if [ -f "$HOME/.config/fish/config.fish" ] && file_contains "$HOME/.config/fish/config.fish" "festival.fish"; then
    pass_msg "fish writes config.fish"
else
    fail_msg "fish did not write config.fish"
fi
if [ -f "$HOME/.zprofile" ] || [ -f "$HOME/.profile" ]; then
    fail_msg "fish setup wrote posix login profiles"
else
    pass_msg "fish setup does not write posix login profiles"
fi

# --- --no-shell does not write rc or login files ---
new_home
export SHELL=/bin/zsh
SHELL_SETUP=0
if configure_shell_startup "$HOME/.local/share/festival/shell"; then
    fail_msg "--no-shell configure_shell_startup should fail"
else
    pass_msg "--no-shell skips shell setup"
fi
if [ -e "$HOME/.zshrc" ] || [ -e "$HOME/.zprofile" ]; then
    fail_msg "--no-shell wrote shell files"
else
    pass_msg "--no-shell writes no shell files"
fi

if [ "$fail" -ne 0 ]; then
    echo "install.sh login-path tests FAILED" >&2
    exit 1
fi
echo "install.sh login-path tests passed"
