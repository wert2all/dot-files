#!/usr/bin/env sh

# define functions
source $HOME/bin/_functions.sh

function send_notification {
    vol=$1
    angle="$(( (($vol+2)/5) * 5 ))"
    ico="${icodir}/vol-${angle}.svg"
    bar=$(seq -s "." $(($vol / 15)) | sed 's/[0-9]//g')
    dunstify "t2" -a "$vol$bar" "$nsink" -i $ico -r 91190 -t 800
}

function get_volume()
{
  pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}

icodir=$HOME"/home/wert2all/.config/dunst/icons/vol"

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

