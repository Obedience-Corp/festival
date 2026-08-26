#!/bin/sh
# Post-install for obedience-festival (deb/rpm/apk). Echo-only: does not edit rc.
echo "Package: obedience-festival (binaries stay festival, camp, and fest)."
echo "This package is not the Edinburgh TTS package named festival; both ship /usr/bin/festival."
echo "This package does not edit your shell rc. Add the helper yourself:"
echo "  source /usr/share/festival/shell/festival.zsh"
echo "Upgrade: reinstall the latest obedience-festival_*.deb (or .rpm / .apk) from GitHub Releases."
echo "Do not run festival install (that plants a second copy under ~/.obey/installer)."
echo "If you still have an older GitHub .deb named festival: sudo dpkg -r festival"
echo "then install obedience-festival."
