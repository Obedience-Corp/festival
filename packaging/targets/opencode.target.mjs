export default {
  harness: "opencode",
  manifests: [],
  emit(ctx) {
    const plugin = ctx.readTemplate("opencode", "js").replaceAll("__VERSION__", ctx.manifest.version);
    ctx.writeText(".opencode/plugins/festival.js", plugin, "//");
    ctx.writeText(".opencode/scripts/ensure-festival.sh", ctx.bundledScript("hooks/scripts/ensure-festival.sh"));
    for (const skill of ctx.skills) {
      ctx.writeText(`.opencode/skills/${skill.name}/SKILL.md`, ctx.readPluginFile(skill.path));
    }
  },
};
