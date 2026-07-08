# FP0006 acceptance verification log

Evidence for each acceptance criterion in `002_PLAN/plan/IMPLEMENTATION_PLAN.md`. Every check was run
against the committed tree; commands are reproducible.

## AC1: `just plugin generate` is idempotent

- Command: `just plugin generate` twice, then `diff -r` the two output trees.
- Result: PASS. The second run is byte-identical to the first across `.codex-plugin/`,
  `.cursor-plugin/`, `.opencode/`, `.agents/`, `hooks/`, `gemini-extension.json`, `GEMINI.md`,
  `AGENTS.md`.

## AC2: the drift test bites on a forced edit and restores green

- Command: append a line to a committed target (e.g. `.opencode/plugins/festival.js`), run
  `just plugin check`, then `just plugin generate` and re-check.
- Result: PASS. `generated_targets_check` exits non-zero naming the drifted file; regenerating
  restores green.

## AC3: every target exists, is structurally valid, and referenced paths resolve

- Present: `.codex-plugin/.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, `.opencode/plugins/festival.js`,
  `gemini-extension.json`, `GEMINI.md`, `AGENTS.md`, `.agents/plugins/marketplace.json`.
- Structural validity: `codex_target_check`, `cursor_target_check`, `opencode_target_check`, and
  `gemini_target_check` (run inside `just plugin check`) assert each parses, has required keys, and
  every referenced path (skills/commands/agents/hooks/installer/@-imports/marketplace source) resolves
  without escaping its bundle.
- Result: PASS.

## AC4: `just plugin bump` updates every manifest; a forced mismatch bites

- Command: `just plugin bump 1.1.2`; read the version from plugin.json, marketplace.json,
  `.codex-plugin/.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, `gemini-extension.json`, and
  `.agents/plugins/marketplace.json`; then force a mismatch in a target and run `just plugin check`.
- Result: PASS. All six manifests read `1.1.2` after the bump; a hand-set `0.0.1` in
  `.cursor-plugin/plugin.json` makes `just plugin check` exit non-zero. Restored to `1.1.0`, check green.

## AC5: each target's install matches its MATRIX decision (with citation)

- Codex: `SessionStart` command hook in `.codex-plugin/hooks/hooks.json` (`${PLUGIN_ROOT}`).
- Cursor: blocking `beforeShellExecution` hook in `.cursor-plugin/hooks/hooks.json` (its `sessionStart`
  is fire-and-forget).
- opencode: the plugin body runs `ensure-festival.sh` at load via the Bun shell.
- Gemini: `SessionStart` command hook in the repo-root `hooks/hooks.json` (`${extensionPath}`).
- Citations: each target's README/INSTALL cites `packaging/survey/<harness>.md`.
- Result: PASS.

## AC6: each distribution path dry-runs with no live push

- Command: `just plugin dist-check`.
- Result: PASS. Confirms the Codex `.agents/plugins/marketplace.json`, `.cursor-plugin/`, `.opencode/`,
  and `gemini-extension.json` + `GEMINI.md` surfaces are present and prints each install command; no
  external push is performed. Channels are recorded in `packaging/DISTRIBUTION.md`.

## AC7: `just plugin check` passes with the new checks

- Command: `just plugin check`.
- Result: PASS (drift, version-consistency, the four `<harness>_target_check` steps, and the FP0005
  install smoke). The full `just test all` camp/fest Go legs are the pre-existing out-of-scope
  exception called out in the acceptance criteria and are not run here.

## AC8: docs document the layout and source-of-truth convention

- Present: `packaging/README.md` (multi-target layout, source-of-truth rule, generate/drift/version,
  distribution), `packaging/DISTRIBUTION.md`, root `AGENTS.md`, `.codex-plugin/README.md`,
  `.cursor-plugin/README.md`, `.opencode/INSTALL.md`.
- Result: PASS.
