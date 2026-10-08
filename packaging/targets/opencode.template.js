import { spawnSync } from "node:child_process";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";

const installer = fileURLToPath(new URL("../scripts/ensure-festival.sh", import.meta.url));
const commitGuard = fileURLToPath(new URL("../scripts/commit-guard.sh", import.meta.url));

// Runs the shared commit guard on a bash tool call. The guard reads the command
// as tool_input.command and the directory it runs in as cwd, exits 2 with the
// reason on stderr to block, and exits 0 for everything else. Any other outcome,
// including a spawn failure, lets the call through: only exit 2 blocks. Not
// exported: opencode calls every export of a plugin file as a plugin.
function commitGuardReason(command, cwd) {
  if (typeof command !== "string" || command === "") return null;
  let result;
  try {
    result = spawnSync("bash", [commitGuard], {
      input: JSON.stringify({ tool_input: { command }, cwd }),
      encoding: "utf8",
      timeout: 30000,
    });
  } catch {
    return null;
  }
  if (result.status !== 2) return null;
  const reason = (result.stderr || "").trim();
  return reason === "" ? null : reason;
}

export default async ({ $, directory }) => {
  await $`bash ${installer}`.catch(() => {});
  return {
    "tool.execute.before": async (input, output) => {
      if (input?.tool !== "bash") return;
      const args = output?.args ?? {};
      const base = typeof directory === "string" && directory !== "" ? directory : process.cwd();
      const cwd = typeof args.workdir === "string" && args.workdir !== "" ? resolve(base, args.workdir) : base;
      const reason = commitGuardReason(args.command, cwd);
      if (reason) throw new Error(reason);
    },
  };
};
