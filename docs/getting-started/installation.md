# Installation

Festival includes two CLI tools: **fest** (festival planning) and **camp** (campaign management). All installation methods install both.

=== "macOS"

    ### Homebrew (Recommended)

    ```bash
    brew install Obedience-Corp/tap/festival
    ```

    ### Direct Download

    Download the latest `.tar.gz` for your Mac from
    [GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest),
    extract, and move to your PATH:

    ```bash
    tar xzf festival-*-macOS-*.tar.gz
    sudo mv fest camp /usr/local/bin/
    ```

=== "Linux"

    ### Debian / Ubuntu

    Download the `.deb` package from
    [GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest):

    ```bash
    sudo dpkg -i festival_*_amd64.deb
    ```

    ### Fedora / RHEL

    ```bash
    sudo rpm -i festival-*.x86_64.rpm
    ```

    ### Arch Linux (AUR)

    ```bash
    yay -S festival-bin
    ```

    ### Alpine

    ```bash
    sudo apk add --allow-untrusted festival_*.apk
    ```

    ### Direct Download

    ```bash
    tar xzf festival-*-linux-*.tar.gz
    sudo mv fest camp /usr/local/bin/
    ```

=== "Windows"

    ### Scoop (Recommended)

    ```powershell
    scoop bucket add obey https://github.com/Obedience-Corp/scoop-bucket
    scoop install festival
    ```

    ### Direct Download

    Download the `.zip` from
    [GitHub Releases](https://github.com/Obedience-Corp/festival/releases/latest),
    extract, and add the directory to your PATH.

## Other Methods

### Shell Script

A convenience script is available for macOS and Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

!!! note
    This downloads pre-built binaries to `~/.local/bin`.
    [Review the script source](https://github.com/Obedience-Corp/festival/blob/main/install.sh) before running.

### From Source

Requires Go 1.25+:

```bash
go install github.com/Obedience-Corp/fest/cmd/fest@latest
go install github.com/obediencecorp/camp/cmd/camp@latest
```

## Verify Installation

```bash
fest --version
camp --version
```

## Shell Integration

Enable navigation features by adding to your `~/.zshrc` or `~/.bashrc`:

```bash
eval "$(fest shell-init zsh)"
eval "$(camp shell-init zsh)"
```

See [Shell Setup](shell-setup.md) for details.
