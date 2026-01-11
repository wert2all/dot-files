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

