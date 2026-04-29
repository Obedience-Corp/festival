const fs = require("fs");
const { spawnSync } = require("child_process");

const { binaryPath, install } = require("../install");

async function runBinary(name) {
  const target = binaryPath(name);

  if (!fs.existsSync(target)) {
    await install();
  }

  const result = spawnSync(target, process.argv.slice(2), {
    stdio: "inherit",
    shell: false,
  });

  if (result.error) {
    throw result.error;
  }

  process.exit(result.status ?? 1);
}

module.exports = {
  runBinary,
};

