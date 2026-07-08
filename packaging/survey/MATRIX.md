# Capability Matrix (verified 2026-06-16)

All four harness plugin formats were verified against current docs (decision D005). The Superpowers
v5.1.0 snapshot was directionally right but is NOT the spec; per-target citations are in the sibling
survey docs. Headline: all four targets are VIABLE; none dropped.

## Matrix

| Capability | Claude Code (FP0005) | Codex | Cursor | opencode | Gemini |
|---|---|---|---|---|---|
| Plugin system current | yes | yes | yes (2.5, Feb'26) | yes | yes |
| Manifest | `.claude-plugin/` | `plugins/festival/.codex-plugin/plugin.json` | `.cursor-plugin/plugin.json` | `opencode.json`/`.opencode/plugins/*.js` | `gemini-extension.json` |
| Skills (`<name>/SKILL.md`) | yes | yes | yes | yes (auto-discovers `.claude/skills/`) | via GEMINI.md `@`-imports |
| Commands bundled | yes | NO (deprecated/config-scope) | yes | yes (markdown) | yes (TOML) |
| Agents bundled | yes | NO (config-scope only) | yes | yes (markdown) | yes |
| Session-start shell hook | yes | yes (command) | yes but fire-and-forget | yes (JS `$` at load) | yes (command) |
| Auto-install CLI | yes | yes | yes (use blocking hook/MCP, not sessionStart) | yes (best) | yes |
| External distribution | repo-root marketplace.json | self-host marketplace.json + `/plugin add` (no self-serve official yet) | Cursor Marketplace git submit (manual review) | npm/git in config; no official registry | `gemini extensions install org/repo` + auto-gallery |

## Install decision per target (D003, revised)

Auto-install is achievable on ALL FOUR via a session-start-style shell hook (this reverses the
planned "Gemini = manual"). The hook contract is nearly identical across Claude Code, Codex, and
Gemini (`hooks/hooks.json` + a `SessionStart` `type: command`), and opencode achieves the same via a
JS plugin whose async body runs `$` at load. Cursor is the only exception: `sessionStart` is
fire-and-forget, so use a blocking `preToolUse`/`beforeShellExecution` hook, an MCP server, or an
explicit install command. Every install path must be idempotent (re-fires each startup).

Implication: the install behavior is a LARGELY SHARED artifact, not four bespoke ones.

## Distribution decision per target (D006, revised)

There is no unified fork-PR sync (the Superpowers `openai-codex-plugins` flow is unverified). Each
harness has its own native channel:
- Codex: ship `plugins/festival/` + a repo-root marketplace.json; `/plugin marketplace add Obedience-Corp/festival` (official self-serve directory not open yet).
- Cursor: submit the git repo at cursor.com/marketplace/publish (manual review) + `.cursor-plugin/marketplace.json`.
- opencode: git URL in `opencode.json` `plugin` array or npm publish; list on awesome-opencode.
- Gemini: `gemini extensions install Obedience-Corp/festival` + add the `gemini-cli-extension` repo topic.

Implication: distribution is "produce the right manifests + repo topics + one Cursor submission,"
NOT a sync-to-fork script.

## Plan-impacting findings (vs the committed IMPLEMENTATION_PLAN)

1. No target dropped. All four are STRONG.
2. D003: all four AUTO-install (Cursor via a non-sessionStart hook); the install hook is largely
   shared with the Claude Code one, not per-target bespoke. Reverses "Gemini = manual."
3. Codex: skills + hook + AGENTS.md only; commands/agents do NOT bundle. The Codex capability-map
   task degrades commands/agents (documented), unlike Cursor/opencode/Gemini which DO carry them.
4. Seq 07 (distribution): the `sync-to-codex.sh` fork-PR script is built on an unverified premise and
   should be DROPPED. Replace with per-harness native distribution manifests + a `DISTRIBUTION.md`.
5. Source skills are nearly portable as-is (`<name>/SKILL.md` everywhere; opencode reads `.claude/skills/`),
   so the generator's skills job is mostly path/manifest wiring, not transformation.
6. Gemini `@`-imports are non-recursive (one level from GEMINI.md) -- already matches the plan.
