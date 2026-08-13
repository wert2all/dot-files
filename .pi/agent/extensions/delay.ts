import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

let currentDelayMs = 0; // 0 — вимкнено за замовчуванням

export default function (pi: ExtensionAPI) {
  pi.on("turn_start", async (_event, ctx) => {
    // Якщо затримка 0 або менше — нічого не робимо
    if (currentDelayMs <= 0) return;

    const seconds = (currentDelayMs / 1000).toFixed(1);
    ctx.ui.notify(`⏸ Затримка ${seconds}с перед запитом до моделі...`, "info");

    await new Promise((resolve) => setTimeout(resolve, currentDelayMs));
  });

  pi.registerCommand("delay", {
    description:
      "Налаштувати затримку перед запитами в секундах (0 — вимкнути)",
    handler: async (args, ctx) => {
      const inputSec = parseFloat(args);
      if (isNaN(inputSec) || inputSec < 0) {
        ctx.ui.notify(
          "Вкажіть число в секундах, наприклад: /delay 61 або /delay 0",
          "warning",
        );
        return;
      }

      currentDelayMs = inputSec * 1000;

      if (currentDelayMs === 0) {
        ctx.ui.notify("Затримку ВИМКНЕНО.", "info");
      } else {
        ctx.ui.notify(`Затримку оновлено до ${inputSec} сек.`, "info");
      }
    },
  });
}
