function readme(ctx) {
  const skills = ctx.skills.map((s) => `  - \`${s.name}\` — ${s.description}`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival on Codex

The Codex plugin manifest (\`.codex-plugin/plugin.json\`) carries exactly the surfaces Codex
supports as plugin components, per \`packaging/survey/codex.md\` and \`packaging/survey/MATRIX.md\`.

## Bundled

- **Skills** (\`skills: "./skills/"\`) — ${ctx.skills.length} skills:
${skills}
- **Session-start hook** (\`hooks: "./hooks/hooks.json"\`) — runs \`ensure-festival.sh\` to install
  and update the \`fest\` and \`camp\` CLIs on every session start (idempotent).
- **AGENTS.md** — read automatically by Codex as persistent instructions.

## Not bundled on Codex (documented gap, not faked)

- **Commands** — Festival's ${ctx.commands.length} slash commands do NOT ship as Codex plugin
  components. Codex custom prompts are deprecated in favor of skills, and the manifest spec has no
  \`commands\` field. The same workflows run through the \`fest\`/\`camp\` CLIs that the hook installs.
- **Agents** — Festival's ${ctx.agents.length} agents do NOT ship as Codex plugin components. Codex
  subagents are config-scope only (\`~/.codex/agents/\`, \`.codex/agents/\` TOML), not manifest-bundled.
`;
}

export default {
  harness: "codex",
  manifests: [".codex-plugin/plugin.json"],
  emit(ctx) {
    const m = ctx.manifest;
    ctx.writeJSON(".codex-plugin/plugin.json", {
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
    ctx.writeText(".codex-plugin/README.md", readme(ctx));
  },
};
