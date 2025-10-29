#!/usr/bin/env sh

export MISTRAL_API_KEY=$(pass show api/ai/mistral)
export GEMINI_API_KEY=$(pass show api/ai/gemini)
export OPENROUTER_API_KEY=$(pass show api/ai/openrouter)
export ANTHROPIC_API_KEY=$(pass show api/ai/claude)
export OPENCODE_API_KEY=$(pass show api/ai/opencode_zen)
export CROWDIN_API_TOKEN=$(pass show api/crowdin)
