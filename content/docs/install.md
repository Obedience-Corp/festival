---
title: "Install Festival"
---

<p id="detected-os"><em>Detecting your operating system...</em></p>

<div id="install-macos" class="install-platform" style="display:none">

## macOS

The fastest way to install:

```bash
brew install --cask Obedience-Corp/tap/festival
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

Stable Windows packages are temporarily paused while Windows support is being hardened.

For now, use WSL2 and the Linux install methods from this page.

Scoop and direct `.zip` downloads will return once Windows support is marked stable.

</div>

<div id="install-other" class="install-platform" style="display:none">

## Download

<a href="https://github.com/Obedience-Corp/festival/releases/latest" class="btn btn--primary">View All Releases</a>

</div>

---

<details>
<summary>Show all platforms and methods</summary>

See the [full installation guide]({{< ref "/docs/getting-started/installation" >}}) for every platform, package manager, and installation method.
After installing, use the [quick start guide]({{< ref "/docs/getting-started/quickstart" >}}) for the validated beginner path through first `fest next`.

</details>

<script src='{{< static-url "/js/install-detect.js" >}}'></script>
