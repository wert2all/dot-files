# wg-toggle - toggle a WireGuard connection up/down
# Usage: wg-toggle <interface>   e.g. wg-toggle us2
# Without arguments: lists available connections
#
# sudo asks password once per sudo timestamp (default 15 min); the whole
# toggle sequence is a single sudo call.
wg-toggle() {
  local iface="$1" out

  if [[ -z "$iface" ]]; then
    echo "Usage: wg-toggle <interface>"
    echo "Available connections:"
    local -a confs
    if [[ -r /etc/wireguard ]]; then
      confs=(/etc/wireguard/*.conf(N))
    else
      confs=(${(f)"$(sudo ls /etc/wireguard 2>/dev/null)"})
    fi
    confs=(${confs[@]:t:r})
    if [[ ${#confs} -eq 0 ]]; then
      echo "  (none found in /etc/wireguard)"
    else
      printf '  %s\n' "${confs[@]}"
    fi
    return 1
  fi

  if ip link show "$iface" &>/dev/null; then
    echo "$iface: VPN is UP - bringing DOWN"
    if ! out=$(sudo wg-quick down "$iface" 2>&1); then
      echo "FAILED: $out" >&2
      return 1
    fi
  else
    echo "$iface: VPN is DOWN - bringing UP"
    if ! out=$(sudo wg-quick up "$iface" 2>&1); then
      echo "FAILED: $out" >&2
      return 1
    fi
  fi

  if ip link show "$iface" &>/dev/null; then
    echo "$iface: VPN is UP"
  else
    echo "$iface: VPN is DOWN"
  fi
}
