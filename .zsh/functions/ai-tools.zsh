check_api_keys() {
  if [[ -z "$API_KEYS_LOADED" ]]; then
    echo "Loading API keys first..."
    iap
  fi
}

# OpenCode wrapper
oc() {
  check_api_keys
  opencode "$@"
}

# Translation alias
translate() {
  if [ -z "$1" ]; then
    echo "Usage: translate <lang_code>"
    echo "Example: cat file.md | translate uk-ua"
    return 1
  fi
  check_api_keys
  fabric -v="lang_code:$1" -p translate
}

pi() {
  check_api_keys
  ~/.local/share/pnpm/pi "$@"
}

pi_quick() {
  pi -p --provider ${PI_QUICK_PROVIDER} --model ${PI_QUICK_MODEL} "$@"
}

# Question mark alias for opencode with special symbol support
question() {
  if [ $# -eq 0 ]; then
    echo "Usage: ? <your question>"
    return 1
  fi
  pi_quick "$*"
}

# aicom - AI commit message generator
# Uses a temp file to handle large staged diffs
aicom() {
  local diff_file
  diff_file=$(mktemp)
  git diff --cached >"$diff_file"
  pi_quick @~/.zsh/ai/commit_changes.md <"$diff_file"
  rm -f "$diff_file"
}
