# AI tool aliases
alias '?'='noglob question'
alias gencom='oc run "$(cat ~/.zsh/ai/generate_commit.md)"'

if ! command -v fabric >/dev/null 2>&1; then
  alias fabric='fabric-ai'
fi
