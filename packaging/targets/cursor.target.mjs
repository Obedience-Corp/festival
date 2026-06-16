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
  },
};
