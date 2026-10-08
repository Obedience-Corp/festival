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
const re = /\$\{CLAUDE_PLUGIN_ROOT\}\/([^"\\\s]+)/g;
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

    local owned rel
    for owned in cursor-plugin .cursor-plugin plugins/festival .opencode skills .agents/plugins hooks; do
        [ -d "$repo_root/$owned" ] || continue
        while IFS= read -r rel; do
            if [ ! -f "$tmp/$rel" ]; then
                echo "file in a generated target that the generator does not write (remove it or edit claude-plugin/): $rel" >&2
                drift=1
            fi
        done < <(cd "$repo_root" && find "$owned" -type f ! -name .DS_Store | sort)
    done

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

const hooksFile = path.resolve(pluginRoot, manifest.hooks);
const hooksRel = path.relative(repoRoot, hooksFile);
const hooksDoc = JSON.parse(fs.readFileSync(hooksFile, "utf8"));
// codex-cli 0.161.0 refuses the whole file on any other top-level key:
// "unknown field `_generated`, expected `description` or `hooks`".
const strayKeys = Object.keys(hooksDoc).filter((key) => key !== "description" && key !== "hooks");
if (strayKeys.length > 0) {
  throw new Error(`${hooksRel}: Codex rejects plugin hooks files with top-level keys other than description and hooks, found: ${strayKeys.join(", ")}`);
}
const hooks = hooksDoc.hooks || {};
for (const def of Object.values(hooks).flat().flatMap((group) => group.hooks || [])) {
  if (typeof def.command !== "string" || !def.command.includes("${PLUGIN_ROOT}/")) {
    throw new Error(`${hooksRel}: hook command must run from \${PLUGIN_ROOT}: ${def.command}`);
  }
  def.command.replace(/\$\{PLUGIN_ROOT\}\/([^"\x27\s]+)/g, (_, ref) => {
    const target = path.resolve(pluginRoot, ref);
    const rel = path.relative(pluginRoot, target);
    if (rel.startsWith("..") || path.isAbsolute(rel)) throw new Error(`${hooksRel}: hook references a file outside the plugin: ${ref}`);
    if (!fs.existsSync(target)) throw new Error(`${hooksRel}: hook references a missing file: ${ref}`);
    return _;
  });
}
const guard = (hooks.PreToolUse || []).find((group) => group.matcher === "Bash");
if (!guard || !(guard.hooks || []).some((def) => def.command.includes("/hooks/scripts/commit-guard.sh"))) {
  throw new Error(`${hooksRel}: expected a PreToolUse hook with matcher Bash that runs hooks/scripts/commit-guard.sh`);
}
if ((guard.hooks || []).some((def) => def.async === true)) {
  throw new Error(`${hooksRel}: the commit guard must run synchronously; Codex ignores decisions from async hooks`);
}

if (entry.version !== plugin.version) {
  throw new Error(`.agents/plugins/marketplace.json version ${entry.version} != plugin.json ${plugin.version}`);
}
' "$repo_root" "$1"
}

# Cursor treats the directory that contains .cursor-plugin/ as the plugin root and
# resolves manifest paths and runs hook commands from there. The repo root only
# carries .cursor-plugin/marketplace.json; the plugin itself is cursor-plugin/.
cursor_target_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const repoRoot = process.argv[1];
const plugin = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const kebab = /^[a-z0-9](?:[a-z0-9.-]*[a-z0-9])?$/;

function inside(root, target) {
  const rel = path.relative(root, target);
  return rel !== "" && !rel.startsWith("..") && !path.isAbsolute(rel);
}

function relativeRef(file, ref) {
  if (typeof ref !== "string" || ref === "") throw new Error(`${file}: path must be a non-empty string: ${JSON.stringify(ref)}`);
  if (path.isAbsolute(ref) || ref.split(/[\\/]/).includes("..")) {
    throw new Error(`${file}: path must be relative with no "..": ${ref}`);
  }
}

const rootDir = path.join(repoRoot, ".cursor-plugin");
const stray = fs.readdirSync(rootDir).filter((f) => f !== "marketplace.json" && !f.startsWith("."));
if (stray.length > 0) {
  throw new Error(`.cursor-plugin/ at the repo root must hold only marketplace.json (Cursor would load the repo root as the plugin), found: ${stray.join(", ")}`);
}

const marketFile = ".cursor-plugin/marketplace.json";
const market = JSON.parse(fs.readFileSync(path.join(repoRoot, marketFile), "utf8"));
if (!market.name || !kebab.test(market.name)) throw new Error(`${marketFile}: name must be kebab-case: ${market.name}`);
if (!market.owner || !market.owner.name) throw new Error(`${marketFile}: owner.name is required`);
if (!Array.isArray(market.plugins) || market.plugins.length !== 1) {
  throw new Error(`${marketFile}: expected exactly one plugin entry`);
}
const entry = market.plugins[0];
if (entry.name !== plugin.name) throw new Error(`${marketFile}: plugin name ${entry.name} != plugin.json ${plugin.name}`);
if (entry.version !== plugin.version) throw new Error(`${marketFile}: version ${entry.version} != plugin.json ${plugin.version}`);
const source = typeof entry.source === "string" ? entry.source : entry.source && entry.source.path;
relativeRef(marketFile, source);
const pluginRoot = path.resolve(repoRoot, source);
if (!inside(repoRoot, pluginRoot)) throw new Error(`${marketFile}: source escapes the repo root: ${source}`);
const manifestFile = path.join(pluginRoot, ".cursor-plugin", "plugin.json");
if (!fs.statSync(pluginRoot, { throwIfNoEntry: false })?.isDirectory() || !fs.existsSync(manifestFile)) {
  throw new Error(`${marketFile}: source ${source} is not a directory with .cursor-plugin/plugin.json`);
}

const manifestRel = path.relative(repoRoot, manifestFile);
const manifest = JSON.parse(fs.readFileSync(manifestFile, "utf8"));
if (!manifest.name || !kebab.test(manifest.name)) throw new Error(`${manifestRel}: name must be kebab-case: ${manifest.name}`);
if (manifest.name !== plugin.name) throw new Error(`${manifestRel}: name ${manifest.name} != plugin.json ${plugin.name}`);
if (manifest.version !== plugin.version) {
  throw new Error(`${manifestRel}: version ${manifest.version} != plugin.json ${plugin.version}`);
}
if (manifest.author && !manifest.author.name) throw new Error(`${manifestRel}: author.name is required when author is set`);

for (const key of ["skills", "commands", "agents", "hooks", "rules", "mcpServers", "logo"]) {
  if (manifest[key] === undefined) continue;
  for (const ref of [].concat(manifest[key])) {
    if ((key === "hooks" || key === "mcpServers") && typeof ref === "object" && ref !== null) continue;
    if (key === "logo" && /^https?:\/\//.test(ref)) continue;
    relativeRef(manifestRel, ref);
    const target = path.resolve(pluginRoot, ref);
    if (!inside(pluginRoot, target)) throw new Error(`${manifestRel}: ${key} points outside the plugin: ${ref}`);
    if (!fs.existsSync(target)) throw new Error(`${manifestRel}: ${key} references a missing path: ${ref}`);
  }
}
for (const key of ["skills", "commands", "agents", "hooks"]) {
  if (typeof manifest[key] !== "string") throw new Error(`${manifestRel}: ${key} must be declared`);
}

const skillsDir = path.resolve(pluginRoot, manifest.skills);
const skills = fs.readdirSync(skillsDir).filter((d) => fs.existsSync(path.join(skillsDir, d, "SKILL.md")));
if (skills.length === 0) throw new Error(`${manifestRel}: skills resolves but contains no SKILL.md`);
for (const key of ["commands", "agents"]) {
  const dir = path.resolve(pluginRoot, manifest[key]);
  if (fs.readdirSync(dir).filter((f) => f.endsWith(".md")).length === 0) throw new Error(`${manifestRel}: ${key} resolves but holds no .md file`);
}

const EVENTS = new Set([
  "sessionStart", "sessionEnd", "preToolUse", "postToolUse", "postToolUseFailure", "subagentStart",
  "subagentStop", "beforeShellExecution", "afterShellExecution", "beforeMCPExecution", "afterMCPExecution",
  "beforeReadFile", "afterFileEdit", "beforeSubmitPrompt", "preCompact", "stop", "afterAgentResponse",
  "afterAgentThought", "beforeTabFileRead", "afterTabFileEdit", "workspaceOpen",
]);
const hooksFile = path.resolve(pluginRoot, manifest.hooks);
const hooksRel = path.relative(repoRoot, hooksFile);
const hooks = JSON.parse(fs.readFileSync(hooksFile, "utf8"));
if (hooks.version !== 1) throw new Error(`${hooksRel}: version must be 1`);
if (!hooks.hooks || typeof hooks.hooks !== "object" || Array.isArray(hooks.hooks)) throw new Error(`${hooksRel}: missing the "hooks" object`);
for (const [event, defs] of Object.entries(hooks.hooks)) {
  if (!EVENTS.has(event)) throw new Error(`${hooksRel}: not a Cursor hook event: ${event}`);
  if (!Array.isArray(defs) || defs.length === 0) throw new Error(`${hooksRel}: hooks.${event} must be a non-empty array`);
}
const start = hooks.hooks.sessionStart || [];
if (start.length !== 1) throw new Error(`${hooksRel}: expected one sessionStart hook (the CLI installer)`);
for (const permission of ["beforeShellExecution", "beforeMCPExecution", "beforeReadFile", "preToolUse", "subagentStart", "beforeTabFileRead"]) {
  if (hooks.hooks[permission]) throw new Error(`${hooksRel}: the installer must not register a permission hook (${permission})`);
}
const refs = [];
for (const def of Object.values(hooks.hooks).flat()) {
  if (typeof def.command !== "string" || !def.command.includes("${CURSOR_PLUGIN_ROOT}/")) {
    throw new Error(`${hooksRel}: hook command must run from \${CURSOR_PLUGIN_ROOT}: ${def.command}`);
  }
  def.command.replace(/\$\{CURSOR_PLUGIN_ROOT\}\/([^"\x27\s]+)/g, (_, p) => { refs.push(p); return _; });
}
for (const ref of refs) {
  const target = path.resolve(pluginRoot, ref);
  if (!inside(pluginRoot, target)) throw new Error(`${hooksRel}: hook references a file outside the plugin: ${ref}`);
  if (!fs.existsSync(target)) throw new Error(`${hooksRel}: hook references a missing file: ${ref}`);
}
' "$repo_root" "$1"
}

# The Cursor install hook must print valid JSON ({}) on stdout and exit 0
# whatever the installer does, with installer output kept on stderr. The installer
# here is a stub or absent: nothing is downloaded and nothing is written outside
# the temp dir.
cursor_install_hook_check() {
    local tmp hook out rc
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/festival-cursor-hook.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN
    hook="$tmp/plugin/hooks/scripts/cursor-install-hook.sh"
    mkdir -p "$(dirname "$hook")"
    cp "$repo_root/cursor-plugin/hooks/scripts/cursor-install-hook.sh" "$hook"

    expect_allow() {
        local label="$1"
        rc=0
        out="$(printf '%s' '{"session_id":"s1","hook_event_name":"sessionStart"}' | bash "$hook" 2>"$tmp/stderr")" || rc=$?
        if [ "$rc" -ne 0 ] || [ "$out" != '{}' ]; then
            echo "cursor-install-hook.sh ($label): want exit 0 and {} on stdout, got exit $rc and: $out" >&2
            cat "$tmp/stderr" >&2
            return 1
        fi
    }

    expect_allow "installer missing" || return 1

    cat > "$(dirname "$hook")/ensure-festival.sh" <<'EOF_STUB'
#!/usr/bin/env bash
echo "installer progress on stdout"
echo "installer failure on stderr" >&2
exit 1
EOF_STUB
    expect_allow "installer fails" || return 1
    if ! grep -q "installer progress on stdout" "$tmp/stderr"; then
        echo "cursor-install-hook.sh must route installer stdout to stderr" >&2
        return 1
    fi

    cat > "$(dirname "$hook")/ensure-festival.sh" <<'EOF_STUB'
#!/usr/bin/env bash
echo "installed"
exit 0
EOF_STUB
    expect_allow "installer succeeds" || return 1
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
const guard = path.join(ocDir, "scripts", "commit-guard.sh");
if (!fs.existsSync(guard)) {
  throw new Error(".opencode/plugins/festival.js references missing commit guard: scripts/commit-guard.sh");
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

// Gemini substitutes ${extensionPath} into hook commands as raw text, and the
// extension root is the repository root.
const hooksRel = "hooks/hooks.json";
const hooks = JSON.parse(fs.readFileSync(path.join(repoRoot, hooksRel), "utf8")).hooks || {};
for (const def of Object.values(hooks).flat().flatMap((group) => group.hooks || [])) {
  if (typeof def.command !== "string" || !def.command.includes("${extensionPath}/")) {
    throw new Error(`${hooksRel}: hook command must run from \${extensionPath}: ${def.command}`);
  }
  def.command.replace(/\$\{extensionPath\}\/([^"\x27\s]+)/g, (_, ref) => {
    if (!fs.existsSync(path.resolve(repoRoot, ref))) throw new Error(`${hooksRel}: hook references a missing file: ${ref}`);
    return _;
  });
}
const guards = (hooks.BeforeTool || []).filter((group) => {
  try {
    return new RegExp(group.matcher).test("run_shell_command") && !new RegExp(group.matcher).test("read_file");
  } catch {
    return false;
  }
});
if (!guards.some((group) => (group.hooks || []).some((def) => def.command.includes("/hooks/scripts/gemini-commit-guard.sh")))) {
  throw new Error(`${hooksRel}: expected a BeforeTool hook matching run_shell_command that runs hooks/scripts/gemini-commit-guard.sh`);
}
' "$repo_root" "$1"
}

# A `camp` whose `id` answers the way the real one does: success only somewhere
# under a .campaign/campaign.yaml. The guard calls nothing else on it.
write_camp_id_stub() {
    cat > "$1" <<'EOF_STUB'
#!/usr/bin/env bash
[ "${1:-}" = "id" ] || exit 1
dir="$PWD"
while :; do
    if [ -f "$dir/.campaign/campaign.yaml" ]; then
        echo "stub-camp-id"
        exit 0
    fi
    [ "$dir" = "/" ] && exit 1
    dir="$(dirname "$dir")"
done
EOF_STUB
    chmod +x "$1"
}

# The commit guard as the Codex, Gemini, and opencode bundles wire it. Each case
# feeds that harness's own hook input to the hook command from the generated
# bundle, run the way the harness runs it, against a temp camp and a stub camp
# binary. No network, no real camp, nothing written outside the temp dir.
commit_guard_harness_check() {
    local tmp fakebin camp outside path_env codex_hook gemini_hook
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/festival-commit-guard.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN
    fakebin="$tmp/fakebin"
    camp="$tmp/camp"
    outside="$tmp/outside"
    mkdir -p "$fakebin" "$camp/.campaign" "$camp/projects/app" "$outside"
    : > "$camp/.campaign/campaign.yaml"
    write_camp_id_stub "$fakebin/camp"
    path_env="$fakebin:$PATH"
    # BASH_ENV runs before every non-interactive bash script; this one makes only
    # commit-guard.sh itself fail with exit 3 and text on stderr, the shape of an
    # internal error, so each wiring is checked for failing open on it.
    printf '%s\n' 'case "$0" in */commit-guard.sh) echo "guard crashed" >&2; exit 3 ;; esac' > "$tmp/crash-guard.sh"

    # guard_case LABEL WANT HOOK CWD PAYLOAD [VAR=value...]: run HOOK through
    # bash -c in CWD with PAYLOAD on stdin. block wants exit 2, no stdout, and the
    # reason on stderr; allow wants exit 0 and no output on either stream; pass
    # wants any exit but 2 and no stdout, which a harness that fails open on
    # every other exit code treats as allow.
    guard_case() {
        local label="$1" want="$2" hook="$3" cwd="$4" payload="$5" rc=0 out err
        shift 5
        out="$(cd "$cwd" && printf '%s' "$payload" | env PATH="$path_env" "$@" bash -c "$hook" 2>"$tmp/stderr")" || rc=$?
        err="$(cat "$tmp/stderr")"
        if [ "$want" = "block" ]; then
            if [ "$rc" -ne 2 ] || [ -n "$out" ] || [[ "$err" != *"raw git commit is forbidden inside a camp"* ]]; then
                echo "commit guard ($label): want exit 2 with the reason on stderr, got exit $rc, stdout: $out, stderr: $err" >&2
                return 1
            fi
        elif [ "$want" = "pass" ]; then
            if [ "$rc" -eq 2 ] || [ -n "$out" ]; then
                echo "commit guard ($label): want any exit but 2 and no stdout, got exit $rc, stdout: $out, stderr: $err" >&2
                return 1
            fi
        elif [ "$rc" -ne 0 ] || [ -n "$out" ] || [ -n "$err" ]; then
            echo "commit guard ($label): want exit 0 and no output, got exit $rc, stdout: $out, stderr: $err" >&2
            return 1
        fi
    }

    # Codex PreToolUse input, with every field its published schema requires.
    # Codex runs the command from the session cwd with PLUGIN_ROOT set.
    codex_payload() {
        printf '{"session_id":"s1","turn_id":"t1","transcript_path":null,"cwd":"%s","hook_event_name":"PreToolUse","model":"test-model","permission_mode":"default","tool_name":"Bash","tool_use_id":"call_1","tool_input":{"command":"%s"}}' "$1" "$2"
    }
    codex_hook="$(node -e '
const hooks = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).hooks;
process.stdout.write(hooks.PreToolUse.find((group) => group.matcher === "Bash").hooks[0].command);
' "$repo_root/plugins/festival/hooks/hooks.json")"
    codex_case() {
        local label="$1" want="$2" cwd="$3" payload="$4"
        shift 4
        guard_case "codex: $label" "$want" "$codex_hook" "$cwd" "$payload" PLUGIN_ROOT="$repo_root/plugins/festival" "$@"
    }
    codex_case "git commit in a camp" block "$camp" "$(codex_payload "$camp" "git commit -m x")" || return 1
    codex_case "git commit in a camp project" block "$camp/projects/app" "$(codex_payload "$camp/projects/app" "git add -A && git commit -m x")" || return 1
    codex_case "fest commit in a camp" allow "$camp" "$(codex_payload "$camp" "fest commit -m x")" || return 1
    codex_case "git status in a camp" allow "$camp" "$(codex_payload "$camp" "git status")" || return 1
    codex_case "git commit outside a camp" allow "$outside" "$(codex_payload "$outside" "git commit -m x")" || return 1
    codex_case "CAMP_ALLOW_RAW_GIT=1" allow "$camp" "$(codex_payload "$camp" "git commit -m x")" CAMP_ALLOW_RAW_GIT=1 || return 1
    codex_case "malformed JSON" allow "$camp" 'not json' || return 1
    codex_case "empty input" allow "$camp" '' || return 1
    codex_case "no tool_input" allow "$camp" "{\"cwd\":\"$camp\",\"tool_name\":\"Bash\"}" || return 1
    # Codex fails open on any exit but 2, so a crashing guard only has to avoid 2.
    codex_case "guard crashes" pass "$camp" "$(codex_payload "$camp" "git commit -m x")" BASH_ENV="$tmp/crash-guard.sh" || return 1

    # Gemini BeforeTool input for run_shell_command. Gemini substitutes
    # ${extensionPath} as raw text and runs the command from the session cwd.
    gemini_payload() {
        local dir_field=""
        [ -n "${3:-}" ] && dir_field=",\"dir_path\":\"$3\""
        printf '{"session_id":"s1","transcript_path":"/tmp/session.json","cwd":"%s","hook_event_name":"BeforeTool","timestamp":"2026-10-08T00:00:00.000Z","tool_name":"run_shell_command","tool_input":{"command":"%s","description":"test"%s}}' "$1" "$2" "$dir_field"
    }
    gemini_hook="$(node -e '
const hooks = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).hooks;
const group = hooks.BeforeTool.find((g) => new RegExp(g.matcher).test("run_shell_command"));
process.stdout.write(group.hooks[0].command.split("${extensionPath}").join(process.argv[2]));
' "$repo_root/hooks/hooks.json" "$repo_root")"
    gemini_case() {
        guard_case "gemini: $1" "$2" "$gemini_hook" "$3" "$4" "${@:5}"
    }
    gemini_case "git commit in a camp" block "$camp" "$(gemini_payload "$camp" "git commit -m x")" || return 1
    gemini_case "dir_path into a camp from outside" block "$tmp" "$(gemini_payload "$tmp" "git commit -m x" "camp/projects/app")" || return 1
    gemini_case "absolute dir_path outside a camp" allow "$camp" "$(gemini_payload "$camp" "git commit -m x" "$outside")" || return 1
    gemini_case "fest commit in a camp" allow "$camp" "$(gemini_payload "$camp" "fest commit -m x")" || return 1
    gemini_case "git status in a camp" allow "$camp" "$(gemini_payload "$camp" "git status")" || return 1
    gemini_case "git commit outside a camp" allow "$outside" "$(gemini_payload "$outside" "git commit -m x")" || return 1
    gemini_case "CAMP_ALLOW_RAW_GIT=1" allow "$camp" "$(gemini_payload "$camp" "git commit -m x")" CAMP_ALLOW_RAW_GIT=1 || return 1
    gemini_case "malformed JSON" allow "$camp" 'not json' || return 1
    gemini_case "empty input" allow "$camp" '' || return 1
    gemini_case "tool_input is a string" allow "$camp" "{\"cwd\":\"$camp\",\"tool_input\":\"git commit -m x\"}" || return 1
    # Gemini denies on exit codes other than 0 and 1 when the hook printed text,
    # so the adapter must turn a crashing guard into a silent exit 0.
    gemini_case "guard crashes" allow "$camp" "$(gemini_payload "$camp" "git commit -m x")" BASH_ENV="$tmp/crash-guard.sh" || return 1

    # opencode: import the generated plugin with a stub Bun shell and call its
    # tool.execute.before hook with the bash tool's (input, output) shape.
    if ! PATH="$path_env" node --input-type=module -e '
const [pluginFile, camp, outside] = process.argv.slice(1);
const mod = await import(pluginFile);
const load = (directory) => mod.default({ $: () => Promise.resolve(), directory });
const cases = [
  ["git commit in a camp", camp, { command: "git commit -m x", description: "commit" }, "block"],
  ["git commit with workdir in a camp project", outside, { command: "git commit -m x", workdir: `${camp}/projects/app` }, "block"],
  ["relative workdir outside a camp", camp, { command: "git commit -m x", workdir: "../outside" }, "allow"],
  ["fest commit in a camp", camp, { command: "fest commit -m x" }, "allow"],
  ["git status in a camp", camp, { command: "git status" }, "allow"],
  ["git commit outside a camp", outside, { command: "git commit -m x" }, "allow"],
  ["command is not a string", camp, { command: 42 }, "allow"],
  ["no args", camp, undefined, "allow"],
];
let failed = 0;
for (const [label, directory, args, want] of cases) {
  const hooks = await load(directory);
  let got = "allow";
  let message = "";
  try {
    await hooks["tool.execute.before"]({ tool: "bash", sessionID: "s1", callID: "c1" }, { args });
  } catch (error) {
    got = "block";
    message = error.message;
  }
  if (got !== want || (want === "block" && !message.includes("raw git commit is forbidden inside a camp"))) {
    console.error(`commit guard (opencode: ${label}): want ${want}, got ${got} ${message}`);
    failed = 1;
  }
}
const hooks = await load(camp);
try {
  await hooks["tool.execute.before"]({ tool: "read", sessionID: "s1", callID: "c1" }, { args: { command: "git commit -m x" } });
} catch (error) {
  console.error(`commit guard (opencode: non-bash tool): want allow, got block ${error.message}`);
  failed = 1;
}
process.exit(failed);
' "$repo_root/.opencode/plugins/festival.js" "$camp" "$outside"; then
        return 1
    fi
    local label env_var
    for env_var in CAMP_ALLOW_RAW_GIT=1 "BASH_ENV=$tmp/crash-guard.sh"; do
        label="${env_var%%=*}"
        if ! (cd "$camp" && env PATH="$path_env" "$env_var" node --input-type=module -e '
const mod = await import(process.argv[1]);
const hooks = await mod.default({ $: () => Promise.resolve(), directory: process.argv[2] });
await hooks["tool.execute.before"]({ tool: "bash", sessionID: "s1", callID: "c1" }, { args: { command: "git commit -m x" } });
' "$repo_root/.opencode/plugins/festival.js" "$camp"); then
            echo "commit guard (opencode: $label): want allow, got block" >&2
            return 1
        fi
    done
    echo "commit guard harness checks passed (codex, gemini, opencode)"
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
  version)
    case "\${2:-}" in
      --short|-s) echo "v9.8.7" ;;
      *) echo "${name} v9.8.7" ;;
    esac
    ;;
  --version) echo "${name} v9.8.7" ;;
  *) echo "${name} stub" ;;
esac
EOF_STUB
    chmod +x "$path"
}

write_fest_version_stub() {
    local path="$1"
    local short="$2"
    local first_line="$3"

    cat > "$path" <<EOF_STUB
#!/usr/bin/env bash
case "\${1:-}" in
  version)
    case "\${2:-}" in
      --short|-s) echo "${short}" ;;
      *)
        echo "${first_line}"
        echo "commit: testdead"
        echo "built: 2026-08-19T00:00:00Z"
        echo "go: go1.26.4"
        echo "platform: testhost"
        ;;
    esac
    ;;
  --version) echo "fest version ${short}" ;;
  *) echo "fest stub" ;;
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

    run_ensure() {
        local log="$1"
        rm -f "$tmp/last-update-check"
        if ! FESTIVAL_PLUGIN_TEST_FIXTURE_DIR="$fixture" \
            HOME="$home" \
            INSTALL_DIR="$install_dir" \
            FESTIVAL_CHECK_FILE="$tmp/last-update-check" \
            PATH="$install_dir:$fakebin:/usr/bin:/bin:/usr/sbin:/sbin" \
            bash "$plugin_dir/hooks/scripts/ensure-festival.sh" >"$log" 2>&1; then
            cat "$log" >&2
            return 1
        fi
    }

    if ! FESTIVAL_PLUGIN_TEST_FIXTURE_DIR="$fixture" \
        HOME="$home" \
        INSTALL_DIR="$install_dir" \
        FESTIVAL_CHECK_FILE="$tmp/last-update-check" \
        PATH="$fakebin:/usr/bin:/bin:/usr/sbin:/sbin" \
        bash "$plugin_dir/hooks/scripts/ensure-festival.sh" >"$tmp/install.log" 2>&1; then
        cat "$tmp/install.log" >&2
        return 1
    fi

    test -x "$install_dir/fest"
    test -x "$install_dir/camp"

    # Matching release: no nag. Clear the check file so this actually runs
    # the update-compare path (install records a check and would otherwise skip).
    run_ensure "$tmp/update-check.log" || return 1
    if grep -q "Festival update available" "$tmp/update-check.log"; then
        echo "matching version must not nag an update" >&2
        cat "$tmp/update-check.log" >&2
        return 1
    fi

    # Dev build whose full `fest version` includes go1.26.4: skip, never nag 1.26.4.
    write_fest_version_stub "$install_dir/fest" "dev" "fest dev"
    run_ensure "$tmp/dev-check.log" || return 1
    if grep -q "Festival update available" "$tmp/dev-check.log"; then
        echo "dev build must not nag an update" >&2
        cat "$tmp/dev-check.log" >&2
        return 1
    fi
    if ! grep -q "not a release" "$tmp/dev-check.log"; then
        echo "dev build should skip with a clear message" >&2
        cat "$tmp/dev-check.log" >&2
        return 1
    fi
    if grep -q "1.26.4" "$tmp/dev-check.log"; then
        echo "must not surface the Go toolchain version as the festival version" >&2
        cat "$tmp/dev-check.log" >&2
        return 1
    fi

    # Older release plus the same Go line: nag the festival version, not 1.26.4.
    write_fest_version_stub "$install_dir/fest" "v0.1.0" "fest v0.1.0"
    run_ensure "$tmp/stale-check.log" || return 1
    if ! grep -q "Festival update available: v0.1.0 -> v9.8.7" "$tmp/stale-check.log"; then
        echo "stale release must nag the festival versions" >&2
        cat "$tmp/stale-check.log" >&2
        return 1
    fi
    if grep -q "1.26.4" "$tmp/stale-check.log"; then
        echo "must not report the Go toolchain version as the local festival version" >&2
        cat "$tmp/stale-check.log" >&2
        return 1
    fi
}

# Write a fest/camp stub whose `version` output is the given lines. The lines go
# in a sibling data file so a test can rewrite them (for example with CRLF
# endings) without regenerating the script. `version --short` answers with the
# tool's own version token, field 2 of the first line, the way a real fest does:
# the hook asks for it before falling back to the block.
write_version_stub() {
    local path="$1"
    local data="$path.version"
    shift

    : > "$data"
    for line in "$@"; do
        printf '%s\n' "$line" >> "$data"
    done

    cat > "$path" <<EOF_STUB
#!/usr/bin/env bash
case "\${1:-}" in
  version|--version)
    case "\${2:-}" in
      --short|-s) awk 'NR==1 {print \$2; exit}' "$data" ;;
      *) cat "$data" ;;
    esac
    ;;
  *) echo "stub" ;;
esac
EOF_STUB
    chmod +x "$path"
}

# Rewrite a stub's version output with CRLF line endings, as a binary built for
# or piped through Windows tooling would produce.
crlf_version_stub() {
    local data="$1.version"

    awk '{ printf "%s\r\n", $0 }' "$data" > "$data.crlf"
    mv "$data.crlf" "$data"
}

# A `fest` that fails, as a truncated download or an incompatible binary would.
write_failing_stub() {
    local path="$1"

    cat > "$path" <<'EOF_STUB'
#!/usr/bin/env bash
echo "fest: cannot execute" >&2
exit 1
EOF_STUB
    chmod +x "$path"
}

prepare_update_workdir() {
    local workdir="$1"

    mkdir -p "$workdir/home" "$workdir/bin"
    write_version_stub "$workdir/bin/camp" "camp v0.0.0"
}

invoke_update_hook() {
    local workdir="$1" fixture="$2" fakebin="$3"

    if ! FESTIVAL_PLUGIN_TEST_FIXTURE_DIR="$fixture" \
        FESTIVAL_CHECK_FILE="$workdir/last-update-check" \
        HOME="$workdir/home" \
        INSTALL_DIR="$workdir/bin" \
        PATH="$workdir/bin:$fakebin:/usr/bin:/bin:/usr/sbin:/sbin" \
        bash "$plugin_dir/hooks/scripts/ensure-festival.sh" >"$workdir/log" 2>&1; then
        cat "$workdir/log" >&2
        return 1
    fi
}

run_update_check() {
    local workdir="$1" fixture="$2" fakebin="$3"
    shift 3

    prepare_update_workdir "$workdir"
    write_version_stub "$workdir/bin/fest" "$@"
    invoke_update_hook "$workdir" "$fixture" "$fakebin"
}

assert_log_contains() {
    local log="$1" needle="$2"

    if ! grep -qF "$needle" "$log"; then
        echo "expected in ensure-festival.sh output: $needle" >&2
        cat "$log" >&2
        return 1
    fi
}

assert_no_update_notice() {
    local log="$1" reason="$2"

    if grep -qF "Festival update available" "$log"; then
        echo "unexpected update notice: $reason" >&2
        cat "$log" >&2
        return 1
    fi
}

# The update check compares against the latest festival suite tag, so it has to
# read the suite version out of `fest version`, not the fest release, and it has
# to stay quiet when there is no suite version to compare.
update_version_source_check() {
    local tmp fixture fakebin

    case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
        darwin|linux) ;;
        *)
            echo "Skipping update version source check on unsupported host platform"
            return 0
            ;;
    esac

    tmp="$(mktemp -d "${TMPDIR:-/tmp}/festival-plugin-version.XXXXXX")"
    trap 'rm -rf "$tmp"' RETURN
    fixture="$tmp/fixture"
    fakebin="$tmp/fakebin"
    mkdir -p "$fixture" "$fakebin"

    cat > "$fixture/release.json" <<'EOF_JSON'
{
  "tag_name": "v9.9.9",
  "assets": []
}
EOF_JSON
    write_fake_curl "$fakebin/curl"

    # Bundle line present: the suite version wins over the fest release printed
    # on the first line, which is the value the old first-semver read picked up.
    run_update_check "$tmp/bundle" "$fixture" "$fakebin" \
        "fest v0.6.3" "bundle: festival v0.2.17" "commit: 62ebfca" "profile: stable"
    assert_log_contains "$tmp/bundle/log" "Festival update available: v0.2.17 -> v9.9.9"

    # No bundle and no profile line: a bundle published before either existed,
    # which stamped the suite version into fest's own version field.
    run_update_check "$tmp/legacy" "$fixture" "$fakebin" \
        "fest v0.2.17" "commit: 98b9950e"
    assert_log_contains "$tmp/legacy/log" "Festival update available: v0.2.17 -> v9.9.9"

    # Suite already current: no update notice.
    run_update_check "$tmp/current" "$fixture" "$fakebin" \
        "fest v0.6.3" "bundle: festival v9.9.9" "profile: stable"
    assert_no_update_notice "$tmp/current/log" "the bundle matches the latest tag"

    # Bundle-capable fest with no bundle line: built by go install or just build,
    # not from a suite release. There is no suite version to compare, so the
    # fest release must not be mistaken for one and nagged about forever.
    run_update_check "$tmp/noninstalled" "$fixture" "$fakebin" \
        "fest v0.6.3" "commit: 62ebfca" "profile: stable"
    assert_no_update_notice "$tmp/noninstalled/log" "fest was not built from a suite release"

    # `fest version` fails: nothing to compare, so stay quiet rather than guess.
    prepare_update_workdir "$tmp/broken"
    write_failing_stub "$tmp/broken/bin/fest"
    invoke_update_hook "$tmp/broken" "$fixture" "$fakebin"
    assert_no_update_notice "$tmp/broken/log" "fest version exited non-zero"

    # CRLF output: the carriage return must not ride along into the comparison.
    prepare_update_workdir "$tmp/crlf"
    write_version_stub "$tmp/crlf/bin/fest" \
        "fest v0.6.3" "bundle: festival v0.2.17" "profile: stable"
    crlf_version_stub "$tmp/crlf/bin/fest"
    invoke_update_hook "$tmp/crlf" "$fixture" "$fakebin"
    assert_log_contains "$tmp/crlf/log" "Festival update available: v0.2.17 -> v9.9.9"

    # Same, where the bundle already matches: a trailing carriage return used to
    # make an up-to-date suite report an update to the version it already had.
    prepare_update_workdir "$tmp/crlf-current"
    write_version_stub "$tmp/crlf-current/bin/fest" \
        "fest v0.6.3" "bundle: festival v9.9.9" "profile: stable"
    crlf_version_stub "$tmp/crlf-current/bin/fest"
    invoke_update_hook "$tmp/crlf-current" "$fixture" "$fakebin"
    assert_no_update_notice "$tmp/crlf-current/log" "a CRLF bundle line matching the latest tag"
}

mod_manifest_check() {
    node -e '
const fs = require("fs");
const path = require("path");
const dir = process.argv[1];
const hooks = JSON.parse(fs.readFileSync(path.join(dir, "hooks", "hooks.json"), "utf8"));
const plugin = JSON.parse(fs.readFileSync(path.join(dir, ".claude-plugin", "plugin.json"), "utf8"));
const mods = hooks.modules ?? [];
if (mods.length !== 1) throw new Error(`hooks.json must name exactly one hooks module, found ${mods.length}`);
const mod = path.join(dir, "hooks", mods[0]);
if (!fs.existsSync(mod)) throw new Error(`hooks module missing: ${mod}`);
if (plugin.types && !fs.existsSync(path.join(dir, plugin.types))) throw new Error(`plugin types missing: ${plugin.types}`);
const opt = plugin.userConfig?.planningTakeover;
if (!opt || opt.type !== "boolean" || opt.default !== false) throw new Error("userConfig.planningTakeover must be a boolean defaulting to false");
' "$plugin_dir"
}

mod_claude_version_ok() {
    local version
    version="$(claude --version 2>/dev/null | awk '{print $1}')"
    printf '%s\n' "$version" | awk -F. -v want="$MOD_MIN_CLAUDE" '
        BEGIN { split(want, w, ".") }
        { for (i = 1; i <= 3; i++) { if ($i + 0 > w[i] + 0) exit 0; if ($i + 0 < w[i] + 0) exit 1 } exit 0 }
        END { if (NR == 0) exit 1 }'
}

mod_generate_types() {
    local scratch pid watcher
    scratch="$(mktemp -d "${TMPDIR:-/tmp}/festival-plugin-types.XXXXXX")"
    (
        export FESTIVAL_CACHE_DIR="$scratch/cache" INSTALL_DIR="$scratch/bin"
        mkdir -p "$scratch/cwd" && cd "$scratch/cwd" && claude -p "/fest-watch" --setting-sources project --plugin-dir "$plugin_dir" </dev/null >/dev/null 2>&1
    ) &
    pid=$!
    ( sleep 90; kill "$pid" 2>/dev/null ) &
    watcher=$!
    wait "$pid" 2>/dev/null || true
    kill "$watcher" 2>/dev/null || true
    rm -rf "$scratch"
}

MOD_MIN_CLAUDE="2.1.290"
MOD_TYPESCRIPT="typescript@7.0.2"

mod_check() {
    local out types_dir="$plugin_dir/.claude-plugin/types"

    mod_manifest_check
    if ! command -v claude >/dev/null 2>&1; then
        echo "NOTICE: claude not found; skipping the Claude Code mod checks (validate, test, type-check). They need Claude Code $MOD_MIN_CLAUDE or newer; nothing else in Festival does." >&2
        return 0
    fi
    if ! mod_claude_version_ok; then
        echo "NOTICE: claude $(claude --version 2>/dev/null | awk '{print $1}') is older than $MOD_MIN_CLAUDE; skipping the Claude Code mod checks (validate, test, type-check)." >&2
        return 0
    fi

    out="$(claude plugin validate "$plugin_dir" 2>&1)" || {
        printf '%s\n' "$out" >&2
        echo "claude plugin validate failed" >&2
        exit 1
    }
    if printf '%s\n' "$out" | grep -q "Validation failed"; then
        printf '%s\n' "$out" >&2
        exit 1
    fi
    if printf '%s\n' "$out" | grep -q "gating hook without .catch"; then
        printf '%s\n' "$out" >&2
        echo "mod has a gating hook without .catch" >&2
        exit 1
    fi

    claude plugin test "$plugin_dir"

    [ -f "$types_dir/tsconfig.json" ] || mod_generate_types
    if [ -f "$types_dir/tsconfig.json" ]; then
        (cd "$repo_root" && npx -y -p "$MOD_TYPESCRIPT" tsc -p "$plugin_dir")
    else
        echo "NOTICE: skipping the mod type-check: $types_dir was not generated by claude -p" >&2
    fi
}

require_command node
require_command tar
require_command bash
require_command jq

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
bash -n "$repo_root/cursor-plugin/hooks/scripts/cursor-install-hook.sh"
cursor_install_hook_check
opencode_target_check
gemini_target_check "$plugin_dir/.claude-plugin/plugin.json"
hermes_target_check "$plugin_dir/.claude-plugin/plugin.json"
bash -n "$plugin_dir/hooks/scripts/ensure-festival.sh" "$plugin_dir/hooks/scripts/ensure-festival.test.sh" \
    "$plugin_dir/hooks/scripts/sync-check.sh" \
    "$plugin_dir/hooks/scripts/commit-guard.sh" "$plugin_dir/hooks/scripts/commit-guard.test.sh"
for script in "$repo_root/plugins/festival/hooks/scripts/commit-guard.sh" \
    "$repo_root/hooks/scripts/gemini-commit-guard.sh" "$repo_root/.opencode/scripts/commit-guard.sh"; do
    bash -n "$script"
done
bash "$plugin_dir/hooks/scripts/commit-guard.test.sh"
commit_guard_harness_check
bash "$plugin_dir/hooks/scripts/ensure-festival.test.sh"

if [ -x "$repo_root/fest/bin/fest" ] && [ -x "$repo_root/camp/bin/camp" ]; then
    FEST_BIN="$repo_root/fest/bin/fest" CAMP_BIN="$repo_root/camp/bin/camp" \
        bash "$plugin_dir/hooks/scripts/sync-check.sh"
else
    bash "$plugin_dir/hooks/scripts/sync-check.sh"
fi

mod_check
smoke_install_hook
update_version_source_check

echo "Claude plugin smoke passed"
