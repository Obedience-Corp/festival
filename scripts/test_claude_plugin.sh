#!/usr/bin/env bash
# Smoke-test the Claude Code plugin bundle and its session hooks.

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
plugin_dir="$repo_root/claude-plugin"

require_command() {
    local name="$1"
    command -v "$name" >/dev/null 2>&1 || {
        echo "Required command not found: $name" >&2
        exit 1
    }
}

json_check() {
    local file="$1"
    node -e "JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'))" "$file"
}

plugin_version_check() {
    node -e '
const fs = require("fs");
const manifest = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(manifest.version)) {
  throw new Error(`plugin version must be semver: ${manifest.version}`);
}
if (!manifest.name || !manifest.description || !manifest.repository) {
  throw new Error("plugin manifest is missing required metadata");
}
' "$plugin_dir/.claude-plugin/plugin.json"
}

manifest_consistency_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const market = JSON.parse(fs.readFileSync(process.argv[3], "utf8"));
const entry = (market.plugins || [])[0] || {};
if (entry.version !== plugin.version) {
  throw new Error(`version mismatch: plugin.json=${plugin.version} marketplace.json=${entry.version}`);
}
if (entry.description !== plugin.description) {
  throw new Error("marketplace.json plugin description must match plugin.json description");
}
for (const file of (process.argv[4] || "").split("\n").filter(Boolean)) {
  const target = JSON.parse(fs.readFileSync(file, "utf8"));
  const rel = path.relative(repoRoot, file);
  if (target.version !== plugin.version) {
    throw new Error(`version mismatch: plugin.json=${plugin.version} ${rel}=${target.version}`);
  }
}
' "$@"
}

frontmatter_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const pluginDir = process.argv[1];

function badLine(file, line) {
  throw new Error(`${file}: unsupported frontmatter line: ${line}`);
}

function validateScalar(file, key, value) {
  const v = value.trim();
  if (!v) return "";
  if (/^[\[{]/.test(v)) throw new Error(`${file}: unsupported frontmatter value for ${key}`);
  const first = v[0];
  const last = v[v.length - 1];
  if (first === "\"" || first === "\x27") return validateQuotedScalar(file, key, v, first);
  if (last === "\"" || last === "\x27") throw new Error(`${file}: unmatched quote in frontmatter value for ${key}`);
  return v;
}

function validateQuotedScalar(file, key, value, quote) {
  if (value.length < 2 || value[value.length - 1] !== quote) {
    throw new Error(`${file}: unmatched quote in frontmatter value for ${key}`);
  }
  if (quote === "\"") {
    try {
      return JSON.parse(value).trim();
    } catch {
      throw new Error(`${file}: invalid quoted frontmatter value for ${key}`);
    }
  }
  const body = value.slice(1, -1);
  for (let i = 0; i < body.length; i++) {
    if (body[i] !== "\x27") continue;
    if (body[i + 1] === "\x27") {
      i++;
      continue;
    }
    throw new Error(`${file}: invalid quoted frontmatter value for ${key}`);
  }
  return body.replace(/\x27\x27/g, "\x27").trim();
}

function frontmatter(file, allowedKeys) {
  const text = fs.readFileSync(file, "utf8");
  if (!text.startsWith("---")) throw new Error(`${file}: missing frontmatter`);
  const end = text.indexOf("\n---", 3);
  if (end === -1) throw new Error(`${file}: unterminated frontmatter`);
  const block = text.slice(3, end);
  const keys = {};
  let inArguments = false;
  for (const line of block.split("\n")) {
    if (!line.trim()) continue;
    const top = line.match(/^([A-Za-z0-9_]+):\s*(.*)$/);
    if (top) {
      const key = top[1];
      const value = top[2];
      if (!allowedKeys.has(key)) throw new Error(`${file}: unsupported frontmatter key ${key}`);
      if (key === "arguments") {
        if (value.trim()) throw new Error(`${file}: arguments must be a list`);
        keys[key] = "present";
        inArguments = true;
        continue;
      }
      keys[key] = validateScalar(file, key, value);
      inArguments = false;
      continue;
    }
    if (inArguments) {
      const item = line.match(/^  - name:\s*(.+)$/);
      const description = line.match(/^    description:\s*(.+)$/);
      const required = line.match(/^    required:\s*(true|false)$/);
      if (item) {
        validateScalar(file, "arguments.name", item[1]);
        continue;
      }
      if (description) {
        validateScalar(file, "arguments.description", description[1]);
        continue;
      }
      if (required) continue;
    }
    badLine(file, line);
  }
  return keys;
}

function requireKeys(file, keys, names) {
  for (const n of names) {
    if (!keys[n]) throw new Error(`${file}: frontmatter missing ${n}`);
  }
}

for (const invalid of ["\"unterminated", "unterminated\"", "{bad", "[bad"]) {
  try {
    validateScalar("frontmatter self-test", "description", invalid);
  } catch {
    continue;
  }
  throw new Error(`frontmatter validator accepted invalid scalar: ${invalid}`);
}

for (const dir of fs.readdirSync(path.join(pluginDir, "skills"))) {
  const file = path.join(pluginDir, "skills", dir, "SKILL.md");
  const keys = frontmatter(file, new Set(["name", "description"]));
  requireKeys(file, keys, ["name", "description"]);
  if (keys.name !== dir) throw new Error(`${file}: name "${keys.name}" must equal dir "${dir}"`);
}

for (const sub of ["commands", "agents"]) {
  const base = path.join(pluginDir, sub);
  if (!fs.existsSync(base)) continue;
  for (const f of fs.readdirSync(base)) {
    if (!f.endsWith(".md")) continue;
    const file = path.join(base, f);
    const allowed = sub === "commands" ? new Set(["name", "description", "arguments"]) : new Set(["description"]);
    requireKeys(file, frontmatter(file, allowed), ["description"]);
  }
}
' "$1"
}

hook_reference_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const pluginDir = process.argv[1];
const hooks = JSON.parse(fs.readFileSync(path.join(pluginDir, "hooks", "hooks.json"), "utf8"));

const refs = new Set();
const re = /\$\{CLAUDE_PLUGIN_ROOT\}\/([^"\s]+)/g;
JSON.stringify(hooks).replace(re, (_, p) => { refs.add(p); return _; });

const root = fs.realpathSync(pluginDir);
const normalizedRoot = path.resolve(pluginDir);

function inside(rootPath, target) {
  const rel = path.relative(rootPath, target);
  return rel && !rel.startsWith("..") && !path.isAbsolute(rel);
}

for (const rel of refs) {
  const target = path.resolve(pluginDir, rel);
  if (!inside(normalizedRoot, target)) throw new Error(`hooks.json references out-of-bundle file: ${rel}`);
  if (!fs.existsSync(target)) throw new Error(`hooks.json references missing file: ${rel}`);
  const realTarget = fs.realpathSync(target);
  if (!inside(root, realTarget)) throw new Error(`hooks.json references out-of-bundle file: ${rel}`);
  fs.accessSync(target, fs.constants.R_OK);
}
if (refs.size === 0) throw new Error("hooks.json: no CLAUDE_PLUGIN_ROOT references found (expected at least one)");
' "$1"
}

# Claude Code and Codex both wrap the event map in a top-level "hooks" object. A bare
# event map installs fine and then fails at load with
# "Hook load failed: hooks: Invalid input: expected record, received undefined",
# which no other check catches because the file is still valid JSON.
hooks_shape_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const EVENTS = new Set([
  "PreToolUse", "PostToolUse", "Notification", "UserPromptSubmit", "Stop",
  "SubagentStop", "PreCompact", "SessionStart", "SessionEnd",
]);

for (const file of process.argv.slice(1)) {
  const doc = JSON.parse(fs.readFileSync(file, "utf8"));
  const stray = Object.keys(doc).filter((key) => EVENTS.has(key));
  if (stray.length > 0) {
    throw new Error(`${file}: hook events must live under the top-level "hooks" object, found at top level: ${stray.join(", ")}`);
  }
  if (!doc.hooks || typeof doc.hooks !== "object" || Array.isArray(doc.hooks)) {
    throw new Error(`${file}: missing the top-level "hooks" object`);
  }
  const events = Object.keys(doc.hooks);
  if (events.length === 0) throw new Error(`${file}: "hooks" object is empty`);
  for (const event of events) {
    if (!EVENTS.has(event)) continue;
    if (!Array.isArray(doc.hooks[event])) throw new Error(`${file}: hooks.${event} must be an array`);
  }
}
' "$@"
}

generated_targets_check() {
    local tmp drift=0
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/festival-generated.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN

    node "$repo_root/packaging/generate.mjs" --out "$tmp" >/dev/null

    while IFS= read -r fresh; do
        local rel="${fresh#"$tmp"/}"
        local committed="$repo_root/$rel"
        if [ ! -f "$committed" ]; then
            echo "generated target missing from repo (run 'just plugin generate'): $rel" >&2
            drift=1
            continue
        fi
        if ! diff -u "$committed" "$fresh" >&2; then
            echo "generated target drifted from source (run 'just plugin generate'): $rel" >&2
            drift=1
        fi
    done < <(find "$tmp" -type f | sort)

    if [ "$drift" -ne 0 ]; then
        echo "generated_targets_check failed: committed targets do not match claude-plugin/" >&2
        return 1
    fi
}

codex_target_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const marketPath = path.join(repoRoot, ".agents", "plugins", "marketplace.json");
const market = JSON.parse(fs.readFileSync(marketPath, "utf8"));
const entry = (market.plugins || [])[0] || {};
const srcPath = typeof entry.source === "string" ? entry.source : (entry.source && entry.source.path);
if (!srcPath || !srcPath.startsWith("./")) {
  throw new Error(`.agents/plugins/marketplace.json source must be a ./-relative plugin root: ${JSON.stringify(entry.source)}`);
}
const pluginRoot = path.resolve(repoRoot, srcPath);
const pluginRootRel = path.relative(repoRoot, pluginRoot);
if (pluginRootRel.startsWith("..") || path.isAbsolute(pluginRootRel)) {
  throw new Error(`.agents/plugins/marketplace.json source escapes repo root: ${JSON.stringify(entry.source)}`);
}
if (!fs.existsSync(pluginRoot)) {
  throw new Error(`.agents/plugins/marketplace.json source does not resolve: ${JSON.stringify(entry.source)}`);
}
const manifest = JSON.parse(fs.readFileSync(path.join(pluginRoot, ".codex-plugin", "plugin.json"), "utf8"));

for (const key of ["name", "version", "description"]) {
  if (!manifest[key]) throw new Error(`.codex-plugin/plugin.json missing required key: ${key}`);
}
if (manifest.version !== plugin.version) {
  throw new Error(`.codex-plugin/plugin.json version ${manifest.version} != plugin.json ${plugin.version}`);
}

const refs = [manifest.skills, manifest.hooks].filter((r) => typeof r === "string");
for (const ref of refs) {
  const target = path.resolve(pluginRoot, ref);
  const rel = path.relative(pluginRoot, target);
  if (rel.startsWith("..") || path.isAbsolute(rel)) {
    throw new Error(`.codex-plugin/plugin.json references out-of-bundle path: ${ref}`);
  }
  if (!fs.existsSync(target)) {
    throw new Error(`.codex-plugin/plugin.json references missing path: ${ref}`);
  }
}

const skillsDir = path.resolve(pluginRoot, manifest.skills);
const skills = fs.readdirSync(skillsDir).filter((d) => fs.existsSync(path.join(skillsDir, d, "SKILL.md")));
if (skills.length === 0) throw new Error(`.codex-plugin/skills/ resolves but contains no SKILL.md`);

if (entry.version !== plugin.version) {
  throw new Error(`.agents/plugins/marketplace.json version ${entry.version} != plugin.json ${plugin.version}`);
}
' "$repo_root" "$1"
}

cursor_target_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const cursorDir = path.join(repoRoot, ".cursor-plugin");
const manifest = JSON.parse(fs.readFileSync(path.join(cursorDir, "plugin.json"), "utf8"));

if (!manifest.name) throw new Error(".cursor-plugin/plugin.json missing required key: name");
if (manifest.version !== plugin.version) {
  throw new Error(`.cursor-plugin/plugin.json version ${manifest.version} != plugin.json ${plugin.version}`);
}

const refs = [manifest.skills, manifest.commands, manifest.agents, manifest.hooks].filter((r) => typeof r === "string");
for (const ref of refs) {
  const target = path.resolve(cursorDir, ref);
  const rel = path.relative(cursorDir, target);
  if (rel.startsWith("..") || path.isAbsolute(rel)) {
    throw new Error(`.cursor-plugin/plugin.json references out-of-bundle path: ${ref}`);
  }
  if (!fs.existsSync(target)) {
    throw new Error(`.cursor-plugin/plugin.json references missing path: ${ref}`);
  }
}

const skillsDir = path.resolve(cursorDir, manifest.skills);
const skills = fs.readdirSync(skillsDir).filter((d) => fs.existsSync(path.join(skillsDir, d, "SKILL.md")));
if (skills.length === 0) throw new Error(`.cursor-plugin/skills/ resolves but contains no SKILL.md`);
' "$repo_root" "$1"
}

opencode_target_check() {
    local plugin="$repo_root/.opencode/plugins/festival.js"
    node --check "$plugin" || {
        echo ".opencode/plugins/festival.js failed node --check" >&2
        return 1
    }
    node -e '
const fs = require("fs");
const path = require("path");
const ocDir = path.join(process.argv[1], ".opencode");

const installer = path.join(ocDir, "scripts", "ensure-festival.sh");
if (!fs.existsSync(installer)) {
  throw new Error(".opencode/plugins/festival.js references missing installer: scripts/ensure-festival.sh");
}

const skillsDir = path.join(ocDir, "skills");
if (!fs.existsSync(skillsDir)) throw new Error(".opencode/skills/ missing (plugin relies on auto-discovery)");
const skills = fs.readdirSync(skillsDir).filter((d) => fs.existsSync(path.join(skillsDir, d, "SKILL.md")));
if (skills.length === 0) throw new Error(".opencode/skills/ resolves but contains no SKILL.md");
' "$repo_root"
}

hermes_target_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const pluginSkills = path.join(repoRoot, "claude-plugin", "skills");
const tap = path.join(repoRoot, "skills");

function split(file) {
  const lines = fs.readFileSync(file, "utf8").split("\n");
  if (lines[0].trim() !== "---") throw new Error(`${file}: missing YAML frontmatter`);
  const close = lines.findIndex((line, index) => index > 0 && line.trim() === "---");
  if (close === -1) throw new Error(`${file}: unterminated YAML frontmatter`);
  return { front: lines.slice(1, close), body: lines.slice(close + 1).join("\n") };
}

const sources = fs.readdirSync(pluginSkills).filter((d) => fs.existsSync(path.join(pluginSkills, d, "SKILL.md"))).sort();
if (sources.length === 0) throw new Error("claude-plugin/skills contains no SKILL.md");

for (const name of sources) {
  const skillFile = path.join(tap, name, "SKILL.md");
  if (!fs.existsSync(skillFile)) throw new Error(`hermes tap missing skills/${name}/SKILL.md`);
  const src = split(path.join(pluginSkills, name, "SKILL.md"));
  const gen = split(skillFile);
  if (src.body !== gen.body) throw new Error(`skills/${name}/SKILL.md body differs from the source skill`);
  for (const line of src.front) {
    if (/^(name|description):/.test(line) && !gen.front.includes(line)) {
      throw new Error(`skills/${name}/SKILL.md changed a source frontmatter line: ${line.slice(0, 40)}`);
    }
  }
  const front = gen.front.join("\n");
  if (!gen.front.includes(`version: ${JSON.stringify(plugin.version)}`)) {
    throw new Error(`skills/${name}/SKILL.md version does not match plugin.json ${plugin.version}`);
  }
  for (const required of [/^author: \S/m, /^license: \S/m, /^metadata:$/m, /^ {2}hermes:$/m, /^ {4}tags:$/m, /^ {6}- \S/m, /^ {4}category: (camp|festival)$/m]) {
    if (!required.test(front)) throw new Error(`skills/${name}/SKILL.md frontmatter missing ${required}`);
  }
}

const cfg = JSON.parse(fs.readFileSync(path.join(repoRoot, "skills.sh.json"), "utf8"));
const allowed = new Set(["$schema", "schema", "notGrouped", "groupings"]);
for (const key of Object.keys(cfg)) {
  if (!allowed.has(key)) throw new Error(`skills.sh.json has a key the published schema forbids: ${key}`);
}
if (!Array.isArray(cfg.groupings) || cfg.groupings.length === 0) throw new Error("skills.sh.json requires a non-empty groupings array");
const listed = [];
for (const group of cfg.groupings) {
  if (!group.title || !Array.isArray(group.skills) || group.skills.length === 0) {
    throw new Error("skills.sh.json grouping requires a title and a non-empty skills array");
  }
  listed.push(...group.skills);
}
for (const name of listed) {
  if (!sources.includes(name)) throw new Error(`skills.sh.json lists an unknown skill: ${name}`);
  if (listed.filter((s) => s === name).length > 1) throw new Error(`skills.sh.json lists a skill twice: ${name}`);
}
for (const name of sources) {
  if (!listed.includes(name)) throw new Error(`skills.sh.json omits skill: ${name}`);
}
' "$repo_root" "$1"
}

gemini_target_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const ext = JSON.parse(fs.readFileSync(path.join(repoRoot, "gemini-extension.json"), "utf8"));

for (const key of ["name", "version"]) {
  if (!ext[key]) throw new Error(`gemini-extension.json missing required key: ${key}`);
}
if (ext.version !== plugin.version) {
  throw new Error(`gemini-extension.json version ${ext.version} != plugin.json ${plugin.version}`);
}

const contextFile = ext.contextFileName || "GEMINI.md";
const contextPath = path.join(repoRoot, contextFile);
if (!fs.existsSync(contextPath)) throw new Error(`gemini-extension.json contextFileName missing: ${contextFile}`);

const imports = fs.readFileSync(contextPath, "utf8").split("\n").filter((l) => l.startsWith("@"));
if (imports.length === 0) throw new Error(`${contextFile}: no @-import lines found`);
for (const line of imports) {
  const ref = line.slice(1).trim();
  if (!fs.existsSync(path.resolve(path.dirname(contextPath), ref))) {
    throw new Error(`${contextFile} @-import does not resolve: ${ref}`);
  }
}
' "$repo_root" "$1"
}

target_for_host() {
    local os arch

    os="$(uname -s | tr '[:upper:]' '[:lower:]')"
    case "$os" in
        darwin) os="macOS" ;;
        linux) os="linux" ;;
        *) echo "unsupported" && return 0 ;;
    esac

    arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64) arch="x86_64" ;;
        arm64|aarch64) arch="arm64" ;;
        *) echo "unsupported" && return 0 ;;
    esac

    if [ "$os" = "macOS" ]; then
        echo "macOS-all"
    else
        echo "${os}-${arch}"
    fi
}

write_stub_binary() {
    local path="$1"
    local name="$2"

    cat > "$path" <<EOF_STUB
#!/usr/bin/env bash
case "\${1:-}" in
  version|--version) echo "${name} v9.8.7" ;;
  *) echo "${name} stub" ;;
esac
EOF_STUB
    chmod +x "$path"
}

write_fake_curl() {
    local path="$1"

    cat > "$path" <<'EOF_CURL'
#!/usr/bin/env bash
set -euo pipefail

out=""
url=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        -o)
            out="$2"
            shift 2
            ;;
        -*)
            shift
            ;;
        *)
            url="$1"
            shift
            ;;
    esac
done

fixture="${FESTIVAL_PLUGIN_TEST_FIXTURE_DIR:?}"
case "$url" in
    *"/releases/latest")
        src="$fixture/release.json"
        ;;
    *"/checksums.txt")
        src="$fixture/checksums.txt"
        ;;
    *".tar.gz")
        src="$fixture/archive.tar.gz"
        ;;
    *)
        echo "unexpected URL: $url" >&2
        exit 22
        ;;
esac

if [ -n "$out" ]; then
    cp "$src" "$out"
else
    cat "$src"
fi
EOF_CURL
    chmod +x "$path"
}

smoke_install_hook() {
    local target archive_name tmp fixture payload fakebin home install_dir

    target="$(target_for_host)"
    if [ "$target" = "unsupported" ]; then
        echo "Skipping install hook smoke on unsupported host platform"
        return 0
    fi

    tmp="$(mktemp -d "${TMPDIR:-/tmp}/festival-plugin-test.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN
    fixture="$tmp/fixture"
    payload="$tmp/payload"
    fakebin="$tmp/fakebin"
    home="$tmp/home"
    install_dir="$tmp/install"
    mkdir -p "$fixture" "$payload" "$fakebin" "$home" "$install_dir"

    write_stub_binary "$payload/fest" "fest"
    write_stub_binary "$payload/camp" "camp"

    archive_name="festival-9.8.7-${target}.tar.gz"
    (cd "$payload" && tar -czf "$fixture/archive.tar.gz" fest camp)
    if command -v shasum >/dev/null 2>&1; then
        checksum="$(shasum -a 256 "$fixture/archive.tar.gz" | awk '{print $1}')"
    else
        checksum="$(sha256sum "$fixture/archive.tar.gz" | awk '{print $1}')"
    fi
    printf '%s  %s\n' "$checksum" "$archive_name" > "$fixture/checksums.txt"

    cat > "$fixture/release.json" <<EOF_JSON
{
  "tag_name": "v9.8.7",
  "assets": [
    {
      "browser_download_url": "https://example.test/${archive_name}"
    }
  ]
}
EOF_JSON

    write_fake_curl "$fakebin/curl"

    if ! FESTIVAL_PLUGIN_TEST_FIXTURE_DIR="$fixture" \
        HOME="$home" \
        INSTALL_DIR="$install_dir" \
        PATH="$fakebin:/usr/bin:/bin:/usr/sbin:/sbin" \
        bash "$plugin_dir/hooks/scripts/ensure-festival.sh" >"$tmp/install.log" 2>&1; then
        cat "$tmp/install.log" >&2
        return 1
    fi

    test -x "$install_dir/fest"
    test -x "$install_dir/camp"

    if ! FESTIVAL_PLUGIN_TEST_FIXTURE_DIR="$fixture" \
        HOME="$home" \
        INSTALL_DIR="$install_dir" \
        PATH="$install_dir:$fakebin:/usr/bin:/bin:/usr/sbin:/sbin" \
        bash "$plugin_dir/hooks/scripts/ensure-festival.sh" >"$tmp/update-check.log" 2>&1; then
        cat "$tmp/update-check.log" >&2
        return 1
    fi
}

require_command node
require_command tar
require_command bash

json_check "$plugin_dir/.claude-plugin/plugin.json"
json_check "$plugin_dir/hooks/hooks.json"
plugin_version_check
manifest_consistency_check "$repo_root" "$plugin_dir/.claude-plugin/plugin.json" "$repo_root/.claude-plugin/marketplace.json" "$(node "$repo_root/packaging/generate.mjs" --manifests)"
frontmatter_check "$plugin_dir"
hook_reference_check "$plugin_dir"
hooks_shape_check "$plugin_dir/hooks/hooks.json" "$repo_root/plugins/festival/hooks/hooks.json" "$repo_root/hooks/hooks.json"
generated_targets_check
codex_target_check "$plugin_dir/.claude-plugin/plugin.json"
cursor_target_check "$plugin_dir/.claude-plugin/plugin.json"
opencode_target_check
gemini_target_check "$plugin_dir/.claude-plugin/plugin.json"
hermes_target_check "$plugin_dir/.claude-plugin/plugin.json"
bash -n "$plugin_dir/hooks/scripts/ensure-festival.sh" "$plugin_dir/hooks/scripts/sync-check.sh" \
    "$plugin_dir/hooks/scripts/commit-guard.sh" "$plugin_dir/hooks/scripts/commit-guard.test.sh"
bash "$plugin_dir/hooks/scripts/commit-guard.test.sh"

if [ -x "$repo_root/fest/bin/fest" ] && [ -x "$repo_root/camp/bin/camp" ]; then
    FEST_BIN="$repo_root/fest/bin/fest" CAMP_BIN="$repo_root/camp/bin/camp" \
        bash "$plugin_dir/hooks/scripts/sync-check.sh"
else
    bash "$plugin_dir/hooks/scripts/sync-check.sh"
fi

smoke_install_hook

echo "Claude plugin smoke passed"
