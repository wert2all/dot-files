# AI tool aliases
alias '?'='noglob question'
# alias aicom='oc run  --model=nvidia/openai/gpt-oss-120b --command caveman-commit "$(cat ~/.zsh/ai/commit_changes.md)"'
alias pi_merge_pr='pi_quick @~/work/dot-files/docs/prompts/github-create-pr-merge.md " execute an instructions from file and do it"'
alias aicom='pi_quick @~/.zsh/ai/commit_changes.md "$(git diff --cached)"'

if ! command -v fabric >/dev/null 2>&1; then
  alias fabric='fabric-ai'
fi
