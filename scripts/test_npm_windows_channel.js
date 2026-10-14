#!/usr/bin/env node

// D004: publishing a Windows suite ZIP must not make the Unix npm installer
// claim Windows support or try to fetch the wrong archive.
const assert = require("node:assert/strict");

const pkg = require("../npm/package.json");
assert(!pkg.os.includes("win32"), "npm must exclude Windows until its installer is ported");

Object.defineProperty(process, "platform", { value: "win32", configurable: true });
const installer = require("../npm/install.js");
assert.throws(
  () => installer.targetForCurrentPlatform(),
  /On Windows, use Scoop or the checksummed suite ZIP/,
  "npm must reject Windows before calculating a Unix archive URL or downloading it",
);

console.log("ok: npm rejects Windows before archive selection");
