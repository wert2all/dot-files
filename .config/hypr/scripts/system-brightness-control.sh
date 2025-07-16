#!/usr/bin/env bash

function print_error {
    cat <<EOF
    Usage: $(basename "$0") <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function get_brightness {
    brightnessctl info | grep -oP '(?<=\()\d+(?=%)'
}

function send_notification {
    local brightness
    brightness=$(get_brightness)

    dunstify "t2" -a "Brightness: $brightness%" -h "int:value:$brightness" -r 91190 -t 800
}

case $1 in
i) # increase the backlight by 5%
    brightnessctl set +5%
    send_notification
    ;;
d) # decrease the backlight by 5%
    if [[ $(get_brightness) -le 5 ]]; then
        # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 5%-
    fi
    send_notification
    ;;
*) # print error
    print_error
    exit 1
    ;;
esac
