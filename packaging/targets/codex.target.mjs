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
/plugin marketplace add Obedience-Corp/festival
/plugin install festival
\`\`\`

The bundled \`SessionStart\` command hook then runs
\`bash \${PLUGIN_ROOT}/hooks/scripts/ensure-festival.sh\` on every session start to auto-install the
\`fest\` and \`camp\` CLIs. The script is idempotent (it no-ops when they are already current),
mirroring the Claude Code hook, so no manual step is required after \`/plugin install festival\`.
`;
}

function codexHooks(ctx) {
  // Codex mirrors only the SessionStart install hook. Other event types in the
  // Claude source (e.g. the PreToolUse commit guard) are Claude-Code-specific:
  // they depend on Claude's tool-call payload schema and exit-code semantics,
  // which Codex does not share, so we do not fake them here.
  const source = ctx.sourceHooks.SessionStart
    ? { SessionStart: ctx.sourceHooks.SessionStart }
    : {};
  const swapped = JSON.parse(
    JSON.stringify(source).replaceAll("${CLAUDE_PLUGIN_ROOT}", "${PLUGIN_ROOT}"),
  );
  return { _generated: ctx.banner, ...swapped };
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
        source: { source: "local", path: "./.codex-plugin" },
        author: m.author,
      },
    ],
  };
}

export default {
  harness: "codex",
  manifests: [".codex-plugin/.codex-plugin/plugin.json"],
  emit(ctx) {
    const m = ctx.manifest;
    ctx.writeJSON(".codex-plugin/.codex-plugin/plugin.json", {
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
    ctx.writeJSON(".codex-plugin/hooks/hooks.json", codexHooks(ctx));
    ctx.writeText(".codex-plugin/hooks/scripts/ensure-festival.sh", ctx.bundledScript("hooks/scripts/ensure-festival.sh"));
    for (const skill of ctx.skills) {
      ctx.writeText(`.codex-plugin/skills/${skill.name}/SKILL.md`, ctx.readPluginFile(skill.path));
    }
    ctx.writeJSON(".agents/plugins/marketplace.json", codexMarketplace(ctx));
    ctx.writeText(".codex-plugin/README.md", readme(ctx));
  },
};
