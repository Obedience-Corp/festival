function context(ctx) {
  const imports = ctx.skills.map((s) => `@./claude-plugin/skills/${s.name}/SKILL.md`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival

Festival is a goal-oriented project management methodology for human and AI development
workflows, driven by the \`fest\` and \`camp\` CLIs. The skills imported below describe how to plan
and execute festivals. Load them when working with festivals, phases, sequences, or tasks.

${imports}
`;
}

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
    ctx.writeText("GEMINI.md", context(ctx));
  },
};
