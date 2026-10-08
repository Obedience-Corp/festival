const CODEX_PLUGIN_ROOT = "plugins/festival";
const CODEX_EVENTS = ["SessionStart", "PreToolUse"];

function readme(ctx) {
  const skills = ctx.skills.map((s) => `  - \`${s.name}\`: ${s.description}`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival on Codex

The Codex plugin manifest (\`.codex-plugin/plugin.json\`) carries exactly the surfaces Codex
supports as plugin components, per \`packaging/survey/codex.md\` and \`packaging/survey/MATRIX.md\`.

## Bundled

- **Skills** (\`skills: "./skills/"\`), ${ctx.skills.length} skills:
${skills}
- **Session-start hook** (\`hooks: "./hooks/hooks.json"\`) runs \`ensure-festival.sh\` to install
  and update the \`fest\` and \`camp\` CLIs on every session start (idempotent).
- **Commit guard** (\`PreToolUse\`, matcher \`Bash\`) runs \`commit-guard.sh\` before each shell
  command and blocks a raw \`git commit\` inside a camp. See below.

The repo-root \`AGENTS.md\` (not part of this bundle) describes the plugin and is read by Codex as
workspace instructions when you work in the Festival repo.

## Not bundled on Codex (documented gap, not faked)

- **Commands**: Festival's ${ctx.commands.length} slash commands do NOT ship as Codex plugin
  components. Codex custom prompts are deprecated in favor of skills, and the manifest spec has no
  \`commands\` field. The same workflows run through the \`fest\`/\`camp\` CLIs that the hook installs.
- **Agents**: Festival's ${ctx.agents.length} agents do NOT ship as Codex plugin components. Codex
  subagents are config-scope only (\`~/.codex/agents/\`, \`.codex/agents/\` TOML), not manifest-bundled.

## Install

Codex installs from the self-hosted marketplace (per the \`survey/codex.md\` distribution decision;
OpenAI's official directory has no self-serve publishing yet):

\`\`\`
codex plugin marketplace add Obedience-Corp/festival
codex plugin add festival@festival
\`\`\`

The bundled \`SessionStart\` command hook then runs
\`bash \${PLUGIN_ROOT}/hooks/scripts/ensure-festival.sh\` on every session start to auto-install the
\`fest\` and \`camp\` CLIs. The script is idempotent (it no-ops when they are already current),
mirroring the Claude Code hook, so no manual step is required after \`codex plugin add festival@festival\`. Inside a Codex session,
\`/plugins\` opens the plugin browser, where the same plugin can be installed.

Codex skips plugin-bundled hooks until you review and trust them. After installing or updating
the plugin, open \`/hooks\` in a Codex session and trust the Festival hooks; until then neither the
installer nor the commit guard runs.

\`hooks/hooks.json\` is generated like the rest of this bundle but carries no \`_generated\` key:
Codex rejects any top-level key other than \`description\` and \`hooks\` in a plugin hooks file and
then loads none of its hooks.

## Commit guard

The \`PreToolUse\` hook runs \`bash \${PLUGIN_ROOT}/hooks/scripts/commit-guard.sh\`, the same script
the Claude Code bundle ships, byte for byte apart from the generated banner. Codex sends the shell
command as \`tool_input.command\` and the session directory as \`cwd\`, which is the input the script
already reads. The script blocks only when both hold:

- the command has a raw \`git commit\` segment (\`camp commit\`, \`camp p commit\`, and \`fest commit\`
  pass), and
- \`camp id\` succeeds in the session directory, so the session is inside a camp.

A block exits 2 with the reason on stderr, which Codex returns to the model in place of the command
output. Every other path exits 0 with no output, including a missing \`camp\` or \`jq\` and input the
script cannot parse, so the guard never blocks outside a camp and never approves anything. Set
\`CAMP_ALLOW_RAW_GIT=1\` to allow one raw commit deliberately.
`;
}

function codexHooks(ctx) {
  // Codex mirrors the SessionStart installer and the PreToolUse commit guard.
  // Codex's PreToolUse input matches Claude's for the shell tool (`Bash` matches
  // both shell and exec_command; `tool_input.command` holds the command string;
  // `cwd` is the session directory), and exit 2 with a reason on stderr blocks,
  // so commit-guard.sh runs unchanged. Both harnesses nest the event map under a
  // top-level "hooks" key; a bare event map fails to load. Codex also rejects any
  // other top-level key in a plugin hooks file ("unknown field `_generated`,
  // expected `description` or `hooks`" on codex-cli 0.161.0, which drops every
  // hook in the file), so this file carries no banner; the README records it.
  const events = ctx.sourceHooks.hooks ?? {};
  const source = {};
  for (const event of CODEX_EVENTS) {
    if (events[event]) source[event] = events[event];
  }
  const swapped = JSON.parse(
    JSON.stringify(source).replaceAll("${CLAUDE_PLUGIN_ROOT}", "${PLUGIN_ROOT}"),
  );
  return {
    description: ctx.sourceHooks.description ?? ctx.manifest.description,
    hooks: swapped,
  };
}

function codexMarketplace(ctx) {
  const m = ctx.manifest;
  return {
    _generated: ctx.banner,
    name: m.name,
    description: m.description,
    owner: m.author,
    plugins: [
      {
        name: m.name,
        description: m.description,
        version: m.version,
        source: { source: "local", path: `./${CODEX_PLUGIN_ROOT}` },
        author: m.author,
      },
    ],
  };
}

export default {
  harness: "codex",
  manifests: [`${CODEX_PLUGIN_ROOT}/.codex-plugin/plugin.json`],
  emit(ctx) {
    const m = ctx.manifest;
    ctx.writeJSON(`${CODEX_PLUGIN_ROOT}/.codex-plugin/plugin.json`, {
      _generated: ctx.banner,
      name: m.name,
      version: m.version,
      description: m.description,
      author: m.author,
      homepage: m.homepage,
      repository: m.repository,
      license: m.license,
      keywords: m.keywords,
      ...ctx.readTemplateJSON("codex"),
    });
    ctx.writeJSON(`${CODEX_PLUGIN_ROOT}/hooks/hooks.json`, codexHooks(ctx));
    ctx.writeText(`${CODEX_PLUGIN_ROOT}/hooks/scripts/ensure-festival.sh`, ctx.bundledScript("hooks/scripts/ensure-festival.sh"));
    ctx.writeText(`${CODEX_PLUGIN_ROOT}/hooks/scripts/commit-guard.sh`, ctx.bundledScript("hooks/scripts/commit-guard.sh"));
    for (const skill of ctx.skills) {
      ctx.writeText(`${CODEX_PLUGIN_ROOT}/skills/${skill.name}/SKILL.md`, ctx.readPluginFile(skill.path));
    }
    ctx.writeJSON(".agents/plugins/marketplace.json", codexMarketplace(ctx));
    ctx.writeText(`${CODEX_PLUGIN_ROOT}/README.md`, readme(ctx));
  },
};
