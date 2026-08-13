/**
 * Statusline Extension
 *
 * Replaces the footer with a single status line composed from left and right
 * slots. Other extensions can add slots via the helpers in statusline-api.ts
 * or by emitting the events directly.
 */

import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { STATUSLINE_CHANNELS, type StatusItem } from "./libs/statusline-api";

export default function statuslineExtension(pi: ExtensionAPI) {
  const left = new Map<string, StatusItem>();
  const right = new Map<string, StatusItem>();
  let ctx: ExtensionContext | undefined;
  let requestRender: (() => void) | undefined;

  const sorted = (items: Map<string, StatusItem>) =>
    [...items.values()].sort((a, b) => (b.priority ?? 0) - (a.priority ?? 0));

  function installFooter() {
    if (!ctx || requestRender) return;

    ctx.ui.setFooter((tui, _theme, _footerData) => {
      requestRender = () => tui.requestRender();

      return {
        dispose: () => {
          requestRender = undefined;
        },
        invalidate() { },
        render(width: number): string[] {
          const leftStr = sorted(left)
            .map((i) => i.text)
            .join(" ");
          const rightStr = sorted(right)
            .map((i) => i.text)
            .join(" ");
          const gap = width - visibleWidth(leftStr) - visibleWidth(rightStr);

          const line = leftStr + " ".repeat(Math.max(1, gap)) + rightStr;
          return [truncateToWidth(line, width)];
        },
      };
    });
  }

  pi.on("session_start", async (_event, c) => {
    ctx = c;
    if (!ctx.hasUI) return;

    // If slots were already registered before session_start, install the footer
    // now (this can happen when another extension loads earlier and emits
    // immediately in its own session_start handler).
    if (left.size > 0 || right.size > 0) {
      installFooter();
      requestRender?.();
    }
  });

  pi.events.on(STATUSLINE_CHANNELS.left, (data: unknown) => {
    const item = data as StatusItem;
    left.set(item.id, item);
    installFooter();
    requestRender?.();
  });

  pi.events.on(STATUSLINE_CHANNELS.right, (data: unknown) => {
    const item = data as StatusItem;
    right.set(item.id, item);
    installFooter();
    requestRender?.();
  });

  pi.events.on(STATUSLINE_CHANNELS.remove, (id: unknown) => {
    left.delete(id as string);
    right.delete(id as string);
    requestRender?.();
  });
}
