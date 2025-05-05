#!/bin/sh

VAULT_DIRECTORY="$HOME/Documents/obsidian/"

# Iterate over all .md files in the VAULT_DIRECTORY
find "$VAULT_DIRECTORY" -type f -name "*.md" | while read -r file; do
  if [ -f "$file" ]; then
    content=$(cat "$file")
    echo "Processing file: $file"

    # Extract tags from the content
    tags=$(echo "$content" | sed -n '/---/,/---/p' | grep -oP '(?<= - ).*')

    # Format tags as YAML
    if [ -n "$tags" ]; then
      echo "---"
      echo "tags:"
      echo "$tags" | while read -r tag; do
        echo " - $tag"
      done
      echo "---"
    fi
  fi
done
