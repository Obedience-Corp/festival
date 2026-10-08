# Festival multi-agent packaging

This directory generates the Festival plugin's per-harness targets from a single source of truth:
the Claude Code bundle at `claude-plugin/`. Targets are NEVER hand-edited; a drift test enforces it.

See `survey/MATRIX.md` for the verified per-harness facts these decisions rest on.

## Source of truth

`claude-plugin/` is canonical:
- `claude-plugin/.claude-plugin/plugin.json`: name, version, description, author, repository, keywords.
- `claude-plugin/skills/<name>/SKILL.md`: the 12 skills (portable nearly as-is across harnesses).
- `claude-plugin/commands/*.md`, `claude-plugin/agents/*.md`: carried where a harness supports them.
- `claude-plugin/hooks/scripts/ensure-festival.sh`: the CLI install/update logic, reused by every
  harness's session-start hook.
- `claude-plugin/hooks/scripts/commit-guard.sh`: the raw `git commit` guard, reused by every harness
  whose pre-tool hook can block a shell command.

## Derived vs per-target template

The generator computes the **derived** fields once and merges them with a small committed
**per-target template** that holds only harness-specific metadata.

- Derived (from the source, identical everywhere): `name`, `version`, `description`, the skills list,
  and (where applicable) commands/agents references.
- Per-target template (`packaging/targets/<harness>.*`): the bits only that harness has, e.g. the
  Codex `interface` block, the opencode JS plugin body, the Gemini extension keys.

## Targets and output locations (as built)

Each target is a self-registering module under `packaging/targets/<harness>.target.mjs` that the
generator discovers and runs. Bundled skills/commands/agents are byte-identical copies of the source.

| Target | Output | Template | Notes (per survey) |
|---|---|---|---|
| Codex | `plugins/festival/` (`.codex-plugin/plugin.json`, `hooks/`, `skills/`, `README.md`) + `.agents/plugins/marketplace.json` | `targets/codex.template.json` | skills + SessionStart hook + PreToolUse commit guard + `AGENTS.md`; commands/agents documented as not bundled |
| Cursor | `cursor-plugin/` (`.cursor-plugin/plugin.json`, `skills/`, `commands/`, `agents/`, `hooks/`, `README.md`) + `.cursor-plugin/marketplace.json` | `targets/cursor.template.json`, `targets/cursor.template.sh` (the hook wrapper) | all four surfaces bundle; Cursor loads the directory that contains `.cursor-plugin/` as the plugin root, so the repo-root `.cursor-plugin/` holds only `marketplace.json` |
| opencode | `.opencode/` (`plugins/festival.js`, `scripts/`, `skills/`, `INSTALL.md`) | `targets/opencode.template.js` | JS runs the installer at load and the commit guard in `tool.execute.before`; skills via `.opencode/skills/` auto-discovery |
| Gemini | `gemini-extension.json` + `GEMINI.md` + `hooks/hooks.json` + `hooks/scripts/gemini-commit-guard.sh` | `targets/gemini.template.json`, `targets/gemini.template.sh` (the commit guard adapter) | `GEMINI.md` `@`-imports each SKILL.md (one level); the repo-root `hooks/hooks.json` is the Gemini extension hook file (SessionStart installer + BeforeTool commit guard) |
| Hermes | root `skills/` (tap layout `skills/<name>/SKILL.md` + `skills/README.md`) + root `skills.sh.json` | none (metadata lives in `targets/hermes.target.mjs`) | skills only; frontmatter augmented with `version`/`author`/`license`/`metadata.hermes.*`, body byte-identical; commands/agents/session-start hook documented as unavailable |
| docs | root `AGENTS.md` | generated in `targets/agents.target.mjs` | describes the plugin; no coercion (D007) |

Install behavior (D003): every plugin-shaped harness auto-installs the `fest`/`camp` CLIs via
`ensure-festival.sh` (idempotent). Codex and Gemini use a `SessionStart` command hook; Cursor uses a
`sessionStart` hook whose command, `hooks/scripts/cursor-install-hook.sh`, runs the installer with
its output on stderr and prints `{}` on stdout (deliberately not a permission hook such as
`beforeShellExecution`, which would have to answer allow, deny, or ask for every shell command);
opencode runs the installer in its plugin body at load. Codex/Cursor bundle the installer under their plugin root;
Gemini and opencode reference the in-repo script (`${extensionPath}` / `import.meta.url`). Hermes is
the exception: an installed skill gets no hook to run, so its generated `skills/README.md` and the
docs page lead with the one-time CLI install instead.

Commit guard: `commit-guard.sh` reads one JSON object on stdin, the command as
`tool_input.command` and the directory as `cwd`, blocks a raw `git commit` inside a camp with exit 2
and the reason on stderr, and otherwise exits 0 with no output. It never prints a decision, so no
harness can read it as an approval. Codex's `PreToolUse` input for the shell tool is that same shape
and Codex blocks on exit 2, so the Codex bundle carries a byte copy (plus banner) behind a
`PreToolUse` hook with matcher `Bash`. Gemini's `BeforeTool` input is the same shape too, but its
command can run in `tool_input.dir_path`, and Gemini also denies on exit codes other than 0 and 1
when the hook printed text, so `hooks/scripts/gemini-commit-guard.sh` points `cwd` at `dir_path` and
passes through only the guard's exit 2. opencode has no command hook, so `.opencode/plugins/festival.js`
runs a bundled copy of the guard from `tool.execute.before` and throws with its reason on exit 2.
Cursor gets no guard: its only pre-shell hook is the `beforeShellExecution` permission hook, which
must answer allow, deny, or ask for every command, and Cursor does not document whether an allow
skips the user's approval prompt. Hermes has no hook surface in the tap.

The installer's update check reads GitHub Releases (`/releases/latest`) and depends on the current
response shape (the `tag_name` and `browser_download_url` fields, verified 2026-06-16); it uses
`grep`/`sed` rather than a `jq` dependency to keep the bootstrap dependency-free. If that shape
changes, the relevant function returns empty and the user falls back to the documented manual
install, so a shape change degrades gracefully rather than breaking. Update checks are rate-limited
to once per day and downloads are checksum-verified before install.

## Generator CLI contract

- `just plugin generate` runs `node packaging/generate.mjs`, which emits every enabled target.
- Deterministic: stable key order, trailing newline, no `Date.now()`/random. Running it twice
  produces a byte-identical tree (constraint C5). Reuses `node`/`bash` only (no new host dep, C3).
- Every generated file begins with a banner: `GENERATED by packaging/generate.mjs from claude-plugin/.
  Do not edit; edit the source and re-run 'just plugin generate'.` (JSON carries it via a
  `"_generated"` key since JSON has no comments; JS/MD use a comment line.)
- Four documented exceptions carry no banner: a generated `SKILL.md` cannot (its YAML frontmatter must
  start on line 1, and every harness copies the body verbatim), `skills.sh.json` cannot (the
  published skills.sh schema sets `additionalProperties: false`, so a `"_generated"` key would make
  the file invalid), and neither do the Cursor JSON files (`cursor-plugin/.cursor-plugin/plugin.json`,
  `cursor-plugin/hooks/hooks.json`, `.cursor-plugin/marketplace.json`), because Cursor documents no
  tolerance for unknown keys and its marketplace review requires a valid manifest. Nor does the Codex
  `plugins/festival/hooks/hooks.json`: Codex rejects any top-level key other than `description` and
  `hooks` in a plugin hooks file (``unknown field `_generated` ``, codex-cli 0.161.0) and then loads none
  of its hooks. The generated `skills/README.md`, `cursor-plugin/README.md`, and
  `plugins/festival/README.md` record the provenance.

## Drift-test contract

- `scripts/test_claude_plugin.sh` gains a `generated_targets_check`: regenerate into a temp dir, diff
  each committed target against the fresh output, exit non-zero naming the first drifted file.
- Wired after the FP0005 checks so `just plugin check` (and thus `just test all`) runs it.
- A hand-edit to any committed target makes the gate fail; re-running `just plugin generate` restores green.

## Version consistency (D004)

`plugin.json` `version` is the single source. `just plugin bump <version>` bumps it and regenerates
(so every target inherits it); `manifest_consistency_check` asserts every target manifest equals
`plugin.json` (driven by `node packaging/generate.mjs --manifests`).

## Distribution (D006)

Each harness uses its own native channel; there is no fork-PR sync. Codex and Cursor each get a
generated marketplace artifact (`.agents/plugins/marketplace.json`, `.cursor-plugin/marketplace.json`);
Cursor's public listing is still a manual Cursor Marketplace submission, and opencode and Gemini
install straight from the git repo. Hermes installs from the generated root
`skills/` tap (`hermes skills tap add Obedience-Corp/festival`), which is the same layout skills.sh
reads, so `npx skills add Obedience-Corp/festival` works from the identical tree. `packaging/DISTRIBUTION.md` records every
channel with its install command, and `just plugin dist-check` confirms each surface is present
without performing any live push.
