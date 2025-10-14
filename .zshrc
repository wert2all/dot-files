# add key to ssh agent
SSH_ENV="$HOME/.ssh/agent.env"

init_ssh_agent() {
  echo "Initialising new SSH agent..."
  ssh-agent -s | sed 's/^echo/#echo/' >"${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" >/dev/null
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" >/dev/null
  # check if the agent is running
  ps -p "${SSH_AGENT_PID}" >/dev/null || {
    init_ssh_agent
  }
else
  init_ssh_agent
fi

# Add keys to the agent if it has no identities
if ! ssh-add -l >/dev/null; then
  ssh-add
fi

# set api keys of Ai services by pass
export MISTRAL_API_KEY=$(pass show api/ai/mistral)
export GEMINI_API_KEY=$(pass show api/ai/gemini)
export OPENROUTER_API_KEY=$(pass show api/ai/openrouter)
export ANTHROPIC_API_KEY=$(pass show api/ai/claude)

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

#maestro
export PATH="$PATH":"$HOME/.maestro/bin"

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

# NeoVim config
alias vim=nvim
alias nvchad="NVIM_APPNAME=nvchad nvim"

alias ll="eza -lh --icons=auto --sort=name --group-directories-first"

export EDITOR=nvim
# Git aliases

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

alias dus="sudo du -hs \$(ls -A) | sort -h"

eval "$(zoxide init zsh)"

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

#AI commit
alias commit='ai-commit -provider=mistral -model=codestral-latest'

#fzf support
export FZF_DEFAULT_OPTS="--color=fg:#C0C0C0,bg:#333333"
source <(fzf --zsh)
