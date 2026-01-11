gitCheckoutAndReset() {
  if [ -n "$1" ]; then
    git checkout "$1"
    git reset --hard origin/"$1"
  fi
}
