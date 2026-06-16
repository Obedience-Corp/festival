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
  },
};
