#!/bin/bash
VPN_NAME=$(wg show interfaces | awk '{print $1}')
if [ -n "$VPN_NAME" ]; then
    echo "{\"text\": \"\", \"class\": \"connected\", \"tooltip\": \"VPN $VPN_NAME connected\"}"
else
    echo ""
fi
