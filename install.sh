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
NC='\033[0m'

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1" >&2; exit 1; }

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
get_latest_version() {
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
        | grep '"tag_name"' \
        | sed -E 's/.*"([^"]+)".*/\1/'
}

main() {
    local os arch version archive_name download_url tmp_dir

    os=$(detect_os)
    arch=$(detect_arch)

    info "Detected: ${os} ${arch}"

    # Resolve version
    if [ "$VERSION" = "latest" ]; then
        info "Fetching latest version..."
        version=$(get_latest_version)
        if [ -z "$version" ]; then
            error "Could not determine latest version. Check https://github.com/${REPO}/releases"
        fi
    else
        version="v${VERSION#v}"
    fi

    info "Installing Festival ${version}"

    # Build archive name
    archive_name="festival-${version#v}-${os}-${arch}.tar.gz"
    download_url="https://github.com/${REPO}/releases/download/${version}/${archive_name}"

    # Download and extract
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

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
