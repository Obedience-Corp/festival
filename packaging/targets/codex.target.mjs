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
  },
};
