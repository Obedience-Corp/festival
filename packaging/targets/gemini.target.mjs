export default {
  harness: "gemini",
  manifests: ["gemini-extension.json"],
  emit(ctx) {
    const m = ctx.manifest;
    ctx.writeJSON("gemini-extension.json", {
      _generated: ctx.banner,
      name: m.name,
      version: m.version,
      description: m.description,
      ...ctx.readTemplateJSON("gemini"),
    });
  },
};
