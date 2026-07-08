# Live harness verification: FP0006 generated targets

Intent: `verify-fp0006-generated-harness-plugins-20260615-234116`

Date: 2026-07-08
Worktree: `projects/worktrees/festival/festival-plugin-live-harness`
Branch: `festival-plugin-live-harness`

## Required generated-target checks

- `just plugin generate`: PASS. Generated 52 files from 5 targets at plugin version `1.1.0`.
- `just plugin check`: PASS. Output: `All referenced commands found in CLI. Plugin looks current.` and `Claude plugin smoke passed`.
- `just plugin dist-check`: initially FAIL before the fix in this verification pass because the generated Codex target and dry-run disagreed on the manifest path. The Codex target has been corrected to the documented `.codex-plugin/plugin.json` surface, and the dry-run now checks that path. PASS: all four distribution surfaces were present and no push was performed.

## CLI availability on this machine

| Harness | CLI probe | Result |
|---|---|---|
| Codex | `command -v codex`; `codex --version` | PASS: `/opt/homebrew/bin/codex`, `codex-cli 0.142.5` |
| Cursor | `command -v cursor` | BLOCKED: not found on `PATH` |
| opencode | `command -v opencode` | BLOCKED: not found on `PATH` |
| Gemini | `command -v gemini` | BLOCKED: not found on `PATH` |

## Codex live harness evidence

Live harness scope: local marketplace and plugin install against Codex CLI `0.142.5` using an isolated `CODEX_HOME` under `.tmp-live-harness/codex-home`. The temp directory was only used for the probe and is not part of the committed tree.

Commands:

```bash
export CODEX_HOME="$PWD/.tmp-live-harness/codex-home"
codex plugin marketplace add --json "$PWD"
codex plugin marketplace list
codex plugin list
codex plugin add --json festival@festival
codex plugin list
```

Evidence:

- `codex plugin marketplace add --json "$PWD"` returned `marketplaceName: "festival"` and `alreadyAdded: false`.
- `codex plugin list` found `festival@festival` at `.codex-plugin` before install.
- `codex plugin add --json festival@festival` returned `version: "1.1.0"`, `authPolicy: "ON_INSTALL"`, and an installed cache path.
- `codex plugin list` then reported `festival@festival` as `installed, enabled` at version `1.1.0`.

Result: PASS for local Codex marketplace parsing/install. This proves Codex CLI `0.142.5` accepts the generated `.agents/plugins/marketplace.json`, the generated Codex manifest at `.codex-plugin/plugin.json`, the generated `_generated` JSON keys, and the manifest's `interface` block containing `category: "project-management"` and `capabilities: ["skills", "hooks"]`.

Not proven: the interactive slash-command spelling from the older intent text (`/plugin marketplace add ...` and `/plugin install ...`) was not exercised because this verification used the noninteractive CLI. Codex CLI `0.142.5` exposes `codex plugin add`, not `codex plugin install`, for noninteractive installs.

## Cursor live harness evidence

Result: BLOCKED. `cursor` was not available on `PATH`, so the live `beforeShellExecution` hook working-directory behavior could not be verified.

Structural evidence still present:

- `.cursor-plugin/hooks/hooks.json` contains `beforeShellExecution` with `command: "bash ./hooks/scripts/ensure-festival.sh"`.
- `just plugin check` verifies the generated Cursor manifest and referenced paths structurally.

## opencode live harness evidence

Result: BLOCKED. `opencode` was not available on `PATH`, so native `.opencode/skills/` auto-discovery could not be verified.

Structural evidence still present:

- `.opencode/plugins/festival.js` parses via the existing target check.
- `.opencode/skills/*/SKILL.md` is generated from the canonical plugin skills.

## Gemini live harness evidence

Result: BLOCKED. `gemini` was not available on `PATH`, so `gemini extensions install Obedience-Corp/festival`, the `${extensionPath}` SessionStart hook, and one-level `GEMINI.md` imports could not be verified live.

Structural evidence still present:

- `gemini-extension.json` points to `GEMINI.md` via `contextFileName`.
- `hooks/hooks.json` uses `bash ${extensionPath}/claude-plugin/hooks/scripts/ensure-festival.sh`.
- `just plugin check` verifies the generated Gemini target and referenced paths structurally.

## Remaining blockers

- Install Cursor CLI and re-run Cursor plugin install/hook execution to confirm the `beforeShellExecution` working directory.
- Install opencode CLI and verify `.opencode/skills/` auto-discovery.
- Install Gemini CLI and verify extension install, SessionStart hook execution, and one-level `GEMINI.md` import loading.
- If Codex interactive slash-command syntax is still required as a product claim, verify it manually in a Codex interactive session; the noninteractive CLI path is confirmed here.
