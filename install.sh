#!/usr/bin/env bash
set -euo pipefail

# Festival Methodology CLI Installer
# Installs fest, camp, and festival binaries

REPO="Obedience-Corp/festival"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"
SHELL_SETUP="${FESTIVAL_INSTALL_SHELL:-auto}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }
warning() { echo -e "${YELLOW}Warning:${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1" >&2; exit 1; }

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

usage() {
    cat <<'EOF'
Festival installer

Usage:
  install.sh [--setup-shell|--no-shell]

Environment:
  VERSION                    Release tag to install, or "latest" (default: latest)
  INSTALL_DIR                Binary install directory (default: ~/.local/bin)
  FESTIVAL_INSTALL_SHELL     auto, 1, or 0 (default: auto)

Shell setup:
  --setup-shell              Add a guarded source block to the detected shell rc file
  --no-shell                 Install binaries and helper files only
EOF
}

parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --setup-shell)
                SHELL_SETUP=1
                ;;
            --no-shell)
                SHELL_SETUP=0
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                error "Unknown argument: $1"
                ;;
        esac
        shift
    done
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "macOS" ;;
        *)       error "Unsupported OS: $(uname -s)" ;;
    esac
}

# Detect architecture
detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)  echo "x86_64" ;;
        arm64|aarch64) echo "arm64" ;;
        *)             error "Unsupported architecture: $(uname -m)" ;;
    esac
}

# Get latest release version
get_release_metadata() {
    local version="${1:-latest}"
    local endpoint="releases/latest"

    if [ "$version" != "latest" ]; then
        endpoint="releases/tags/${version}"
    fi

    curl -fsSL "https://api.github.com/repos/${REPO}/${endpoint}"
}

extract_tag_name() {
    printf '%s\n' "$1" \
        | grep '"tag_name"' \
        | head -n1 \
        | sed -E 's/.*"([^"]+)".*/\1/'
}

extract_asset_urls() {
    printf '%s\n' "$1" \
        | grep '"browser_download_url"' \
        | sed -E 's/.*"([^"]+)".*/\1/'
}

os_asset_aliases() {
    case "$1" in
        macOS) echo "macOS darwin" ;;
        linux) echo "linux Linux" ;;
        *) echo "$1" ;;
    esac
}

arch_asset_aliases() {
    case "$1" in
        x86_64) echo "x86_64 amd64" ;;
        arm64) echo "arm64 aarch64" ;;
        i386) echo "i386 386" ;;
        *) echo "$1" ;;
    esac
}

find_matching_archive_url() {
    local release_metadata="$1"
    local os="$2"
    local arch="$3"
    local urls url base
    local os_aliases arch_aliases os_alias arch_alias

    urls="$(extract_asset_urls "$release_metadata" | grep '\.tar\.gz$' || true)"
    if [ -z "$urls" ]; then
        return 1
    fi

    os_aliases="$(os_asset_aliases "$os")"
    arch_aliases="$(arch_asset_aliases "$arch")"

    for os_alias in $os_aliases; do
        for arch_alias in $arch_aliases; do
            while IFS= read -r url; do
                base="${url##*/}"
                if [[ "$base" == *"-${os_alias}-${arch_alias}.tar.gz" ]]; then
                    printf '%s\n' "$url"
                    return 0
                fi
            done <<< "$urls"
        done
    done

    for os_alias in $os_aliases; do
        while IFS= read -r url; do
            base="${url##*/}"
            if [[ "$base" == *"-${os_alias}-all.tar.gz" ]]; then
                printf '%s\n' "$url"
                return 0
            fi
        done <<< "$urls"
    done

    for os_alias in $os_aliases; do
        for arch_alias in $arch_aliases; do
            while IFS= read -r url; do
                base="${url##*/}"
                if [[ "$base" == *"${os_alias}"* && "$base" == *"${arch_alias}"* && "$base" == *.tar.gz ]]; then
                    printf '%s\n' "$url"
                    return 0
                fi
            done <<< "$urls"
        done
    done

    for os_alias in $os_aliases; do
        while IFS= read -r url; do
            base="${url##*/}"
            if [[ "$base" == *"${os_alias}"* && "$base" == *.tar.gz ]]; then
                printf '%s\n' "$url"
                return 0
            fi
        done <<< "$urls"
    done

    return 1
}

find_asset_url_by_name() {
    local release_metadata="$1"
    local name="$2"
    local url base

    while IFS= read -r url; do
        base="${url##*/}"
        if [ "$base" = "$name" ]; then
            printf '%s\n' "$url"
            return 0
        fi
    done <<< "$(extract_asset_urls "$release_metadata")"

    return 1
}

sha256_tool() {
    if command_exists sha256sum; then
        echo "sha256sum"
    elif command_exists shasum; then
        echo "shasum -a 256"
    else
        return 1
    fi
}

verify_archive_checksum() {
    local version="$1"
    local release_metadata="$2"
    local archive_name="$3"
    local archive_path="$4"
    local checksums_url checksums_file sha_tool expected actual

    sha_tool="$(sha256_tool)" || \
        error "Neither sha256sum nor shasum is available to verify the downloaded archive. Install one and re-run this installer."

    checksums_url="$(find_asset_url_by_name "$release_metadata" "checksums.txt")" || \
        error "checksums.txt was not found in the release assets for ${version}. Refusing to install an unverified archive."

    checksums_file="$(dirname "$archive_path")/checksums.txt"
    info "Verifying checksum..."
    if ! curl -fsSL "$checksums_url" -o "$checksums_file"; then
        error "Failed to download checksums.txt for ${version}. Refusing to install an unverified archive."
    fi

    expected="$(awk -v name="$archive_name" '$2 == name { print $1; exit }' "$checksums_file")"
    if [ -z "$expected" ]; then
        error "No checksum entry for ${archive_name} in checksums.txt. Refusing to install an unverified or malformed archive."
    fi

    actual="$($sha_tool "$archive_path" | awk '{print $1}')"
    if [ "$expected" != "$actual" ]; then
        error "Checksum mismatch for ${archive_name}.\n  expected: ${expected}\n  actual:   ${actual}\nRefusing to install a corrupted or tampered archive."
    fi

    success "Checksum verified for ${archive_name}"
}

install_hint() {
    local dep="$1"

    case "$(uname -s)" in
        Darwin*)
            if command_exists brew; then
                echo "brew install ${dep}"
            elif [ "$dep" = "git" ]; then
                echo "xcode-select --install  # or install Homebrew, then brew install git"
            else
                echo "install Homebrew, then run: brew install ${dep}"
            fi
            ;;
        Linux*)
            if command_exists apt-get; then
                echo "sudo apt-get update && sudo apt-get install -y ${dep}"
            elif command_exists dnf; then
                echo "sudo dnf install -y ${dep}"
            elif command_exists yum; then
                echo "sudo yum install -y ${dep}"
            elif command_exists pacman; then
                echo "sudo pacman -S --needed ${dep}"
            elif command_exists apk; then
                echo "sudo apk add ${dep}"
            elif command_exists zypper; then
                echo "sudo zypper install -y ${dep}"
            else
                echo "install '${dep}' with your system package manager"
            fi
            ;;
        *)
            echo "install '${dep}' and re-run this installer"
            ;;
    esac
}

require_git() {
    if command_exists git; then
        return 0
    fi

    error "Git is required for Festival. Camp and fest use git internally for campaign init, project management, template sync, and commit-aware workflows.\nInstall git first, then re-run this installer:\n  $(install_hint git)"
}

warn_optional_scc() {
    if command_exists scc; then
        success "scc detected ($(scc --version 2>/dev/null | head -n1 || echo installed))"
        return 0
    fi

    warning "Recommended dependency missing: scc"
    echo "  camp leverage features use scc for code statistics and effort estimates."
    echo "  Festival will still work without it."
    echo "  To add it later, run:"
    echo "    $(install_hint scc)"
}

install_prefix() {
    local install_dir
    install_dir="${INSTALL_DIR%/}"
    case "$install_dir" in
        */bin) echo "${install_dir%/bin}" ;;
        *) dirname "$install_dir" ;;
    esac
}

shell_helper_dir() {
    echo "$(install_prefix)/share/festival/shell"
}

completion_asset_dir() {
    echo "$(install_prefix)/share/festival/completions"
}

install_completion_assets() {
    local tmp_dir="$1"
    local completions_dir="$2"

    if [ ! -d "${tmp_dir}/completions" ]; then
        warning "Completion files were not found in the release archive"
        return 1
    fi

    mkdir -p "$completions_dir"
    cp "${tmp_dir}/completions/fest.bash" "$completions_dir/fest.bash"
    cp "${tmp_dir}/completions/_fest" "$completions_dir/_fest"
    cp "${tmp_dir}/completions/fest.fish" "$completions_dir/fest.fish"
    cp "${tmp_dir}/completions/camp.bash" "$completions_dir/camp.bash"
    cp "${tmp_dir}/completions/_camp" "$completions_dir/_camp"
    cp "${tmp_dir}/completions/camp.fish" "$completions_dir/camp.fish"
    cp "${tmp_dir}/completions/festival.bash" "$completions_dir/festival.bash"
    cp "${tmp_dir}/completions/_festival" "$completions_dir/_festival"
    cp "${tmp_dir}/completions/festival.fish" "$completions_dir/festival.fish"
    success "Installed completion files to ${completions_dir}"
}

install_shell_helpers() {
    local tmp_dir="$1"
    local helper_dir="$2"

    if [ ! -d "${tmp_dir}/shell" ]; then
        warning "Shell helper files were not found in the release archive"
        return 1
    fi

    mkdir -p "$helper_dir"
    cp "${tmp_dir}/shell/festival.bash" "$helper_dir/festival.bash"
    cp "${tmp_dir}/shell/festival.zsh" "$helper_dir/festival.zsh"
    cp "${tmp_dir}/shell/festival.fish" "$helper_dir/festival.fish"
    success "Installed shell helper files to ${helper_dir}"
}

detected_shell() {
    basename "${SHELL:-}" 2>/dev/null || true
}

shell_rc_file() {
    case "$1" in
        zsh) echo "${ZDOTDIR:-$HOME}/.zshrc" ;;
        bash) echo "$HOME/.bashrc" ;;
        fish) echo "$HOME/.config/fish/config.fish" ;;
        *) return 1 ;;
    esac
}

should_setup_shell() {
    local rc_file="$1"
    local reply

    case "$SHELL_SETUP" in
        1|true|TRUE|yes|YES|y|Y)
            return 0
            ;;
        0|false|FALSE|no|NO|n|N)
            return 1
            ;;
        auto|"")
            if [ -r /dev/tty ] && [ -w /dev/tty ]; then
                printf "Add Festival shell helpers to %s? [Y/n] " "$rc_file" > /dev/tty
                IFS= read -r reply < /dev/tty || reply=""
                case "$reply" in
                    n|N|no|NO)
                        return 1
                        ;;
                    *)
                        return 0
                        ;;
                esac
            fi
            return 1
            ;;
        *)
            warning "Ignoring unknown FESTIVAL_INSTALL_SHELL value: ${SHELL_SETUP}"
            return 1
            ;;
    esac
}

append_shell_block() {
    local shell_name="$1"
    local rc_file="$2"
    local helper_dir="$3"

    mkdir -p "$(dirname "$rc_file")"
    touch "$rc_file"

    if grep -Fq ">>> festival shell integration >>>" "$rc_file"; then
        success "Shell helpers already configured in ${rc_file}"
        return 0
    fi

    {
        echo ""
        echo "# >>> festival shell integration >>>"
        echo "# Added by the Festival installer. Remove this block to disable cgo/fgo helpers."
        case "$shell_name" in
            bash)
                echo "case \":\$PATH:\" in"
                echo "  *\":${INSTALL_DIR}:\"*) ;;"
                echo "  *) export PATH=\"${INSTALL_DIR}:\$PATH\" ;;"
                echo "esac"
                echo "source \"${helper_dir}/festival.bash\""
                ;;
            zsh)
                echo "case \":\$PATH:\" in"
                echo "  *\":${INSTALL_DIR}:\"*) ;;"
                echo "  *) export PATH=\"${INSTALL_DIR}:\$PATH\" ;;"
                echo "esac"
                echo "source \"${helper_dir}/festival.zsh\""
                ;;
            fish)
                echo "if not contains \"${INSTALL_DIR}\" \$PATH"
                echo "    set -gx PATH \"${INSTALL_DIR}\" \$PATH"
                echo "end"
                echo "source \"${helper_dir}/festival.fish\""
                ;;
        esac
        echo "# <<< festival shell integration <<<"
    } >> "$rc_file"

    success "Added shell helpers to ${rc_file}"
}

configure_shell_startup() {
    local helper_dir="$1"
    local shell_name rc_file

    shell_name="$(detected_shell)"
    if [ -z "$shell_name" ] || ! rc_file="$(shell_rc_file "$shell_name")"; then
        warning "Could not detect a supported shell for automatic helper setup"
        return 1
    fi

    if should_setup_shell "$rc_file"; then
        append_shell_block "$shell_name" "$rc_file" "$helper_dir"
        return 0
    fi

    return 1
}

print_shell_setup_hint() {
    local helper_dir="$1"

    echo ""
    info "To enable shell integration manually, add the line for your shell:"
    echo ""
    echo "  # bash (~/.bashrc)"
    echo "  source \"${helper_dir}/festival.bash\""
    echo ""
    echo "  # zsh (~/.zshrc)"
    echo "  source \"${helper_dir}/festival.zsh\""
    echo ""
    echo "  # fish (~/.config/fish/config.fish)"
    echo "  source \"${helper_dir}/festival.fish\""
    echo ""
    echo "  # dash, busybox ash, other POSIX sh (~/.profile)"
    echo "  eval \"\$(camp shell-init sh)\""
    echo "  eval \"\$(fest shell-init sh)\""
}

main() {
    local os arch version archive_name download_url release_metadata tmp_dir="" helper_dir completions_dir shell_configured=0

    require_git

    os=$(detect_os)
    arch=$(detect_arch)

    info "Detected: ${os} ${arch}"

    # Resolve version
    if [ "$VERSION" = "latest" ]; then
        info "Fetching latest version..."
        release_metadata=$(get_release_metadata latest)
        version=$(extract_tag_name "$release_metadata")
        if [ -z "$version" ]; then
            error "Could not determine latest version. Check https://github.com/${REPO}/releases"
        fi
    else
        version="v${VERSION#v}"
        release_metadata=$(get_release_metadata "$version") || \
            error "Could not determine release metadata for ${version}. Check https://github.com/${REPO}/releases"
    fi

    info "Installing Festival ${version}"

    download_url="$(find_matching_archive_url "$release_metadata" "$os" "$arch")" || \
        error "Could not find a compatible archive for ${version} (${os} ${arch}). Check https://github.com/${REPO}/releases"
    archive_name="${download_url##*/}"

    # Download and extract
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "${tmp_dir:-}"' EXIT

    info "Downloading ${archive_name}..."
    if ! curl -fsSL "$download_url" -o "${tmp_dir}/archive.tar.gz"; then
        error "Download failed. Check that ${version} exists at https://github.com/${REPO}/releases"
    fi

    verify_archive_checksum "$version" "$release_metadata" "$archive_name" "${tmp_dir}/archive.tar.gz"

    info "Extracting..."
    tar -xzf "${tmp_dir}/archive.tar.gz" -C "$tmp_dir"

    # Install binaries
    mkdir -p "$INSTALL_DIR"

    for binary in fest camp festival; do
        if [ -f "${tmp_dir}/${binary}" ]; then
            cp "${tmp_dir}/${binary}" "${INSTALL_DIR}/${binary}"
            chmod +x "${INSTALL_DIR}/${binary}"
        else
            error "Binary '${binary}' not found in archive"
        fi
    done

    success "Installed fest, camp, and festival to ${INSTALL_DIR}"

    helper_dir="$(shell_helper_dir)"
    completions_dir="$(completion_asset_dir)"
    install_completion_assets "$tmp_dir" "$completions_dir" || true
    install_shell_helpers "$tmp_dir" "$helper_dir" || true

    # Verify
    if command -v fest &>/dev/null; then
        success "fest $(fest --version 2>/dev/null || echo 'installed')"
    fi
    if command -v camp &>/dev/null; then
        success "camp $(camp --version 2>/dev/null || echo 'installed')"
    fi
    if command -v festival &>/dev/null; then
        success "festival $(festival version 2>/dev/null || echo 'installed')"
    fi

    echo ""
    warn_optional_scc

    # Check PATH
    if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
        echo ""
        info "Add ${INSTALL_DIR} to your PATH:"
        echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    fi

    if configure_shell_startup "$helper_dir"; then
        shell_configured=1
        echo ""
        info "Restart your shell or source your shell config to use cgo/fgo helpers."
    fi

    if [ "$shell_configured" -eq 0 ]; then
        print_shell_setup_hint "$helper_dir"
        echo ""
    fi

    success "Installation complete"
}

parse_args "$@"
main "$@"
