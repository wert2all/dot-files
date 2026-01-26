#!/usr/bin/env sh

# export GEMINI_API_KEY=$(pass show api/ai/gemini)
# export ANTHROPIC_API_KEY=$(pass show api/ai/claude)
# export CROWDIN_API_TOKEN=$(pass show api/crowdin)

export MISTRAL_API_KEY=$(pass show api/ai/mistral)
export OPENROUTER_API_KEY=$(pass show api/ai/openrouter)
export OPENCODE_API_KEY=$(pass show api/ai/opencode_zen)
export AIHUBMIX_API_KEY=$(pass show api/ai/ai_hub_mix)

export API_KEYS_LOADED=1
