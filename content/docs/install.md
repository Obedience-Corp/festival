---
title: "Install Festival"
---

<p id="detected-os"><em>Detecting your operating system...</em></p>

<div id="install-macos" class="install-platform" style="display:none">

## macOS

The fastest way to install:

```bash
brew install Obedience-Corp/tap/festival
```

Or download the latest macOS release directly:

<a href="https://github.com/Obedience-Corp/festival/releases/latest" class="btn btn--primary">Download for macOS</a>

</div>

<div id="install-linux" class="install-platform" style="display:none">

## Linux

Choose your distribution's package format:

| Distribution | Command |
|-------------|---------|
| Debian / Ubuntu | `sudo dpkg -i festival_*_amd64.deb` |
| Fedora / RHEL | `sudo rpm -i festival-*.x86_64.rpm` |
| Arch Linux | `yay -S festival-bin` |
| Alpine | `sudo apk add --allow-untrusted festival_*.apk` |

<a href="https://github.com/Obedience-Corp/festival/releases/latest" class="btn btn--primary">Download Linux Packages</a>

</div>

<div id="install-windows" class="install-platform" style="display:none">

## Windows

Install with Scoop:

```powershell
scoop bucket add obey https://github.com/Obedience-Corp/scoop-bucket
scoop install festival
```

Or download the `.zip` directly:

<a href="https://github.com/Obedience-Corp/festival/releases/latest" class="btn btn--primary">Download for Windows</a>

</div>

<div id="install-other" class="install-platform" style="display:none">

## Download

<a href="https://github.com/Obedience-Corp/festival/releases/latest" class="btn btn--primary">View All Releases</a>

</div>

---

<details>
<summary>Show all platforms and methods</summary>

See the [full installation guide]({{< ref "/docs/getting-started/installation" >}}) for every platform, package manager, and installation method.

</details>

<script src="/js/install-detect.js"></script>
