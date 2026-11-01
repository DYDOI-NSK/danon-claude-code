#!/usr/bin/env node
/**
 * Statusline Setup Hook (SessionStart)
 *
 * Plugins can't ship a statusLine, so on session start this writes
 * ccstatusline into the user-level settings.json, but only when no
 * statusLine is configured yet. An existing statusLine (ours or foreign)
 * is never touched. Fails open: any error is logged and ignored.
 *
 * Hook ID : session:statusline-setup
 */

"use strict";

const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const { log } = require("../lib/utils");

const STATUS_LINE = {
  type: "command",
  command: "npx -y ccstatusline@latest",
  padding: 0,
  refreshInterval: 10,
};

function hasNpx() {
  const probe = process.platform === "win32" ? "where" : "which";
  return spawnSync(probe, ["npx"], { stdio: "ignore" }).status === 0;
}

function settingsPath() {
  const dir =
    process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), ".claude");
  return path.join(dir, "settings.json");
}

function setup() {
  const file = settingsPath();
  let settings = {};

  if (fs.existsSync(file)) {
    const raw = fs.readFileSync(file, "utf8");
    if (raw.trim()) {
      try {
        settings = JSON.parse(raw);
      } catch (err) {
        log(
          `[StatuslineSetup] ${file} is not valid JSON, skipping: ${err.message}`,
        );
        return;
      }
    }
    if (!settings || typeof settings !== "object" || Array.isArray(settings)) {
      log(`[StatuslineSetup] ${file} is not a JSON object, skipping`);
      return;
    }
  }

  if (settings.statusLine) return;

  if (!hasNpx()) {
    log("[StatuslineSetup] npx not found in PATH, skipping ccstatusline setup");
    return;
  }

  settings.statusLine = STATUS_LINE;
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const tmp = `${file}.${process.pid}.tmp`;
  fs.writeFileSync(tmp, `${JSON.stringify(settings, null, 2)}\n`);
  fs.renameSync(tmp, file);
  log(
    `[StatuslineSetup] ccstatusline enabled in ${file}; takes effect on next session`,
  );
}

function run(raw) {
  try {
    setup();
  } catch (err) {
    log(`[StatuslineSetup] Error: ${err.message}`);
  }
  return raw;
}

module.exports = { run };

if (require.main === module) {
  let data = "";
  process.stdin.setEncoding("utf8");
  process.stdin.on("data", (chunk) => {
    if (data.length < 1024 * 1024) data += chunk;
  });
  process.stdin.on("end", () => {
    run(data);
  });
}
