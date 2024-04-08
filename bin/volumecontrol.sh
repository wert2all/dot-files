#!/usr/bin/env sh

# define functions
source $HOME/bin/_functions.sh

function send_notification {
    value=$1
    info=$2

    angle="$(((($value + 2) / 5) * 5))"
    ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
    bar=$(seq -s "." $(($value / 15)) | sed 's/[0-9]//g')
    
    dunstify "t2" -i $ico -a "$value$bar" "$brightinfo" -r 91190 -t 800
}

function get_volume()
{
  pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}

case $1 in
    i) pactl set-sink-volume @DEFAULT_SINK@ +5%
       send_notification $(get_volume) ;;
    d) pactl set-sink-volume @DEFAULT_SINK@ -5%
       send_notification $(get_volume) ;;
    m) pactl set-sink-mute @DEFAULT_SINK@ toggle
       notify_mute "speaker";;
    mm) pactl set-source-mute @DEFAULT_SOURCE@ toggle
        notify_mute "mic";;
    *) print_error ;;
esac

