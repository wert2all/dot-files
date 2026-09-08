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
