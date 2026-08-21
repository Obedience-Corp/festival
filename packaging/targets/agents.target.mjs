function agentsMd(ctx) {
  const skills = ctx.skills.map((s) => `- \`${s.name}\`: ${s.description}`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival

Festival is a goal-oriented project management methodology for human and AI development workflows,
driven by the \`fest\` and \`camp\` CLIs, installed and kept in sync by a third tool, \`festival\`.
It organizes work as festivals made of phases, sequences, and tasks, with quality gates between them.

## What ships

- The \`fest\` and \`camp\` CLIs, which the session-start hook installs and keeps current.
- \`festival\`, the suite installer and updater. The session-start hook does not manage it; install
  it yourself from the [installation guide](https://docs.fest.build/getting-started/installation/).
- ${ctx.skills.length} skills describing the workflows:

${skills}

## Learn more

Run \`fest understand\` for the methodology. The multi-harness packaging layout and the
source-of-truth convention are documented in \`packaging/README.md\`.
`;
}

export default {
  harness: "agents",
  manifests: [],
  emit(ctx) {
    ctx.writeText("AGENTS.md", agentsMd(ctx));
  },
};
