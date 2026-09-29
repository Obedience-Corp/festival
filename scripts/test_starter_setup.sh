#!/usr/bin/env bash
# Run in a container: exercises install entry points without network or user data.
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source "$repo_root/install.sh"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
INSTALL_DIR="$fixture/bin"
mkdir -p "$INSTALL_DIR"
cat > "$INSTALL_DIR/camp" <<'CAMP'
#!/bin/sh
[ "$1" = setup ] || exit 2
[ -z "${CAMP_ROOT:-}" ] || exit 3
printf 'called\n' >> "$STARTER_CALLS"
CAMP
chmod +x "$INSTALL_DIR/camp"
export STARTER_CALLS="$fixture/calls"
export CAMP_ROOT=/wrong-camp
# Root package hooks must defer; a user install calls the installed Camp.
id() { echo 0; }
setup_starter_camp
[ ! -f "$STARTER_CALLS" ]
id() { echo 1000; }
setup_starter_camp
[ "$(cat "$STARTER_CALLS")" = called ]
# A failed starter step must preserve the successful install exit status.
printf '#!/bin/sh\nexit 1\n' > "$INSTALL_DIR/camp"
setup_starter_camp

# npm postinstall shares the same contract; its ordinary binary wrapper must
# not run setup for help/version or lazy recovery.
cp -R "$repo_root/npm" "$fixture/npm"
node - "$fixture/npm" <<'JS'
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
const installer = require(path.join(root, 'install.js'));
for (const name of installer.BINARIES) {
 fs.writeFileSync(installer.binaryPath(name), '#!/bin/sh\nprintf "%s\\n" "$*" >> "$STARTER_CALLS"\n', {mode:0o755});
}
for (const [dir, name] of installer.REQUIRED_ASSET_FILES) {
 const dest = path.join(root, 'share/festival', dir, name);
 fs.mkdirSync(path.dirname(dest), {recursive:true}); fs.writeFileSync(dest, 'fixture');
}
JS
: > "$STARTER_CALLS"
node "$fixture/npm/install.js"
[ ! -s "$STARTER_CALLS" ] # container root: defer
printf 'process.getuid = () => 1000;\n' > "$fixture/user.cjs"
node --require "$fixture/user.cjs" "$fixture/npm/install.js"
[ "$(cat "$STARTER_CALLS")" = setup ]
: > "$STARTER_CALLS"
node "$fixture/npm/bin/camp" --help
[ "$(cat "$STARTER_CALLS")" = --help ]
printf 'starter install entry points: PASS\n'
