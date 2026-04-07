import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  // Prevent switching to any model that is not from the NVIDIA provider.
  pi.on("model_select", async (event, ctx) => {
    if (event.model.provider !== "nvidia") {
      // Inform the user.
      ctx.ui.notify(
        `⚠️ Model ${event.model.provider}/${event.model.id} blocked – only NVIDIA models are allowed.`,
        "warning",
      );
      // Revert to the previous model if we have one.
      if (event.previousModel) {
        await pi.setModel(event.previousModel);
      }
      // Cancel further handling of this model change.
      return { cancel: true };
    }
    // allow NVIDIA models unchanged
  });
}
