# AI tool aliases
alias '?'='noglob question'
alias aicom='oc run "$(cat ~/.zsh/ai/commit_changes.md)" --model=nvidia/openai/gpt-oss-120b'

if ! command -v fabric >/dev/null 2>&1; then
  alias fabric='fabric-ai'
fi
