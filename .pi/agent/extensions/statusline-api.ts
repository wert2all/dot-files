/**
 * Shared API for the statusline extension.
 *
 * Other extensions can import these helpers to register text
 * in the left or right side of the footer statusline.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export type StatusItem = {
  id: string;
  text: string;
  priority?: number;
};

export const STATUSLINE_CHANNELS = {
  left: "statusline:left",
  right: "statusline:right",
  remove: "statusline:remove",
} as const;

export function statuslineLeft(pi: ExtensionAPI, item: StatusItem): void {
  pi.events.emit(STATUSLINE_CHANNELS.left, item);
}

export function statuslineRight(pi: ExtensionAPI, item: StatusItem): void {
  pi.events.emit(STATUSLINE_CHANNELS.right, item);
}

export function statuslineRemove(pi: ExtensionAPI, id: string): void {
  pi.events.emit(STATUSLINE_CHANNELS.remove, id);
}
