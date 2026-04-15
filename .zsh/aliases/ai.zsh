# AI tool aliases
alias '?'='noglob question'
alias pi_merge_pr='pi_quick @~/work/dot-files/docs/prompts/github-create-pr-merge.md " execute an instructions from file and do it"'

if ! command -v fabric >/dev/null 2>&1; then
    alias fabric='fabric-ai'
fi
