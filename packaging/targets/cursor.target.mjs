const CURSOR_PLUGIN_ROOT = "cursor-plugin";
const LOGO = "assets/logo.svg";
const INSTALL_HOOK = "hooks/scripts/cursor-install-hook.sh";

function readme(ctx) {
  const skills = ctx.skills.map((s) => `  - \`${s.name}\`: ${s.description}`).join("\n");
  const commands = ctx.commands.map((c) => `  - \`${c.name}\`: ${c.description}`).join("\n");
  const agents = ctx.agents.map((a) => `  - \`${a.name}\`: ${a.description}`).join("\n");
  return `<!-- ${ctx.banner} -->

# Festival for Cursor

Festival is a goal-oriented project management methodology for human and AI development work.
This plugin teaches the Cursor agent to plan and run that work with the \`fest\` and \`camp\`
command-line tools, and it installs both tools for you.

## What it ships

- **Skills** (\`skills/\`), ${ctx.skills.length}:
${skills}
- **Commands** (\`commands/\`), ${ctx.commands.length}:
${commands}
- **Agents** (\`agents/\`), ${ctx.agents.length}:
${agents}
- **Hook** (\`hooks/hooks.json\`): one \`sessionStart\` hook that installs \`fest\` and
  \`camp\`, described below.

The plugin has no rules, no MCP servers, and no variables.

## Install

### From the Cursor Marketplace

Open **Customize** in the sidebar, find Festival, select **Install**, and choose a project or user
scope.

### As a local plugin

Cursor loads plugins from \`~/.cursor/plugins/local/<name>\`. Copy this directory there:

\`\`\`bash
git clone https://github.com/Obedience-Corp/festival.git
mkdir -p ~/.cursor/plugins/local
cp -R festival/${CURSOR_PLUGIN_ROOT} ~/.cursor/plugins/local/festival
\`\`\`

Then restart Cursor or run **Developer: Reload Window**, and open **Customize** to confirm the
skills, commands, and agents are listed. Copy the directory rather than symlinking it: Cursor skips a
symlink in that folder whose target is outside it. On Teams and Enterprise plans, local plugins load
only when an admin allows local plugin imports.

For a single Cursor CLI session, point the CLI at the directory instead:

\`\`\`bash
agent --plugin-dir /path/to/festival/${CURSOR_PLUGIN_ROOT}
\`\`\`

### For a team

On Teams and Enterprise plans, an admin can go to **Dashboard -> Plugins & MCPs**, click **Add
Marketplace** under **Team Marketplaces**, choose **Import from Repo**, and paste
\`https://github.com/Obedience-Corp/festival\`. The repository root carries
\`.cursor-plugin/marketplace.json\`, which lists this plugin with \`source: "./${CURSOR_PLUGIN_ROOT}"\`.

## How fest and camp get installed

The plugin installs them from a \`sessionStart\` hook, which runs when a new agent session starts.
Its command is \`bash "\${CURSOR_PLUGIN_ROOT}/${INSTALL_HOOK}"\`, with a 120 second timeout.

\`${INSTALL_HOOK}\` does three things:

1. Reads and discards the hook payload on stdin.
2. Runs \`hooks/scripts/ensure-festival.sh\` with all of its output sent to stderr. When \`fest\`
   or \`camp\` is missing, that script downloads the latest Festival release, verifies its checksum,
   and installs both tools. When they are present, it checks for a newer release at most once a day
   and prints a notice if there is one.
3. Prints \`{}\` on stdout and exits 0.

The hook never sees or gates your commands. It is deliberately not a permission hook such as
\`beforeShellExecution\`: those must answer allow, deny, or ask for every command, and an installer
has no business making that decision. Cursor does not wait for \`sessionStart\`, so on a machine
without the tools the agent's first \`fest\` command in the very first session can run before the
download finishes; it works once the install completes, and every later session starts with the tools
already present.

The tools install to \`~/.local/bin\`, which must be on the \`PATH\` of the shell Cursor runs commands
in. If the automatic install cannot run (no network, or no \`curl\`), install by hand:

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
\`\`\`

## Configuration

None is required. The plugin declares no variables, and nothing needs setting in **Plugins ->
Configure**.

The installer reads two optional environment variables from the environment Cursor runs hooks in:
\`INSTALL_DIR\` (where \`fest\` and \`camp\` go, default \`~/.local/bin\`) and \`FESTIVAL_CACHE_DIR\`
(where the once-a-day update check stamp lives, default \`~/.cache/festival\`).

## Usage

Open Cursor at the root of a camp, the directory Festival works in (\`camp init\` creates one). Ask
the agent to plan work, or start from a command such as \`/fest-next\`. The working loop is:

\`\`\`text
fest next
<do the task fest next prints>
fest task completed
fest commit -m "<message>"
\`\`\`

Full documentation: https://docs.fest.build/getting-started/agents/cursor/
`;
}

function cursorHooks() {
  return {
    version: 1,
    hooks: {
      sessionStart: [
        { command: `bash "\${CURSOR_PLUGIN_ROOT}/${INSTALL_HOOK}"`, timeout: 120 },
      ],
    },
  };
}

function withAgentName(text, name) {
  if (!text.startsWith("---\n")) return text;
  const end = text.indexOf("\n---", 4);
  if (end === -1 || /^name:/m.test(text.slice(4, end))) return text;
  return `---\nname: ${name}\n${text.slice(4)}`;
}

function author(m) {
  return m.author.email ? { name: m.author.name, email: m.author.email } : { name: m.author.name };
}

function withBanner(ctx, script) {
  const nl = script.indexOf("\n");
  return script.slice(0, nl + 1) + `# ${ctx.banner}\n` + script.slice(nl + 1);
}

function cursorMarketplace(ctx) {
  const m = ctx.manifest;
  return {
    name: m.name,
    owner: author(m),
    plugins: [
      {
        name: m.name,
        source: `./${CURSOR_PLUGIN_ROOT}`,
        description: m.description,
        version: m.version,
      },
    ],
  };
}

export default {
  harness: "cursor",
  manifests: [`${CURSOR_PLUGIN_ROOT}/.cursor-plugin/plugin.json`],
  emit(ctx) {
    const m = ctx.manifest;
    const hasLogo = ctx.hasPluginFile(LOGO);
    ctx.writeJSON(`${CURSOR_PLUGIN_ROOT}/.cursor-plugin/plugin.json`, {
      name: m.name,
      version: m.version,
      description: m.description,
      author: author(m),
      homepage: m.homepage,
      repository: m.repository,
      license: m.license,
      keywords: m.keywords,
      ...(hasLogo ? { logo: LOGO } : {}),
      ...ctx.readTemplateJSON("cursor"),
    });
    if (hasLogo) ctx.copyPluginFile(LOGO, `${CURSOR_PLUGIN_ROOT}/${LOGO}`);
    for (const skill of ctx.skills) {
      ctx.writeText(`${CURSOR_PLUGIN_ROOT}/skills/${skill.name}/SKILL.md`, ctx.readPluginFile(skill.path));
    }
    for (const command of ctx.commands) {
      ctx.writeText(`${CURSOR_PLUGIN_ROOT}/commands/${command.name}.md`, ctx.readPluginFile(command.path));
    }
    for (const agent of ctx.agents) {
      ctx.writeText(`${CURSOR_PLUGIN_ROOT}/agents/${agent.name}.md`, withAgentName(ctx.readPluginFile(agent.path), agent.name));
    }
    ctx.writeJSON(`${CURSOR_PLUGIN_ROOT}/hooks/hooks.json`, cursorHooks());
    ctx.writeText(`${CURSOR_PLUGIN_ROOT}/hooks/scripts/ensure-festival.sh`, ctx.bundledScript("hooks/scripts/ensure-festival.sh"));
    ctx.writeText(`${CURSOR_PLUGIN_ROOT}/${INSTALL_HOOK}`, withBanner(ctx, ctx.readTemplate("cursor", "sh")));
    ctx.writeText(`${CURSOR_PLUGIN_ROOT}/README.md`, readme(ctx));
    ctx.writeJSON(".cursor-plugin/marketplace.json", cursorMarketplace(ctx));
  },
};
