function readme(ctx) {
  const skills = ctx.skills.map((s) => `  - \`${s.name}\``).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival on Cursor

The Cursor plugin manifest (\`.cursor-plugin/plugin.json\`) bundles every Festival surface Cursor
supports as plugin components, per \`packaging/survey/cursor.md\` and \`packaging/survey/MATRIX.md\`.

## Bundled (all four surfaces)

- **Skills** (\`skills: "./skills/"\`) — ${ctx.skills.length}:
${skills}
- **Commands** (\`commands: "./commands/"\`) — ${ctx.commands.length} slash commands.
- **Agents** (\`agents: "./agents/"\`) — ${ctx.agents.length} agents.
- **Hooks** (\`hooks: "./hooks/hooks.json"\`) — the blocking install hook described below.

## Install

Auto-install, per the \`survey/cursor.md\` decision (D003). Cursor's \`sessionStart\` is
fire-and-forget (the agent loop does not wait for it), so a binary install is not guaranteed
complete before first use. Instead the install runs via a BLOCKING \`beforeShellExecution\` hook
that runs \`bash ./hooks/scripts/ensure-festival.sh\` before shell execution: the first shell
command blocks until \`fest\`/\`camp\` are installed. The script is idempotent and rate-limits its
update check to once per day, and writes only to stderr, so it does not delay or block later
commands. No manual step is required after installing the plugin from the Cursor Marketplace.
`;
}

function cursorHooks(ctx) {
  return {
    _generated: ctx.banner,
    version: 1,
    hooks: {
      beforeShellExecution: [{ command: "bash ./hooks/scripts/ensure-festival.sh" }],
    },
  };
}

function bundledInstaller(ctx) {
  const src = ctx.readPluginFile("hooks/scripts/ensure-festival.sh");
  const nl = src.indexOf("\n");
  return src.slice(0, nl + 1) + `# ${ctx.banner}\n` + src.slice(nl + 1);
}

export default {
  harness: "cursor",
  manifests: [".cursor-plugin/plugin.json"],
  emit(ctx) {
    const m = ctx.manifest;
    ctx.writeJSON(".cursor-plugin/plugin.json", {
      _generated: ctx.banner,
      name: m.name,
      version: m.version,
      description: m.description,
      author: m.author,
      homepage: m.homepage,
      repository: m.repository,
      license: m.license,
      keywords: m.keywords,
      ...ctx.readTemplateJSON("cursor"),
    });
    for (const skill of ctx.skills) {
      ctx.writeText(`.cursor-plugin/skills/${skill.name}/SKILL.md`, ctx.readPluginFile(skill.path));
    }
    for (const command of ctx.commands) {
      ctx.writeText(`.cursor-plugin/commands/${command.name}.md`, ctx.readPluginFile(command.path));
    }
    for (const agent of ctx.agents) {
      ctx.writeText(`.cursor-plugin/agents/${agent.name}.md`, ctx.readPluginFile(agent.path));
    }
    ctx.writeJSON(".cursor-plugin/hooks/hooks.json", cursorHooks(ctx));
    ctx.writeText(".cursor-plugin/hooks/scripts/ensure-festival.sh", bundledInstaller(ctx));
    ctx.writeText(".cursor-plugin/README.md", readme(ctx));
  },
};
