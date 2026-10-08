const COMMIT_GUARD = "hooks/scripts/gemini-commit-guard.sh";

function context(ctx) {
  const imports = ctx.skills.map((s) => `@./claude-plugin/skills/${s.name}/SKILL.md`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival

Festival is a goal-oriented project management methodology for human and AI development
workflows, driven by the \`fest\` and \`camp\` CLIs, installed and kept in sync by a third tool,
\`festival\`. The skills imported below describe how to plan and execute festivals. Load them when
working with festivals, phases, sequences, or tasks.

The \`fest\` and \`camp\` CLIs install automatically on session start via the bundled
\`hooks/hooks.json\` SessionStart hook (idempotent, per \`packaging/survey/gemini.md\`). If that hook
cannot run, install them by hand:

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
\`\`\`

Inside a camp, a \`BeforeTool\` hook refuses a raw \`git commit\` and returns the reason as the tool
error. Commit with \`camp commit\` at the camp root, \`camp p commit\` inside \`projects/*\`, or
\`fest commit\` during a festival instead; the \`campaign-commit\` skill explains which.

${imports}
`;
}

function withBanner(ctx, script) {
  const nl = script.indexOf("\n");
  return script.slice(0, nl + 1) + `# ${ctx.banner}\n` + script.slice(nl + 1);
}

function geminiHooks(ctx) {
  return {
    _generated: ctx.banner,
    hooks: {
      SessionStart: [
        {
          matcher: "startup",
          hooks: [
            {
              name: "festival-install",
              type: "command",
              command: "bash ${extensionPath}/claude-plugin/hooks/scripts/ensure-festival.sh",
            },
          ],
        },
      ],
      BeforeTool: [
        {
          matcher: "^run_shell_command$",
          hooks: [
            {
              name: "festival-commit-guard",
              type: "command",
              command: `bash "\${extensionPath}/${COMMIT_GUARD}"`,
              description: "Block a raw git commit inside a camp; camp and fest have their own commit commands.",
            },
          ],
        },
      ],
    },
  };
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
    ctx.writeJSON("hooks/hooks.json", geminiHooks(ctx));
    ctx.writeText(COMMIT_GUARD, withBanner(ctx, ctx.readTemplate("gemini", "sh")));
  },
};
