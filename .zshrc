# Load environment and PATH
source ~/.zsh/env.zsh

# Load plugin configuration
source ~/.zsh/plugins.zsh

# Load tool integrations
source ~/.zsh/tools.zsh

# Load functions
for file in ~/.zsh/functions/*.zsh; do
  [[ -r "$file" ]] && source "$file"
done
unset file

# Load aliases
for file in ~/.zsh/aliases/*.zsh; do
  [[ -r "$file" ]] && source "$file"
done
unset file



# pnpm
export PNPM_HOME="/home/wert2all/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
