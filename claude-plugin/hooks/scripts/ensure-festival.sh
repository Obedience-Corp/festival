#!/usr/bin/env bash
# Ensures fest and camp are installed and up-to-date. Runs on SessionStart.
# - If missing: downloads and installs from GitHub releases.
# - If installed: checks for newer version and offers update notification.

set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO="Obedience-Corp/festival"
CHECK_FILE="${HOME}/.cache/festival/last-update-check"

check_installed() {
    command -v fest >/dev/null 2>&1 && command -v camp >/dev/null 2>&1
}

# Rate-limit update checks to once per day
should_check_update() {
    if [ ! -f "$CHECK_FILE" ]; then
        return 0
    fi
    local last_check
    last_check=$(cat "$CHECK_FILE" 2>/dev/null || echo 0)
    local now
    now=$(date +%s)
    local age=$(( now - last_check ))
    # 86400 = 24 hours
    [ "$age" -ge 86400 ]
}

record_check() {
    mkdir -p "$(dirname "$CHECK_FILE")"
    date +%s > "$CHECK_FILE"
}

detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$OS" in
        darwin) OS="macOS" ;;
        linux)  OS="linux" ;;
        *)      echo "Unsupported OS: $OS" >&2; exit 1 ;;
    esac

    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64|amd64)  ARCH="x86_64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *)             echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
    esac
}

fetch_release() {
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null
}

find_archive_url() {
    local release_json="$1"
    local url

    # Try exact OS-ARCH match first, then OS-all (universal binary, e.g. macOS-all)
    url=$(echo "$release_json" | grep '"browser_download_url"' | grep -i "${OS}" | grep -i "${ARCH}" | grep '\.tar\.gz"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$url" ]; then
        url=$(echo "$release_json" | grep '"browser_download_url"' | grep -i "${OS}" | grep -i "all" | grep '\.tar\.gz"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
    fi

    echo "$url"
}

extract_tag() {
    echo "$1" | grep '"tag_name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/'
}

download_and_install() {
    local archive_url="$1"

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    curl -fsSL "$archive_url" -o "${TMP_DIR}/archive.tar.gz" 2>/dev/null || {
        echo "Download failed. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash" >&2
        exit 1
    }

    tar -xzf "${TMP_DIR}/archive.tar.gz" -C "$TMP_DIR"

    mkdir -p "$INSTALL_DIR"
    for binary in fest camp; do
        if [ -f "${TMP_DIR}/${binary}" ]; then
            cp "${TMP_DIR}/${binary}" "${INSTALL_DIR}/${binary}"
            chmod +x "${INSTALL_DIR}/${binary}"
        fi
    done
}

# --- Main ---

detect_platform

if ! check_installed; then
    # Fresh install
    echo "Festival CLI not found. Installing fest and camp..." >&2

    RELEASE_JSON=$(fetch_release) || {
        echo "Could not fetch release info. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash" >&2
        exit 1
    }

    ARCHIVE_URL=$(find_archive_url "$RELEASE_JSON")
    if [ -z "$ARCHIVE_URL" ]; then
        echo "No compatible archive found for ${OS}/${ARCH}. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash" >&2
        exit 1
    fi

    download_and_install "$ARCHIVE_URL"
    record_check

    if command -v fest >/dev/null 2>&1; then
        echo "Festival installed successfully: $(fest version 2>/dev/null || echo 'fest ready')" >&2
    else
        echo "Installed to ${INSTALL_DIR}. You may need to add it to your PATH: export PATH=\"${INSTALL_DIR}:\$PATH\"" >&2
    fi
    exit 0
fi

# Already installed — check for updates (rate-limited to once/day)
if ! should_check_update; then
    exit 0
fi

CURRENT_VERSION=$(fest version 2>/dev/null | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "")
if [ -z "$CURRENT_VERSION" ]; then
    record_check
    exit 0
fi

RELEASE_JSON=$(fetch_release 2>/dev/null) || {
    record_check
    exit 0
}

LATEST_TAG=$(extract_tag "$RELEASE_JSON")
# Normalize: strip leading v for comparison
CURRENT_CLEAN="${CURRENT_VERSION#v}"
LATEST_CLEAN="${LATEST_TAG#v}"

record_check

if [ "$CURRENT_CLEAN" != "$LATEST_CLEAN" ]; then
    echo "Festival update available: ${CURRENT_VERSION} -> ${LATEST_TAG}. Run: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash" >&2
fi
