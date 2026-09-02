import { readdirSync, statSync } from "node:fs";
import { join } from "node:path";

const TAP_ROOT = "skills";
const SKILLS_SH_SCHEMA = "https://skills.sh/schemas/skills.sh.schema.json";

const CATEGORY_TITLES = {
  camp: "Camp workspace (camp)",
  festival: "Festival planning and execution (fest)",
};

const CATEGORY_DESCRIPTIONS = {
  camp: "Navigate, commit, and organize a camp with the camp CLI.",
  festival: "Plan and execute festivals (phases, sequences, tasks) with the fest CLI.",
};

const CATEGORY_ORDER = ["camp", "festival"];

// metadata.hermes.{tags,category} per skill. Categories follow the same split the
// skills.sh groupings use: camp-*, campaign-* and cross-campaign are workspace
// skills; fest-* and festival-intake are methodology skills.
const SKILL_METADATA = {
  "camp-navigation": { category: "camp", tags: ["camp", "navigation", "workspace", "cli"] },
  "camp-projects": { category: "camp", tags: ["camp", "projects", "submodules", "worktrees", "git"] },
  "camp-workitems": { category: "camp", tags: ["camp", "workitems", "triage", "planning"] },
  "campaign-commit": { category: "camp", tags: ["camp", "commit", "git", "traceability"] },
  "campaign-structure": { category: "camp", tags: ["camp", "structure", "workspace", "orientation"] },
  "campaign-workflows": { category: "camp", tags: ["camp", "intents", "workflow", "lifecycle"] },
  "cross-campaign": { category: "camp", tags: ["camp", "discovery", "cross-campaign", "reference"] },
  "fest-execution": { category: "festival", tags: ["fest", "festival", "execution", "tasks"] },
  "fest-methodology": { category: "festival", tags: ["fest", "festival", "methodology", "reference"] },
  "fest-planning": { category: "festival", tags: ["fest", "festival", "planning", "scaffolding"] },
  "fest-standalone-workflows": { category: "festival", tags: ["fest", "workflow", "checklist", "standalone"] },
  "festival-intake": { category: "festival", tags: ["fest", "festival", "intake", "planning", "routing"] },
};

// Fallback for a skill added to claude-plugin/ before this map is updated: keep the
// generator working and label it by the same prefix rule the map follows.
function skillMetadata(name) {
  const known = SKILL_METADATA[name];
  if (known) return known;
  const category = name.startsWith("fest-") || name.startsWith("festival-") ? "festival" : "camp";
  const tags = [category === "festival" ? "fest" : "camp", ...name.split("-")];
  return { category, tags: [...new Set(tags)] };
}

function yamlScalar(value) {
  const text = String(value);
  const plain =
    /^[A-Za-z0-9][A-Za-z0-9 ._/-]*$/.test(text) &&
    !/^(true|false|null|yes|no|on|off)$/i.test(text) &&
    !/^[0-9.]+$/.test(text);
  return plain ? text : JSON.stringify(text);
}

function splitFrontmatter(source, file) {
  const lines = source.split("\n");
  if (lines[0].trim() !== "---") throw new Error(`${file}: expected YAML frontmatter`);
  const close = lines.findIndex((line, index) => index > 0 && line.trim() === "---");
  if (close === -1) throw new Error(`${file}: unterminated YAML frontmatter`);
  return { front: lines.slice(1, close), body: lines.slice(close + 1).join("\n") };
}

// Top-level keys only: an unindented "key:" opens an entry, everything indented (or a
// list item) belongs to the entry above it. Enough to merge into the flat frontmatter
// the source skills carry, without pulling in a YAML dependency.
function topLevelKeys(front, file) {
  const keys = [];
  let seenKey = false;
  for (const line of front) {
    if (!line.trim() || line.startsWith("#")) continue;
    const match = line.match(/^([A-Za-z0-9_.-]+):(?:\s|$)/);
    if (match) {
      keys.push(match[1]);
      seenKey = true;
      continue;
    }
    if (/^\s/.test(line)) continue;
    throw new Error(`${file}: unsupported frontmatter line: ${line}`);
  }
  if (!seenKey) throw new Error(`${file}: frontmatter has no keys`);
  return keys;
}

function hermesFrontmatter(ctx, skill, source, file) {
  const { front, body } = splitFrontmatter(source, file);
  const present = new Set(topLevelKeys(front, file));
  for (const required of ["name", "description"]) {
    if (!present.has(required)) throw new Error(`${file}: frontmatter is missing ${required}`);
  }
  if (present.has("metadata")) {
    throw new Error(
      `${file}: source already defines metadata; extend packaging/targets/hermes.target.mjs to merge it`,
    );
  }

  const manifest = ctx.manifest;
  const author = typeof manifest.author === "string" ? manifest.author : manifest.author?.name;
  const added = [];
  const add = (key, value) => {
    if (!present.has(key) && value) added.push(`${key}: ${yamlScalar(value)}`);
  };
  add("version", manifest.version);
  add("author", author);
  add("license", manifest.license);

  const { category, tags } = skillMetadata(skill.name);
  added.push("metadata:", "  hermes:", "    tags:");
  for (const tag of tags) added.push(`      - ${yamlScalar(tag)}`);
  added.push(`    category: ${yamlScalar(category)}`);

  return `---\n${[...front, ...added].join("\n")}\n---\n${body}`;
}

function skillExtras(ctx, skillName) {
  const root = join(ctx.pluginDir, "skills", skillName);
  const found = [];
  const walk = (relDir) => {
    const entries = readdirSync(join(root, relDir)).sort();
    for (const entry of entries) {
      const rel = relDir ? `${relDir}/${entry}` : entry;
      if (statSync(join(root, rel)).isDirectory()) walk(rel);
      else if (rel !== "SKILL.md") found.push(rel);
    }
  };
  walk("");
  return found;
}

function groupings(ctx) {
  const byCategory = new Map(CATEGORY_ORDER.map((category) => [category, []]));
  for (const skill of ctx.skills) {
    const { category } = skillMetadata(skill.name);
    if (!byCategory.has(category)) byCategory.set(category, []);
    byCategory.get(category).push(skill.name);
  }
  return [...byCategory.entries()]
    .filter(([, skills]) => skills.length > 0)
    .map(([category, skills]) => ({
      title: CATEGORY_TITLES[category] ?? category,
      description: CATEGORY_DESCRIPTIONS[category] ?? `Festival skills in the ${category} category.`,
      skills,
    }));
}

function readme(ctx) {
  const groups = groupings(ctx)
    .map((group) => {
      const rows = group.skills
        .map((name) => {
          const skill = ctx.skills.find((s) => s.name === name);
          return `- \`${name}\`: ${skill.description}`;
        })
        .join("\n");
      return `### ${group.title}\n\n${rows}`;
    })
    .join("\n\n");

  return `<!-- ${ctx.banner} -->

# Festival skills for Hermes Agent

This directory is a Hermes Agent **skills tap**: a GitHub repo laid out as
\`skills/<name>/SKILL.md\`. Hermes installs from it with no server and no marketplace
account. The same layout is what \`skills.sh\` reads, so one tree serves both channels.

## Install

\`\`\`bash
# Subscribe to the tap once, then install what you want
hermes skills tap add Obedience-Corp/festival
hermes skills install Obedience-Corp/festival/skills/fest-execution

# Or install a single skill without subscribing to the tap
hermes skills install Obedience-Corp/festival/skills/festival-intake
\`\`\`

Skills installed this way land in \`~/.hermes/skills/\` and need no trust step and no
config edit. \`hermes skills trust\` is only for project-local bundles (a repo's own
\`.agents/skills\` or \`.hermes/skills\`), which Hermes will not load until the repo is
trusted, once per repo root.

The same tree also works with the skills.sh installer, which reaches agents that are
not Hermes:

\`\`\`bash
npx skills add Obedience-Corp/festival
\`\`\`

## These skills do not install the CLIs

A tap ships instructions, not binaries. Every skill here drives the \`fest\` and \`camp\`
CLIs, so install those first (see the repo \`README.md\` for all channels):

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
# or: brew install --cask Obedience-Corp/tap/festival
# or: npm install -g @obedience-corp/festival
\`\`\`

Hermes's default \`local\` terminal backend inherits your \`PATH\`, so both CLIs are
reachable as soon as they are installed. The sandboxed backends (docker, singularity,
modal, daytona, vercel_sandbox) use the container's own \`PATH\`, so the binaries have to
be provisioned inside the image there.

## Using them in a camp

- Keep \`AGENTS.md\` as the camp's context file. \`camp init\` writes it and points
  \`CLAUDE.md\` at it, and Hermes reads it.
- Never add a \`.hermes.md\`. Hermes context-file precedence is winner-take-one
  (\`.hermes.md\` > \`AGENTS.override.md\` > \`AGENTS.md\` > \`CLAUDE.md\`), so a
  \`.hermes.md\` replaces \`AGENTS.md\` instead of supplementing it.
- Start Hermes from the camp root. The context chain walks up to the nearest git
  root, and projects and worktrees under \`projects/\` are their own git roots.

## Skills in this tap

${groups}

## Generated

Do not edit these files. They are generated from \`claude-plugin/skills/\` by
\`packaging/targets/hermes.target.mjs\`; run \`just plugin generate\` after changing a
source skill. The Hermes target adds \`version\`, \`author\`, \`license\` and
\`metadata.hermes.{tags,category}\` to each skill's frontmatter and leaves the body
byte-for-byte identical to the source.
`;
}

export default {
  harness: "hermes",
  // No plugin manifest: a Hermes tap is a directory layout, not a manifest, so there is
  // nothing for manifest_consistency_check to version-check (same as the agents target).
  manifests: [],
  emit(ctx) {
    for (const skill of ctx.skills) {
      const source = ctx.readPluginFile(skill.path);
      ctx.writeText(
        `${TAP_ROOT}/${skill.name}/SKILL.md`,
        hermesFrontmatter(ctx, skill, source, skill.path),
      );
      for (const extra of skillExtras(ctx, skill.name)) {
        ctx.writeText(
          `${TAP_ROOT}/${skill.name}/${extra}`,
          ctx.readPluginFile(`skills/${skill.name}/${extra}`),
        );
      }
    }
    // skills.sh.json has additionalProperties:false, so it carries no "_generated"
    // banner key; the generated skills/README.md records the provenance instead.
    ctx.writeJSON("skills.sh.json", {
      $schema: SKILLS_SH_SCHEMA,
      groupings: groupings(ctx),
    });
    ctx.writeText(`${TAP_ROOT}/README.md`, readme(ctx));
  },
};
