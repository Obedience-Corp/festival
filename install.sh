#!/usr/bin/env bash
set -euo pipefail

# Festival Methodology CLI Installer
# Installs fest and camp binaries

REPO="Obedience-Corp/festival"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${VERSION:-latest}"

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

main() {
    local os arch version archive_name download_url release_metadata tmp_dir=""

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

    info "Extracting..."
    tar -xzf "${tmp_dir}/archive.tar.gz" -C "$tmp_dir"

    # Install binaries
    mkdir -p "$INSTALL_DIR"

    for binary in fest camp; do
        if [ -f "${tmp_dir}/${binary}" ]; then
            cp "${tmp_dir}/${binary}" "${INSTALL_DIR}/${binary}"
            chmod +x "${INSTALL_DIR}/${binary}"
        else
            error "Binary '${binary}' not found in archive"
        fi
    done

    success "Installed fest and camp to ${INSTALL_DIR}"

    # Verify
    if command -v fest &>/dev/null; then
        success "fest $(fest --version 2>/dev/null || echo 'installed')"
    fi
    if command -v camp &>/dev/null; then
        success "camp $(camp --version 2>/dev/null || echo 'installed')"
    fi

    echo ""
    warn_optional_scc

    # Check PATH
    if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
        echo ""
        info "Add ${INSTALL_DIR} to your PATH:"
        echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    fi

    # Shell integration
    echo ""
    info "To enable shell integration, add to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo "  eval \"\$(fest shell-init zsh)\""
    echo "  eval \"\$(camp shell-init zsh)\""
    echo ""
    success "Installation complete"
}

main "$@"
