#!/usr/bin/env sh

function print_error
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function send_notification {
    value=$1
    info=$2

    angle="$(((($value + 2) / 5) * 5))"
    ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
    bar=$(seq -s "." $(($value / 15)) | sed 's/[0-9]//g')
    
    dunstify "t2" -i $ico -a "$value$bar" "$brightinfo" -r 91190 -t 800
}

function get_brightness {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)  # increase the backlight by 5%
    brightnessctl set +5% ;;
d)  # decrease the backlight by 5%
    if [[ $(get_brightness) -lt 5 ]] ; then
        # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 5%-
    fi;;
*)  # print error
    print_error ;;
esac
value=`brightnessctl info | grep -oP "(?<=\()\d+(?=%)" | cat`
info=$(brightnessctl info | awk -F "'" '/Device/ {print $2}')

send_notification $value 
