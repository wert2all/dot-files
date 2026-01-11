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

# Question mark alias for opencode with special symbol support
question() {
  if [ $# -eq 0 ]; then
    echo "Usage: ? <your question>"
    return 1
  fi
  oc run --agent chat "$*"
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
