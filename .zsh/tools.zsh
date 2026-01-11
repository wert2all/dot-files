# History settings
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# FZF configuration
export FZF_DEFAULT_OPTS="--color=fg:#C0C0C0,bg:#333333"

# Kitty SSH fix
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# Load completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit
