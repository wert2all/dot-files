#!/usr/bin/env sh

# define functions

function print_error
{
cat << "EOF"
    ./volumecontrol.sh -[device] <action>
    ...valid device are...
        i -- [i]nput decive
        o -- [o]utput device
    ...valid actions are...
        i -- <i>ncrease volume [+5]
        d -- <d>ecrease volume [-5]
        m -- <m>ute [x]
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


function notify_mute()
{
    device=$1
    mute=`pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2`
    if [ "$mute" == "yes" ] ; then
        mute="muted"
    else
        mute="unmuted"
    fi

    ico="~/.config/dunst/icons/vol/${mute}-${device}.svg"
    dunstify "t2" -a ${mute} "$nsink" -i ${ico} -r 91190 -t 800
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
    *) print_error ;;
esac

