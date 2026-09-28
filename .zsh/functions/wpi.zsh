# wpi - run pi inside an isolated 'wg-netns' namespace with WireGuard up.
# Only pi's traffic goes through the VPN; the rest of the system is untouched.
# VPN lives exactly as long as the pi session - torn down on exit.
#
# Connection config: WG_NETNS_CONF (default: us2)
#   WG_NETNS_CONF=nl5 wpi
#
# wpi-clean - remove a leaked namespace (e.g. after the terminal was closed
# inside a pi session). Normally wpi cleans up itself.
#
# sudo asks password once per sudo timestamp (default 15 min); the whole
# setup chain then runs without asking again.
wpi() {
  local conf="${WG_NETNS_CONF:-us2}"
  local tmp="wg-netns-tmp"
  local stripped line addr mtu endpoint_ip rc
  local -a addrs dnses

  # auto-recover a namespace leaked with a different connection
  if sudo ip netns list | cut -d' ' -f1 | grep -qx "wg-netns"; then
    if ! sudo ip netns exec wg-netns ip link show "$conf" &>/dev/null; then
      echo "wpi: stale namespace found, rebuilding..."
      wpi-clean
    fi
  fi

  if ! sudo ip netns list | cut -d' ' -f1 | grep -qx "wg-netns"; then
    echo "wpi: creating namespace..."
    sudo ip netns add wg-netns || return 1
    sudo mkdir -p /etc/netns/wg-netns || return 1
  fi

  sudo ip netns exec wg-netns ip link set lo up

  if ! sudo ip netns exec wg-netns ip link show "$conf" &>/dev/null; then
    echo "wpi: bringing up $conf..."

    if sudo ip link show "$tmp" &>/dev/null; then
      echo "FAILED: interface $tmp already exists on host" >&2
      return 1
    fi

    # create wg iface on host, configure, move into ns, rename
    sudo ip link add "$tmp" type wireguard || return 1
    stripped=$(mktemp)
    if ! sudo wg-quick strip "$conf" > "$stripped"; then
      sudo ip link del "$tmp"
      rm -f "$stripped"
      return 1
    fi
    if ! sudo wg setconf "$tmp" "$stripped"; then
      sudo ip link del "$tmp"
      rm -f "$stripped"
      return 1
    fi
    rm -f "$stripped"

    # keep the ns tunnel working while the host VPN is up: host wg-quick adds
    # "not fwmark ... -> table 51820" rules that pull this tunnel's outer packets
    # into the host tunnel. Route packets to the endpoint via the main table instead.
    endpoint_ip=$(sudo wg show "$tmp" endpoints | awk '{print $2}' | cut -d: -f1)
    if [[ -n "$endpoint_ip" ]]; then
      sudo ip rule add priority 100 to "$endpoint_ip" table main 2>/dev/null || true
    fi

    sudo ip link set "$tmp" netns wg-netns || return 1
    sudo ip netns exec wg-netns ip link set "$tmp" name "$conf"
    sudo ip netns exec wg-netns ip link set "$conf" up

    # MTU from conf (wg-quick strip drops this line; without it the interface
    # stays at 1500 and large packets die inside the tunnel -> request timeouts)
    line=$(sudo grep '^MTU' "/etc/wireguard/$conf.conf" | cut -d= -f2)
    mtu="${line// /}"
    [[ -z "$mtu" ]] && mtu=1420
    sudo ip netns exec wg-netns ip link set dev "$conf" mtu "$mtu"

    # addresses from conf (Address = a/32,b/128,...)
    line=$(sudo grep '^Address' "/etc/wireguard/$conf.conf" | cut -d= -f2)
    addrs=(${(s:,:)${line// /}})
    for addr in "${addrs[@]}"; do
      sudo ip netns exec wg-netns ip addr add "$addr" dev "$conf"
    done

    # route everything through the tunnel
    sudo ip netns exec wg-netns ip route add default dev "$conf"
    sudo ip netns exec wg-netns ip -6 route add default dev "$conf" 2>/dev/null || true

    # namespace-local DNS (bind-mounted over /etc/resolv.conf by ip netns exec)
    line=$(sudo grep '^DNS' "/etc/wireguard/$conf.conf" | cut -d= -f2)
    dnses=(${(s:,:)${line// /}})
    [[ ${#dnses[@]} -eq 0 ]] && dnses=(1.1.1.1)
    printf 'nameserver %s\n' "${dnses[@]}" | sudo tee /etc/netns/wg-netns/resolv.conf > /dev/null

    echo "wpi: $conf is up"
  fi

  # run the pi zsh FUNCTION inside the namespace: nested zsh sources .zshrc,
  # pi() calls check_api_keys -> iap -> pass there, so keys are loaded
  # inside the ns (gpg-agent socket is reachable - netns does not
  # isolate the filesystem) and inherited by the pi binary normally.
  # "pi" below is $0 for the inner script, remaining args are its positionals.
  sudo ip netns exec wg-netns \
    setpriv --reuid="$(id -u)" --regid="$(id -g)" --init-groups \
    env HOME="$HOME" USER="$USER" LOGNAME="$USER" PATH="$PATH" TERM="$TERM" \
    zsh -ic 'pi "$@"' pi "$@"
  rc=$?

  # VPN lives only as long as the pi session
  wpi-clean
  return $rc
}

wpi-clean() {
  local ep
  if sudo ip netns list | cut -d' ' -f1 | grep -qx "wg-netns"; then
    # remove endpoint-bypass rules before the ns is gone
    for ep in $(sudo ip netns exec wg-netns wg show all endpoints 2>/dev/null | awk '{print $3}' | cut -d: -f1); do
      sudo ip rule del priority 100 to "$ep" table main 2>/dev/null || true
    done
    sudo ip netns del wg-netns
    echo "wpi: namespace removed"
  else
    echo "wpi: namespace not created"
  fi
  # leftover bookkeeping file from an older version - remove if present
  sudo rm -f /etc/netns/wg-netns/endpoint
}
