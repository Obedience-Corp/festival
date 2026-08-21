#!/usr/bin/env bash
# Drift and derivation checks for packaged CLI completions.
# Pure string comparisons plus a node require of npm/install.js. Does not
# mutate the repo tree.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# shellcheck source=completion-assets.sh
source "$repo_root/scripts/completion-assets.sh"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "ok: $*"; }

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

need_cmd bash
need_cmd node
need_cmd diff

bash -n "$repo_root/scripts/completion-assets.sh" || fail "bash -n completion-assets.sh"
bash -n "$repo_root/scripts/completions.sh" || fail "bash -n completions.sh"
bash -n "$repo_root/install.sh" || fail "bash -n install.sh"
pass "bash -n on installer and completion scripts"

expected_names="$(printf '%s\n' fest.bash _fest fest.fish camp.bash _camp camp.fish festival.bash _festival festival.fish)"
actual_names="$(completion_src_names)"
if [ "$actual_names" != "$expected_names" ]; then
    echo "expected filenames:" >&2
    echo "$expected_names" >&2
    echo "actual filenames:" >&2
    echo "$actual_names" >&2
    fail "default completion filenames drifted from fest/camp/festival x bash/zsh/fish"
fi
pass "default list is the nine completion filenames"

extra_clis="$(printf '%s\n' \
    'fest fest ./cmd/fest' \
    'camp camp ./cmd/camp' \
    'festival festival-installer ./cmd/festival' \
    'extra extra ./cmd/extra')"
extra_names="$(COMPLETION_CLIS_FILE=<(printf '%s\n' "$extra_clis") completion_src_names)"
case "$extra_names" in
    *$'\n'extra.bash*$'\n'_extra*$'\n'extra.fish*) ;;
    *) fail "adding one CLI row did not derive extra.bash/_extra/extra.fish: $extra_names" ;;
esac
extra_nfpm="$(COMPLETION_CLIS_FILE=<(printf '%s\n' "$extra_clis") render_nfpm)"
case "$extra_nfpm" in
    *'src: ./completions/extra.bash'*'dst: /usr/share/bash-completion/completions/extra'*) ;;
    *) fail "adding one CLI row did not derive nfpm extra entries" ;;
esac
extra_brew="$(COMPLETION_CLIS_FILE=<(printf '%s\n' "$extra_clis") render_brew_install)"
case "$extra_brew" in
    *'completions/extra.bash'*) ;;
    *) fail "adding one CLI row did not derive Homebrew extra copies for extra" ;;
esac
pass "adding a CLI is one row in completion-clis.txt"

region_or_fail() {
    local begin="$1"
    local end="$2"
    local rendered="$3"
    local extracted
    extracted="$(extract_region "$begin" "$end" <"$repo_root/.goreleaser.yaml")"
    if [ "$extracted" != "$rendered" ]; then
        echo "--- generated ---" >&2
        printf '%s' "$rendered" >&2
        echo "--- .goreleaser.yaml region ---" >&2
        printf '%s' "$extracted" >&2
        fail "goreleaser region drifted (${begin}); run scripts/completion-assets.sh apply-goreleaser"
    fi
}

region_or_fail "$COMPLETION_MARK_NFPM_BEGIN" "$COMPLETION_MARK_NFPM_END" "$(_capture_render render_nfpm)"
region_or_fail "$COMPLETION_MARK_AUR_BEGIN" "$COMPLETION_MARK_AUR_END" "$(_capture_render render_aur)"
region_or_fail "$COMPLETION_MARK_BREW_STANZA_BEGIN" "$COMPLETION_MARK_BREW_STANZA_END" "$(_capture_render render_brew_stanza)"
region_or_fail "$COMPLETION_MARK_BREW_INSTALL_BEGIN" "$COMPLETION_MARK_BREW_INSTALL_END" "$(_capture_render render_brew_install)"
region_or_fail "$COMPLETION_MARK_BREW_UNINSTALL_BEGIN" "$COMPLETION_MARK_BREW_UNINSTALL_END" "$(_capture_render render_brew_uninstall)"
pass "goreleaser nfpm/AUR/Homebrew completion regions match the generator"

rewritten="$(apply_goreleaser --print)"
committed="$(cat "$repo_root/.goreleaser.yaml")"
if [ "$rewritten" != "$committed" ]; then
    diff -u <(printf '%s' "$committed") <(printf '%s' "$rewritten") >&2 || true
    fail "apply-goreleaser --print is not idempotent against committed .goreleaser.yaml"
fi
pass "apply-goreleaser is idempotent"

grep -q 'source .*completion-assets.sh' "$repo_root/scripts/completions.sh" \
    || fail "completions.sh must source completion-assets.sh"
grep -q 'completion_asset_rows' "$repo_root/scripts/completions.sh" \
    || fail "completions.sh must loop completion_asset_rows"
pass "completions.sh generates from the CLI list"

grep -Fq '"${binary}.bash"' "$repo_root/install.sh" \
    || fail "install.sh must copy \${binary}.bash from installed binaries"
grep -Fq '"_${binary}"' "$repo_root/install.sh" \
    || fail "install.sh must copy _\${binary} from installed binaries"
grep -Fq '"${binary}.fish"' "$repo_root/install.sh" \
    || fail "install.sh must copy \${binary}.fish from installed binaries"
pass "install.sh derives completion names from installed binaries"

grep -Fq '"${_festival_completion_dir}"/*.bash' "$repo_root/shell/festival.bash" \
    || fail "shell/festival.bash must source every *.bash completion"
grep -Fq '$_festival_completion_dir/*.fish' "$repo_root/shell/festival.fish" \
    || fail "shell/festival.fish must source every *.fish completion"
grep -Fq '"$completion_dir"/_*(N)' "$repo_root/shell/festival.zsh" \
    || fail "shell/festival.zsh must register every _* completion"
pass "shell helpers load completions by glob, not a filename list"

node <<'NODE'
const fs = require("fs");
const path = require("path");
const install = require("./npm/install.js");

function fail(msg) {
  console.error("FAIL: " + msg);
  process.exit(1);
}

const rows = fs
  .readFileSync(path.join("scripts", "completion-clis.txt"), "utf8")
  .split(/\r?\n/)
  .map((line) => line.trim())
  .filter((line) => line && !line.startsWith("#"))
  .map((line) => line.split(/\s+/)[0]);

if (JSON.stringify(install.BINARIES) !== JSON.stringify(rows)) {
  fail(
    "npm BINARIES must match scripts/completion-clis.txt names: " +
      JSON.stringify(install.BINARIES) +
      " vs " +
      JSON.stringify(rows),
  );
}

const derived = install.completionAssetFiles(install.BINARIES);
const expected = [];
for (const name of install.BINARIES) {
  expected.push(["completions", `${name}.bash`]);
  expected.push(["completions", `_${name}`]);
  expected.push(["completions", `${name}.fish`]);
}
if (JSON.stringify(derived) !== JSON.stringify(expected)) {
  fail("completionAssetFiles(BINARIES) drifted from the naming convention");
}

const extra = install.completionAssetFiles(["extra"]);
if (
  JSON.stringify(extra) !==
  JSON.stringify([
    ["completions", "extra.bash"],
    ["completions", "_extra"],
    ["completions", "extra.fish"],
  ])
) {
  fail("completionAssetFiles must derive three files from one binary name");
}

const required = install.REQUIRED_ASSET_FILES.map((pair) => pair.join("/"));
for (const pair of derived) {
  const key = pair.join("/");
  if (!required.includes(key)) {
    fail("REQUIRED_ASSET_FILES missing derived completion " + key);
  }
}

console.log("ok: npm/install.js derives completion filenames from BINARIES");
NODE

echo "completion-assets checks passed"
