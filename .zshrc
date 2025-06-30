# read .env file
if [ -f .env ]; then
  set -a && source .env && set +a
fi
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
source $HOME/.antidote/antidote.zsh

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=(/path/to/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh

#
# Auto-start the ssh agent and add necessary keys once per reboot.
#
# This is recommended to be added to your ~/.bash_aliases (preferred) or ~/.bashrc file on any
# remote ssh server development machine that you generally ssh into, and from which you must ssh
# into other machines or servers, such as to push code to GitHub over ssh. If you only graphically
# log into this machine, however, there is no need to do this, as Ubuntu's Gnome window manager,
# for instance, will automatically start and manage the `ssh-agent` for you instead.
#
# See:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home/.ssh#auto-starting-the-the-ssh-agent-on-a-remote-ssh-based-development-machine

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  echo "'ssh-agent' has not been started since the last reboot. Starting 'ssh-agent' now."
  eval "$(ssh-agent -s)"
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
# see if any key files are already added to the ssh-agent, and if not, add them
ssh-add -l >/dev/null
if [ "$?" -ne "0" ]; then
  echo "No ssh keys have been added to your 'ssh-agent' since the last reboot. Adding default keys now."
  ssh-add
fi

# NeoVim config
alias vim=nvim

alias ll="eza -lh --icons=auto --sort=name --group-directories-first"

# Git aliases

gitCheckoutAndReset() {
  if [ -n "$1" ]; then
    git checkout $1
    git reset --hard origin/$1
  fi
}

alias gfa='git fetch --all --tags --prune --jobs=10'
alias gss='git status --short'
alias gd= 'git diff --output-indicator-new=" " --output-indicator-old=" "'
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
