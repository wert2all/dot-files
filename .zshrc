export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Android home
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools/bin
export _JAVA_AWT_WM_NONREPARENTING=1

#go
export PATH=$HOME/go/bin/:$PATH

# fix tmux patch for wsl2
export TMUX_TMPDIR=/tmp

# zsh plugin manager

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch "${zsh_plugins}".txt

# Lazy-load antidote from its functions directory.
fpath=("$HOME"/.antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <"${zsh_plugins}".txt >|"${zsh_plugins}".zsh
fi

# Source your static plugins file.
source "${zsh_plugins}".zsh

eval "$(zoxide init zsh)"

# for sign git commits
export GPG_TTY=$(tty)

#fix kitty on ssh
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# Prompt
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/gruvbox.omp.json)"

# History (from https://github.com/mischavandenburg/dotfiles/blob/main/.zshrc)

setopt HIST_IGNORE_SPACE # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS  # Don't save duplicate lines
setopt SHARE_HISTORY     # Share history between sessions

#fzf support
export FZF_DEFAULT_OPTS="--color=fg:#C0C0C0,bg:#333333"
source <(fzf --zsh)

## -- Aliases -- ##

# NeoVim config
alias vim=nvim
alias nvchad="NVIM_APPNAME=nvchad nvim"
export EDITOR=nvim

# Git aliases

# wtp - git worktree utility
eval "$(wtp shell-init zsh)"

gitWorktree() {
  if [ -z "$1" ]; then
    wtp list
    return 0
  fi

  local branch="$1"
  # Check if worktree doesn't exist
  if ! git worktree list | grep -i "\[$branch\]"; then
    wtp add -b "$branch" origin/main
  fi

  wtp cd "$branch"
}

# Clean git worktrees (remove all except main and current)
gwtremoveall() {
  local main_worktree current_worktree

  main_worktree=$(git worktree list | grep "\[main\]" | awk '{print $1}' | head -1)
  current_worktree=$(git rev-parse --show-toplevel)

  if [[ -z "$main_worktree" ]]; then
    echo "No main worktree found"
    return 1
  fi

  echo "Main worktree: $main_worktree"
  echo "Current worktree: $current_worktree"
  git worktree list | grep -vE "${main_worktree}|${current_worktree}" | awk '{print $1}' | while read -r worktree; do
    echo "Removing worktree: $worktree"
    git worktree remove -f "$worktree"
  done
}

gitCheckoutAndReset() {
  if [ -n "$1" ]; then
    git checkout "$1"
    git reset --hard origin/"$1"
  fi
}

alias gfa='git fetch --all --tags --prune --jobs=10'
alias gss='git status --short'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gl='git log --graph --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'

alias gcb='git checkout -b'
alias gcr="gitCheckoutAndReset"
alias gwt="gitWorktree"
alias gwtrall="gwtremoveall"

alias gr="git reset --hard"
alias grm="git reset --hard origin/main"

alias gra="git rebase --abort"
alias grc="git rebase --continue"

alias gaa="git add --all"
alias gau="git add -u && gss"

alias gum="git pull origin main --rebase"

alias gph="git push origin HEAD"

alias gcn='git commit --verbose --no-edit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --amend'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

alias gcl='git clone --recurse-submodules'

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

alias p='pnpm'

alias pa='pnpm add'
alias pad='pnpm add --save-dev'
alias pin='pnpm install'
alias pu='pnpm update'
alias pui='pnpm update --interactive'
alias puil='pnpm update --interactive --latest'

alias prun='pnpm run'
alias pst='pnpm start'
alias pln='pnpm run lint'
alias pfmt='pnpm run format'

# pnpm end

# tmux aliases
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tksv='tmux kill-server'
# end tmux

# php
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
# end php

# ai powered

# opencode alias - ensure iap is sourced before running opencode
oc() {
  if [[ -z "$API_KEYS_LOADED" ]]; then
    echo "Loading API keys first..."
    source ~/bin/init_api_keys.sh
  fi
  opencode "$@"
}

# Question mark alias for opencode with special symbol support
question() {
  if [ $# -eq 0 ]; then
    echo "Usage: ? <your question>"
    return 1
  fi
  oc run --agent chat "$*"
}

alias '?'='noglob question'                                 # AI chat with question
alias gencom='oc run "$(cat ~/.zsh/ai/generate_commit.md)"' # Generate commit message

# end ai

#other aliases
alias cat="bat --theme-dark default --theme-light GitHub"
alias dus="sudo du -hs \$(ls -A) | sort -h"
alias ll="eza -lh --icons=auto --sort=name --group-directories-first"

alias iap="source ~/bin/init_api_keys.sh"
alias code="~/code/code"
