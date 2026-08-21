#!/usr/bin/env node

const crypto = require("crypto");
const fs = require("fs");
const https = require("https");
const path = require("path");
const { spawnSync } = require("child_process");

const REPO = "Obedience-Corp/festival";
const BINARIES = ["fest", "camp", "festival"];
const ASSET_DIRECTORIES = ["completions", "shell"];
const SHELL_HELPER_FILES = [
  ["shell", "festival.bash"],
  ["shell", "festival.zsh"],
  ["shell", "festival.fish"],
];

function completionAssetFiles(binaries = BINARIES) {
  return binaries.flatMap((name) => [
    ["completions", `${name}.bash`],
    ["completions", `_${name}`],
    ["completions", `${name}.fish`],
  ]);
}

const REQUIRED_ASSET_FILES = [...completionAssetFiles(BINARIES), ...SHELL_HELPER_FILES];
const DOWNLOAD_ATTEMPTS = 3;
const DOWNLOAD_TIMEOUT_MS = 60_000;
const RETRY_BASE_DELAY_MS = 750;

const PLATFORM_MAP = {
  darwin: "macOS",
  linux: "linux",
};

const ARCH_MAP = {
  x64: "x86_64",
  arm64: "arm64",
};

function packageVersion() {
  const packageJSON = require("./package.json");
  return packageJSON.version;
}

function releaseTag(version = packageVersion()) {
  return `v${version}`;
}

function targetForCurrentPlatform() {
  const platform = PLATFORM_MAP[process.platform];
  const arch = ARCH_MAP[process.arch];

  if (!platform || !arch) {
    throw new Error(
      `Unsupported platform: ${process.platform}/${process.arch}. Festival npm install currently supports macOS and Linux on x64/arm64.`,
    );
  }

  if (platform === "macOS") {
    return "macOS-all";
  }

  return `${platform}-${arch}`;
}

function archiveName(version = packageVersion()) {
  return `festival-${version}-${targetForCurrentPlatform()}.tar.gz`;
}

function releaseURL(asset, version = packageVersion()) {
  return `https://github.com/${REPO}/releases/download/${releaseTag(version)}/${asset}`;
}

function binaryPath(name) {
  const binaryName = process.platform === "win32" ? `${name}.exe` : `${name}-bin`;
  return path.join(__dirname, "bin", binaryName);
}

function assetPath(...parts) {
  return path.join(__dirname, "share", "festival", ...parts);
}

function haveInstallArtifacts() {
  return (
    BINARIES.every((name) => fs.existsSync(binaryPath(name))) &&
    REQUIRED_ASSET_FILES.every(([dir, file]) => fs.existsSync(assetPath(dir, file)))
  );
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function downloadOnce(url, dest) {
  return new Promise((resolve, reject) => {
    let settled = false;

    const fail = (err) => {
      if (settled) {
        return;
      }
      settled = true;
      fs.rmSync(dest, { force: true });
      reject(err);
    };

    const done = () => {
      if (settled) {
        return;
      }
      settled = true;
      resolve();
    };

    const follow = (nextURL, redirects = 0) => {
      if (redirects > 10) {
        fail(new Error("too many redirects"));
        return;
      }

      const request = https
        .get(nextURL, (response) => {
          if (
            response.statusCode >= 300 &&
            response.statusCode < 400 &&
            response.headers.location
          ) {
            response.resume();
            follow(response.headers.location, redirects + 1);
            return;
          }

          if (response.statusCode !== 200) {
            response.resume();
            fail(new Error(`failed to download ${url}: HTTP ${response.statusCode}`));
            return;
          }

          const file = fs.createWriteStream(dest);
          response.pipe(file);
          file.on("finish", () => {
            file.close(done);
          });
          file.on("error", fail);
        })
        .on("error", fail);

      request.setTimeout(DOWNLOAD_TIMEOUT_MS, () => {
        request.destroy(new Error(`download timeout after ${DOWNLOAD_TIMEOUT_MS / 1000}s`));
      });
    };

    follow(url);
  });
}

async function download(url, dest, attempts = DOWNLOAD_ATTEMPTS) {
  let lastErr;

  for (let attempt = 1; attempt <= attempts; attempt += 1) {
    try {
      await downloadOnce(url, dest);
      return;
    } catch (err) {
      lastErr = err;

      if (attempt === attempts) {
        break;
      }

      const delay = RETRY_BASE_DELAY_MS * 2 ** (attempt - 1);
      console.warn(
        `Download failed (${attempt}/${attempts}) for ${path.basename(dest)}: ${err.message}. Retrying in ${delay}ms...`,
      );
      await sleep(delay);
    }
  }

  throw lastErr;
}

function sha256(filePath) {
  const hash = crypto.createHash("sha256");
  hash.update(fs.readFileSync(filePath));
  return hash.digest("hex");
}

function expectedChecksum(checksumsPath, filename) {
  const checksums = fs.readFileSync(checksumsPath, "utf8").split(/\r?\n/);

  for (const line of checksums) {
    const parts = line.trim().split(/\s+/);
    if (parts.length >= 2 && parts[1] === filename) {
      return parts[0];
    }
  }

  throw new Error(`checksum for ${filename} not found in checksums.txt`);
}

function verifyChecksum(archivePath, checksumsPath, filename) {
  const expected = expectedChecksum(checksumsPath, filename);
  const actual = sha256(archivePath);

  if (actual !== expected) {
    throw new Error(`checksum mismatch for ${filename}: expected ${expected}, got ${actual}`);
  }
}

function extractArchive(archivePath, destDir) {
  const result = spawnSync("tar", ["-xzf", archivePath, "-C", destDir], {
    stdio: "inherit",
  });

  if (result.error) {
    throw result.error;
  }
  if (result.status !== 0) {
    throw new Error(`tar exited with status ${result.status}`);
  }
}

async function install(options = {}) {
  const force = options.force === true;

  if (!force && haveInstallArtifacts()) {
    return;
  }

  const version = packageVersion();
  const filename = archiveName(version);
  const binDir = path.join(__dirname, "bin");
  const tempDir = path.join(__dirname, ".tmp-extract");
  const archivePath = path.join(__dirname, filename);
  const checksumsPath = path.join(__dirname, "checksums.txt");

  console.log(`Installing Festival ${version} (${targetForCurrentPlatform()})...`);

  fs.mkdirSync(binDir, { recursive: true });
  fs.rmSync(tempDir, { recursive: true, force: true });
  fs.mkdirSync(tempDir, { recursive: true });

  try {
    await download(releaseURL(filename, version), archivePath);
    await download(releaseURL("checksums.txt", version), checksumsPath);
    verifyChecksum(archivePath, checksumsPath, filename);
    extractArchive(archivePath, tempDir);

    for (const name of BINARIES) {
      const extractedPath = path.join(tempDir, name);
      const targetPath = binaryPath(name);

      if (!fs.existsSync(extractedPath)) {
        throw new Error(`${name} not found in ${filename}`);
      }

      fs.renameSync(extractedPath, targetPath);
      if (process.platform !== "win32") {
        fs.chmodSync(targetPath, 0o755);
      }
    }

    for (const dir of ASSET_DIRECTORIES) {
      const extractedPath = path.join(tempDir, dir);
      const targetPath = assetPath(dir);

      if (!fs.existsSync(extractedPath)) {
        throw new Error(`${dir} assets not found in ${filename}`);
      }

      fs.rmSync(targetPath, { recursive: true, force: true });
      fs.mkdirSync(path.dirname(targetPath), { recursive: true });
      fs.cpSync(extractedPath, targetPath, { recursive: true });
    }

    console.log("Installed Festival successfully");
  } finally {
    fs.rmSync(tempDir, { recursive: true, force: true });
    fs.rmSync(archivePath, { force: true });
    fs.rmSync(checksumsPath, { force: true });
  }
}

async function main() {
  try {
    await install({ force: false });
  } catch (err) {
    console.error(`Failed to install Festival: ${err.message}`);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  BINARIES,
  REQUIRED_ASSET_FILES,
  archiveName,
  binaryPath,
  completionAssetFiles,
  install,
  targetForCurrentPlatform,
};
