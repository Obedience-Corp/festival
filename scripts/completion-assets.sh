#!/usr/bin/env bash
# Derive packaged completion filenames and goreleaser snippets from
# scripts/completion-clis.txt. Source this file or run:
#   scripts/completion-assets.sh names
#   scripts/completion-assets.sh nfpm
#   scripts/completion-assets.sh aur
#   scripts/completion-assets.sh brew-stanza
#   scripts/completion-assets.sh brew-install
#   scripts/completion-assets.sh brew-uninstall
#   scripts/completion-assets.sh apply-goreleaser [--print]
set -euo pipefail

_completion_assets_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_completion_assets_root="$(cd "${_completion_assets_dir}/.." && pwd)"

completion_clis_file() {
    printf '%s\n' "${COMPLETION_CLIS_FILE:-${_completion_assets_dir}/completion-clis.txt}"
}

completion_asset_rows() {
    grep -v '^[[:space:]]*#' "$(completion_clis_file)" | grep -v '^[[:space:]]*$' || true
}

completion_cli_names() {
    completion_asset_rows | awk '{print $1}'
}

completion_src_names_for() {
    local name="$1"
    printf '%s\n' "${name}.bash" "_${name}" "${name}.fish"
}

completion_src_names() {
    local name
    while read -r name _; do
        completion_src_names_for "$name"
    done < <(completion_asset_rows)
}

completion_first_cli() {
    local name=""
    while read -r name; do
        printf '%s\n' "$name"
        break
    done < <(completion_cli_names)
}

completion_extra_cli_names() {
    local i=0
    local name
    while read -r name; do
        i=$((i + 1))
        if [ "$i" -gt 1 ]; then
            printf '%s\n' "$name"
        fi
    done < <(completion_cli_names)
}

# Marker strings must match .goreleaser.yaml.
COMPLETION_MARK_NFPM_BEGIN='# BEGIN GENERATED NFPM COMPLETIONS'
COMPLETION_MARK_NFPM_END='# END GENERATED NFPM COMPLETIONS'
COMPLETION_MARK_AUR_BEGIN='# BEGIN GENERATED AUR COMPLETIONS'
COMPLETION_MARK_AUR_END='# END GENERATED AUR COMPLETIONS'
COMPLETION_MARK_BREW_STANZA_BEGIN='# BEGIN GENERATED HOMEBREW COMPLETIONS STANZA'
COMPLETION_MARK_BREW_STANZA_END='# END GENERATED HOMEBREW COMPLETIONS STANZA'
COMPLETION_MARK_BREW_INSTALL_BEGIN='# BEGIN GENERATED HOMEBREW EXTRA COMPLETION INSTALL'
COMPLETION_MARK_BREW_INSTALL_END='# END GENERATED HOMEBREW EXTRA COMPLETION INSTALL'
COMPLETION_MARK_BREW_UNINSTALL_BEGIN='# BEGIN GENERATED HOMEBREW EXTRA COMPLETION UNINSTALL'
COMPLETION_MARK_BREW_UNINSTALL_END='# END GENERATED HOMEBREW EXTRA COMPLETION UNINSTALL'

render_nfpm() {
    local name
    while read -r name _; do
        printf '      - src: ./completions/%s.bash\n' "$name"
        printf '        dst: /usr/share/bash-completion/completions/%s\n' "$name"
        printf '      - src: ./completions/_%s\n' "$name"
        printf '        dst: /usr/share/zsh/vendor-completions/_%s\n' "$name"
        printf '      - src: ./completions/%s.fish\n' "$name"
        printf '        dst: /usr/share/fish/vendor_completions.d/%s.fish\n' "$name"
    done < <(completion_asset_rows)
}

render_aur() {
    local name
    while read -r name _; do
        printf '      install -Dm644 "./completions/%s.bash" "${pkgdir}/usr/share/bash-completion/completions/%s"\n' "$name" "$name"
        printf '      install -Dm644 "./completions/_%s" "${pkgdir}/usr/share/zsh/site-functions/_%s"\n' "$name" "$name"
        printf '      install -Dm644 "./completions/%s.fish" "${pkgdir}/usr/share/fish/vendor_completions.d/%s.fish"\n' "$name" "$name"
    done < <(completion_asset_rows)
}

render_brew_stanza() {
    local name
    name="$(completion_first_cli)"
    printf '    completions:\n'
    printf '      bash: completions/%s.bash\n' "$name"
    printf '      zsh: completions/_%s\n' "$name"
    printf '      fish: completions/%s.fish\n' "$name"
}

render_brew_install() {
    local name
    while read -r name; do
        [ -n "$name" ] || continue
        printf '          system_command "/bin/cp", args: ["#{staged_path}/completions/%s.bash", "#{HOMEBREW_PREFIX}/etc/bash_completion.d/%s"]\n' "$name" "$name"
        printf '          system_command "/bin/cp", args: ["#{staged_path}/completions/_%s", "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_%s"]\n' "$name" "$name"
        printf '          system_command "/bin/cp", args: ["#{staged_path}/completions/%s.fish", "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/%s.fish"]\n' "$name" "$name"
    done < <(completion_extra_cli_names)
}

render_brew_uninstall() {
    local name
    while read -r name; do
        [ -n "$name" ] || continue
        printf '            "#{HOMEBREW_PREFIX}/etc/bash_completion.d/%s",\n' "$name"
        printf '            "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_%s",\n' "$name"
        printf '            "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/%s.fish",\n' "$name"
    done < <(completion_extra_cli_names)
}

# Capture generator stdout and restore the trailing newline that command
# substitution strips.
_capture_render() {
    local inner
    inner="$("$@")"
    printf '%s\n' "$inner"
}

replace_region() {
    local begin="$1"
    local end="$2"
    local inner="$3"
    local in_region=0
    local found_begin=0
    local found_end=0
    local line

    case "$inner" in
        *$'\n') ;;
        *) inner="${inner}"$'\n' ;;
    esac

    while IFS= read -r line || [ -n "$line" ]; do
        if [ "$in_region" -eq 0 ] && [[ "$line" == *"$begin"* ]]; then
            printf '%s\n' "$line"
            printf '%s' "$inner"
            in_region=1
            found_begin=1
            continue
        fi
        if [ "$in_region" -eq 1 ] && [[ "$line" == *"$end"* ]]; then
            printf '%s\n' "$line"
            in_region=0
            found_end=1
            continue
        fi
        if [ "$in_region" -eq 1 ]; then
            continue
        fi
        printf '%s\n' "$line"
    done

    if [ "$found_begin" -ne 1 ] || [ "$found_end" -ne 1 ]; then
        echo "missing region markers: ${begin} / ${end}" >&2
        return 1
    fi
}

apply_goreleaser_text() {
    local text="$1"
    local inner

    inner="$(_capture_render render_nfpm)"
    text="$(printf '%s' "$text" | replace_region "$COMPLETION_MARK_NFPM_BEGIN" "$COMPLETION_MARK_NFPM_END" "$inner")"

    inner="$(_capture_render render_aur)"
    text="$(printf '%s' "$text" | replace_region "$COMPLETION_MARK_AUR_BEGIN" "$COMPLETION_MARK_AUR_END" "$inner")"

    inner="$(_capture_render render_brew_stanza)"
    text="$(printf '%s' "$text" | replace_region "$COMPLETION_MARK_BREW_STANZA_BEGIN" "$COMPLETION_MARK_BREW_STANZA_END" "$inner")"

    inner="$(_capture_render render_brew_install)"
    text="$(printf '%s' "$text" | replace_region "$COMPLETION_MARK_BREW_INSTALL_BEGIN" "$COMPLETION_MARK_BREW_INSTALL_END" "$inner")"

    inner="$(_capture_render render_brew_uninstall)"
    text="$(printf '%s' "$text" | replace_region "$COMPLETION_MARK_BREW_UNINSTALL_BEGIN" "$COMPLETION_MARK_BREW_UNINSTALL_END" "$inner")"

    printf '%s' "$text"
}

apply_goreleaser() {
    local file="${_completion_assets_root}/.goreleaser.yaml"
    local print_only=0
    local original rewritten

    if [ "${1:-}" = "--print" ]; then
        print_only=1
    fi

    original="$(cat "$file")"
    rewritten="$(apply_goreleaser_text "$original")"

    if [ "$print_only" -eq 1 ]; then
        printf '%s' "$rewritten"
        return 0
    fi

    if [ "$rewritten" = "$original" ]; then
        echo "already up to date: $file"
        return 0
    fi

    printf '%s' "$rewritten" > "$file"
    echo "updated: $file"
}

extract_region() {
    local begin="$1"
    local end="$2"
    local in_region=0
    local line

    while IFS= read -r line || [ -n "$line" ]; do
        if [ "$in_region" -eq 0 ] && [[ "$line" == *"$begin"* ]]; then
            in_region=1
            continue
        fi
        if [ "$in_region" -eq 1 ] && [[ "$line" == *"$end"* ]]; then
            in_region=0
            continue
        fi
        if [ "$in_region" -eq 1 ]; then
            printf '%s\n' "$line"
        fi
    done
}

completion_assets_usage() {
    cat <<'EOF'
Usage: scripts/completion-assets.sh <command>

Commands:
  names              List generated completion filenames
  clis               List CLI names
  nfpm               Print generated nfpm contents entries
  aur                Print generated AUR install lines
  brew-stanza        Print the Homebrew completions stanza (first CLI)
  brew-install       Print extra Homebrew post-install copies
  brew-uninstall     Print extra Homebrew uninstall paths
  apply-goreleaser   Rewrite generated regions in .goreleaser.yaml
                     Pass --print to write the result to stdout
EOF
}

completion_assets_main() {
    local cmd="${1:-}"
    shift || true

    case "$cmd" in
        names) completion_src_names ;;
        clis) completion_cli_names ;;
        nfpm) render_nfpm ;;
        aur) render_aur ;;
        brew-stanza) render_brew_stanza ;;
        brew-install) render_brew_install ;;
        brew-uninstall) render_brew_uninstall ;;
        apply-goreleaser) apply_goreleaser "${1:-}" ;;
        -h|--help|help|"") completion_assets_usage ;;
        *)
            echo "unknown command: $cmd" >&2
            completion_assets_usage >&2
            return 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    completion_assets_main "$@"
fi
