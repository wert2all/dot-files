# Antidote plugin manager
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
[[ -f ${zsh_plugins}.txt ]] || touch "${zsh_plugins}".txt

fpath=("$HOME"/.antidote/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <"${zsh_plugins}".txt >|"${zsh_plugins}".zsh
fi

source "${zsh_plugins}".zsh

# Tool initializations
eval "$(zoxide init zsh)"
eval "$(wtp shell-init zsh)"
source <(fzf --zsh)
