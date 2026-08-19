#!/usr/bin/env bash
# Ensures fest and camp are installed and up-to-date. Runs on SessionStart.
# - If missing: downloads and installs from GitHub releases with checksum verification.
# - If installed: checks for newer version and offers update notification.

set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO="Obedience-Corp/festival"
CACHE_DIR="${FESTIVAL_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/festival}"
CHECK_FILE="${FESTIVAL_CHECK_FILE:-$CACHE_DIR/last-update-check}"
DOWNLOAD_TIMEOUT_SECONDS="${FESTIVAL_DOWNLOAD_TIMEOUT_SECONDS:-120}"

info() {
    echo "$*" >&2
}

fail() {
    echo "$*" >&2
    exit 1
}

require_command() {
    local name="$1"
    command -v "$name" >/dev/null 2>&1 || fail "Required command not found: $name"
}

require_checksum_command() {
    if command -v shasum >/dev/null 2>&1 || command -v sha256sum >/dev/null 2>&1; then
        return 0
    fi

    fail "Required command not found: shasum or sha256sum"
}

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
    curl -fsSL --connect-timeout 10 --max-time "$DOWNLOAD_TIMEOUT_SECONDS" "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null
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

download_file() {
    local url="$1"
    local dest="$2"
    local tmp="${dest}.tmp"

    rm -f "$tmp"
    curl -fsSL --connect-timeout 10 --max-time "$DOWNLOAD_TIMEOUT_SECONDS" "$url" -o "$tmp" || {
        rm -f "$tmp"
        return 1
    }
    mv "$tmp" "$dest"
}

checksum_url_for_archive() {
    local archive_url="$1"
    echo "${archive_url%/*}/checksums.txt"
}

sha256_file() {
    local file="$1"

    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$file" | awk '{print $1}'
        return 0
    fi

    sha256sum "$file" | awk '{print $1}'
}

expected_checksum() {
    local checksums_file="$1"
    local archive_name="$2"

    awk -v name="$archive_name" '$2 == name {print $1; found=1} END {exit found ? 0 : 1}' "$checksums_file"
}

verify_checksum() {
    local archive_path="$1"
    local checksums_path="$2"
    local archive_name="$3"
    local expected actual

    expected="$(expected_checksum "$checksums_path" "$archive_name")" || {
        echo "Checksum for ${archive_name} not found in checksums.txt" >&2
        return 1
    }

    actual="$(sha256_file "$archive_path")"
    if [ "$actual" != "$expected" ]; then
        echo "Checksum mismatch for ${archive_name}" >&2
        echo "expected: ${expected}" >&2
        echo "actual:   ${actual}" >&2
        return 1
    fi
}

download_and_install() {
    local archive_url="$1"
    local archive_name checksums_url archive_path checksums_path

    archive_name="$(basename "$archive_url")"
    checksums_url="$(checksum_url_for_archive "$archive_url")"
    TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/festival-plugin.XXXXXX")
    trap 'rm -rf "$TMP_DIR"' EXIT
    archive_path="${TMP_DIR}/${archive_name}"
    checksums_path="${TMP_DIR}/checksums.txt"

    download_file "$archive_url" "$archive_path" ||
        fail "Download failed. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"

    download_file "$checksums_url" "$checksums_path" ||
        fail "Checksum download failed. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"

    verify_checksum "$archive_path" "$checksums_path" "$archive_name" ||
        fail "Checksum verification failed. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"

    tar -xzf "$archive_path" -C "$TMP_DIR"

    mkdir -p "$INSTALL_DIR"
    for binary in fest camp; do
        extracted_path="$(find "$TMP_DIR" -type f -name "$binary" | head -1)"
        if [ -n "$extracted_path" ]; then
            install -m 0755 "$extracted_path" "${INSTALL_DIR}/${binary}"
        else
            fail "${binary} not found in ${archive_name}"
        fi
    done
}

# --- Main ---

require_command curl
require_command tar
require_command grep
require_command sed
require_command awk
require_command find
require_command install
require_checksum_command
detect_platform

if ! check_installed; then
    # Fresh install
    info "Festival CLI not found. Installing fest and camp..."

    RELEASE_JSON=$(fetch_release) || {
        info "Could not fetch release info. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"
        exit 1
    }

    ARCHIVE_URL=$(find_archive_url "$RELEASE_JSON")
    if [ -z "$ARCHIVE_URL" ]; then
        info "No compatible archive found for ${OS}/${ARCH}. Install manually: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"
        exit 1
    fi

    download_and_install "$ARCHIVE_URL"
    record_check

    if command -v fest >/dev/null 2>&1; then
        info "Festival installed successfully: $(fest version 2>/dev/null || echo 'fest ready')"
    else
        info "Installed to ${INSTALL_DIR}. You may need to add it to your PATH: export PATH=\"${INSTALL_DIR}:\$PATH\""
    fi
    exit 0
fi

# Already installed, check for updates (rate-limited to once/day)
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
    info "Festival update available: ${CURRENT_VERSION} -> ${LATEST_TAG}. Run: curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh | bash"
fi
