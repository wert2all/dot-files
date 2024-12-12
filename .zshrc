# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Android home
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

#go 
export PATH=$HOME/go/bin/:$PATH

# fix tmux patch for wsl2
export TMUX_TMPDIR=/tmp

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-commit zsh-256color zsh-syntax-highlighting zsh-autosuggestions tmux)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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
ssh-add -l > /dev/null
if [ "$?" -ne "0" ]; then
    echo "No ssh keys have been added to your 'ssh-agent' since the last reboot. Adding default keys now."
    ssh-add
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

gitCheckoutAndReset(){
  if [ -n "$1" ]
  then
    git checkout $1
    git reset --hard origin/$1
  fi
}

# NeoVim config
alias zshconfig="nvim ~/.zshrc"
alias vim=nvim
alias unvim="NVIM_APPNAME=\"unvim\" nvim"

alias ll="eza -lh --icons=auto --sort=name --group-directories-first"

alias gph="git push origin HEAD"
alias gau="git add -u && gss"
alias gcr="gitCheckoutAndReset"

alias dus="sudo du -hs \$(ls -A) | sort -h"
eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# aliases
alias p='pnpm'

# Dependencies
alias pa='pnpm add'
alias pad='pnpm add --save-dev'
alias pin='pnpm install'
alias pu='pnpm update'
alias pui='pnpm update --interactive'
alias puil='pnpm update --interactive --latest'

# Run scripts
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
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/tokyo.omp.json)"

