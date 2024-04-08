#!/usr/bin/env sh

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

# VOLUME
function notify_mute()
{
    device=$1

    case $device in
        mic) pactlCommand="get-source-mute"
            dsink="@DEFAULT_SOURCE@";;
        speaker) pactlCommand="get-sink-mute"
            dsink="@DEFAULT_SINK@";;
        *) print_error ;;
    esac

    mute=`pactl $pactlCommand $dsink | cut -d ' ' -f 2`
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

