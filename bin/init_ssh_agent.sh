#!/usr/bin/env sh
SSH_ENV="$HOME/.ssh/agent.env"

echo "Initialising new SSH agent..."
ssh-agent -s | sed 's/^echo/#echo/' >"${SSH_ENV}"
chmod 600 "${SSH_ENV}"
. "${SSH_ENV}" >/dev/null
