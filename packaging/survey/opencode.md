# Survey: opencode plugins (verified 2026-06-16)

Verdict: STRONG fit (best for auto-install). Repo moved org: now github.com/anomalyco/opencode
(formerly sst/opencode). Docs at opencode.ai/docs.

## Plugin model
- JS/TS module exporting `Plugin = (input) => Promise<Hooks>` from `@opencode-ai/plugin`.
- Locations: project `.opencode/plugins/`, global `~/.config/opencode/plugins/`; or declared in
  `opencode.json` `plugin` array (npm pkg, scoped pkg, or git URL).
- Context input: `client`, `project`, `directory`, `worktree`, `serverUrl`, `$` (Bun shell),
  `experimental_workspace`.
- The exported function body runs ONCE at load (the setup/bootstrap point).
- Source: https://opencode.ai/docs/plugins/ ; SDK `packages/plugin/src/index.ts`

## Capability surface
- Skills: YES, native auto-discovery from `.opencode/skills/<name>/SKILL.md`,
  `~/.config/opencode/skills/`, AND `.claude/skills/<name>/SKILL.md` (and `.agents/skills/`). So the
  Festival source skills are discoverable nearly as-is. Also programmatic via the `config` hook.
  Source: https://opencode.ai/docs/skills/
- Commands: YES, markdown `commands/<name>.md`. Agents: YES, markdown `agents/<name>.md`.
  Source: https://opencode.ai/docs/commands/ ; .../agents/
- Setup code at load: YES (function body).

## Install decision
AUTO-INSTALL (strongest): the plugin context `$` is Bun's shell; the function body is async, so
`await $\`...installer...\`` downloads + installs `fest`/`camp` at load with full host exec/fs access
(no documented sandbox). Detect-or-download in the body, then rely on native skills auto-discovery.
Source: https://opencode.ai/docs/plugins/

## Distribution decision
No official curated marketplace. Distribute as an npm package (`npm publish`/`bun publish`), a scoped
package, or a git URL referenced in `opencode.json` `plugin` array. Community list:
github.com/awesome-opencode/awesome-opencode. No review pipeline.
Source: https://opencode.ai/docs/config/ ; https://opencode.ai/docs/plugins/

## Flags
- The `config` hook and the `package.json`+`bun install` dep mechanism are best-evidenced by the SDK
  type source + community guides, not a single official doc page. The `$`-shell install path IS
  officially documented and is sufficient.
- Dir name is `plugins/` (plural) in current docs; older refs use `plugin/` (singular).
