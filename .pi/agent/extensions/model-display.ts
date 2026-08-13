/**
 * Model Display Extension
 *
 * Pushes model info and context usage into the shared statusline.
 *
 * Configure via modelMeta in settings.json:
 *   ~/.pi/agent/settings.json (global)
 *   .pi/settings.json (project, overrides global)
 *
 * Schema:
 *   "modelMeta": {
 *     "<provider>/<modelId>": {
 *       "type": "free" | "pay",
 *       "speed": "fast" | "standard"
 *     }
 *   }
 */

import type {
  ContextUsage,
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import {
  statuslineLeft,
  statuslineRemove,
  statuslineRight,
} from "./statusline-api";

type ModelMetaEntry = {
  type?: "free" | "pay";
  speed?: "fast" | "standard";
};
type BadgeValue = "free" | "pay" | "fast" | "standard";
type Badge = { label: string };
type ExtensionConfig = {
  enabled: boolean;
  badges?: Record<BadgeValue, string>;
};
type Models = Record<string, ModelMetaEntry>;
type ModelMetaConfig = {
  config: ExtensionConfig;
  models: Models;
};

// ANSI background colors for badges
const BG_GREEN = "\x1b[48;5;28m"; // free
const BG_ORANGE = "\x1b[48;5;166m"; // pay
const BG_BLUE = "\x1b[48;5;26m"; // fast
const BG_GRAY = "\x1b[48;5;240m"; // standard
const BG_RESET = "\x1b[49m";
const FG_WHITE = "\x1b[97m";
const FG_RESET = "\x1b[39m";

const TYPE_BG: Record<string, string> = {
  free: BG_GREEN,
  pay: BG_ORANGE,
};

const SPEED_BG: Record<string, string> = {
  fast: BG_BLUE,
  standard: BG_GRAY,
};

const MODEL_SLOT_ID = "model-display:model";
const USAGE_SLOT_ID = "model-display:usage";

function badge(text: string, bg: string): string {
  return `${bg}${FG_WHITE} ${text} ${BG_RESET}${FG_RESET} `;
}

function getBadgeConfig(
  value: BadgeValue,
  badges?: Record<BadgeValue, string>,
): Badge {
  return { label: badges?.[value] ?? value };
}

function buildBadges(
  meta: ModelMetaEntry | undefined,
  badges?: Record<BadgeValue, string>,
): string {
  let result = "";

  if (meta?.type) {
    const badgeConfig = getBadgeConfig(meta.type, badges);
    result += badge(badgeConfig.label, TYPE_BG[meta.type] ?? BG_GRAY);
  }

  if (meta?.speed) {
    const badgeConfig = getBadgeConfig(meta.speed, badges);
    result += badge(badgeConfig.label, SPEED_BG[meta.speed] ?? BG_GRAY);
  }

  return result;
}

function loadModelMeta(cwd: string): ModelMetaConfig {
  const config: ExtensionConfig = { enabled: true };
  const models: Models = {};

  for (const path of [
    join(homedir(), ".pi", "agent", "settings.json"),
    join(cwd, ".pi", "settings.json"),
  ]) {
    if (!existsSync(path)) continue;

    try {
      const data = JSON.parse(readFileSync(path, "utf-8"));
      if (data?.modelMeta?.config) Object.assign(config, data.modelMeta.config);
      if (data?.modelMeta?.models) Object.assign(models, data.modelMeta.models);
    } catch {
      // ignore malformed JSON or read errors
    }
  }

  return { config, models };
}

function getContextUsageBar(usage: ContextUsage | undefined): string {
  const pct = usage && usage.percent !== null ? usage.percent : 0;
  const filled = Math.round(pct / 10);
  const bar =
    "#".repeat(filled) + "-".repeat(10 - (filled <= 10 ? filled : 10));
  return `[${bar}] ${Math.round(pct)}%`;
}

export default function (pi: ExtensionAPI) {
  let modelMeta: ModelMetaConfig = { config: { enabled: false }, models: {} };
  let ctx: ExtensionContext | undefined;

  function pushModel(model: { provider: string; id: string }) {
    const modelName = model.id.split("/")[1] || model.id;
    const meta = modelMeta.models[`${model.provider}/${model.id}`];
    const badges = buildBadges(meta, modelMeta.config.badges);

    statuslineLeft(pi, {
      id: MODEL_SLOT_ID,
      text: `${badges}${model.provider}: ${modelName}`.trim(),
      priority: 10,
    });
  }

  function pushUsage() {
    statuslineRight(pi, {
      id: USAGE_SLOT_ID,
      text: getContextUsageBar(ctx?.getContextUsage()),
      priority: 5,
    });
  }

  pi.on("session_start", async (_event, c) => {
    ctx = c;
    modelMeta = loadModelMeta(ctx.cwd);

    if (!modelMeta.config.enabled) return;

    if (ctx.model) pushModel(ctx.model);
    pushUsage();
  });

  pi.on("model_select", async (event, c) => {
    ctx = c;
    modelMeta = loadModelMeta(ctx.cwd);

    if (!modelMeta.config.enabled) return;

    pushModel(event.model);
    pushUsage();
  });

  pi.on("turn_end", async () => {
    if (!modelMeta.config.enabled || !ctx) return;
    pushUsage();
  });

  pi.on("session_shutdown", async () => {
    statuslineRemove(pi, MODEL_SLOT_ID);
    statuslineRemove(pi, USAGE_SLOT_ID);
    ctx = undefined;
  });
}
