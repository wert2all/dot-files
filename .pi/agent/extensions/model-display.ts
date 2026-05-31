/**
 * Model Display Extension
 *
 * Replaces the default footer with model info including:
 * - type badge (free/pay) with background color
 * - speed badge (fast/standard) with background color
 * - provider name
 * - model id
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
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

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

function generateStatuses(statuses: ReadonlyMap<string, string>): string {
  const statusArr =
    statuses instanceof Map
      ? Array.from(statuses.values())
      : Array.isArray(statuses)
        ? statuses
        : [];
  return statusArr.filter(Boolean).join(" ");
}

function getContextUsage(usage: ContextUsage | undefined) {
  const pct = usage && usage.percent !== null ? usage.percent : 0;
  const filled = Math.round(pct / 10);
  const bar = "#".repeat(filled) + "-".repeat(10 - filled);
  return `[${bar}] ${Math.round(pct)}% `;
}

export default function (pi: ExtensionAPI) {
  let modelMeta: ModelMetaConfig = { config: { enabled: false }, models: {} };
  let currentModel: { provider: string; id: string } | null = null;

  function getModelDisplay(models: Models, config: ExtensionConfig): string {
    if (!currentModel) return "";

    const modelName = currentModel.id.split("/")[1] || currentModel.id;
    const meta = models[`${currentModel.provider}/${currentModel.id}`];
    const badges = buildBadges(meta, config.badges);

    return `${badges} ${currentModel.provider}: ${modelName}`;
  }

  function setFooter(ctx: ExtensionContext, config: ModelMetaConfig) {
    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsub,
        invalidate() { },
        render(width: number): string[] {
          const modelInfo = theme.fg(
            "dim",
            getModelDisplay(config.models, config.config),
          );
          const statuses = theme.fg(
            "dim",
            generateStatuses(footerData.getExtensionStatuses()),
          );
          const usageBar = theme.fg(
            "dim",
            getContextUsage(ctx.getContextUsage()),
          );

          const gap1 = width - visibleWidth(modelInfo) - visibleWidth(statuses);
          const line1 = modelInfo + " ".repeat(Math.max(0, gap1)) + statuses;

          const gap2 = width - visibleWidth(usageBar);
          const line2 = " ".repeat(Math.max(0, gap2)) + usageBar;

          return [truncateToWidth(line1, width), truncateToWidth(line2, width)];
        },
      };
    });
  }

  pi.on("session_start", async (_event, ctx) => {
    modelMeta = loadModelMeta(ctx.cwd);

    if (ctx.model) {
      currentModel = { provider: ctx.model.provider, id: ctx.model.id };
    }
    if (modelMeta.config.enabled) {
      setFooter(ctx, modelMeta);
    }
  });

  pi.on("model_select", async (event, ctx) => {
    currentModel = { provider: event.model.provider, id: event.model.id };
    modelMeta = loadModelMeta(ctx.cwd);
  });
}
