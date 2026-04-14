/**
 * Minimal — Model name + context meter in a compact footer
 *
 * Shows model ID and a 10-block context usage bar: [###-------] 30%
 *
 * Usage: pi -e extensions/minimal.ts
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import type { ExtensionContext } from "@mariozechner/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@mariozechner/pi-tui";
import { basename } from "path";

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		applyExtensionDefaults(ctx);
		ctx.ui.setFooter((_tui, theme, _footerData) => ({
			dispose: () => { },
			invalidate() { },
			render(width: number): string[] {
				const model = ctx.model?.id || "no-model";
				const usage = ctx.getContextUsage();
				const pct = usage && usage.percent !== null ? usage.percent : 0;
				const filled = Math.round(pct / 10);
				const bar = "#".repeat(filled) + "-".repeat(10 - filled);

				const left = theme.fg("dim", ` ${model}`);
				const right = theme.fg("dim", `[${bar}] ${Math.round(pct)}% `);
				const pad = " ".repeat(
					Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
				);

				return [truncateToWidth(left + pad + right, width)];
			},
		}));
	});
}

/**
 * Apply both the mapped theme AND the terminal title for an extension.
 * Drop-in replacement for applyExtensionTheme — call this in every session_start.
 *
 * Usage:
 *   import { applyExtensionDefaults } from "./themeMap.ts";
 *
 *   pi.on("session_start", async (_event, ctx) => {
 *     applyExtensionDefaults(import.meta.url, ctx);
 *     // ... rest of handler
 *   });
 */
function applyExtensionDefaults(ctx: ExtensionContext): void {
	applyExtensionTitle(ctx);
}

/**
 * Set the terminal title to "π - <first-extension-name>" on session boot.
 * Reads the title from process.argv so all stacked extensions agree on the
 * same value — no coordination or shared state required.
 *
 * Deferred 150 ms to fire after Pi's own startup title-set.
 */
function applyExtensionTitle(ctx: ExtensionContext): void {
	if (!ctx.hasUI) return;
	const name = primaryExtensionName();
	if (!name) return;
	setTimeout(() => ctx.ui.setTitle(`π - ${name}`), 150);
}

/**
 * Read process.argv to find the first -e / --extension flag value.
 *
 * When Pi is launched as:
 *   pi -e extensions/subagent-widget.ts -e extensions/pure-focus.ts
 *
 * process.argv contains those paths verbatim. Every stacked extension calls
 * this and gets the same answer ("subagent-widget"), so all setTitle calls
 * are idempotent — no shared state or deduplication needed.
 *
 * Returns null if no -e flag is present (e.g. plain `pi` with no extensions).
 */
function primaryExtensionName(): string | null {
	const argv = process.argv;
	for (let i = 0; i < argv.length - 1; i++) {
		if (argv[i] === "-e" || argv[i] === "--extension") {
			return basename(argv[i + 1]).replace(/\.[^.]+$/, "");
		}
	}
	return null;
}
