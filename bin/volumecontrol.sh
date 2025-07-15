#!/usr/bin/env sh

icodir=$HOME"/.config/dunst/icons/vol"

send_notification() {
    dunstify "t2" -a "${1}" -i "${2}" -r 91190 -t 800
}

mute() {
    device=$1

    case $device in
    mic)
        pactlCommand="get-source-mute"
        dsink="@DEFAULT_SOURCE@"
        ;;
    speaker)
        pactlCommand="get-sink-mute"
        dsink="@DEFAULT_SINK@"
        ;;
    esac

    mute=$(pactl "${pactlCommand}" "${dsink}" | cut -d ' ' -f 2)

    if [ "$mute" = "yes" ]; then
        send_notification "muted" "${icodir}/muted-${device}.svg"
    else
        send_notification "unmuted" "${icodir}/unmuted-${device}.svg"
    fi
}

say_volume() {
    angle="$(((($1 + 2) / 5) * 5))"
    send_notification "${1}..." "${icodir}/vol-${angle}.svg"
}

get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}

case $1 in
i)
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    say_volume "$(get_volume)"
    ;;
d)
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    say_volume "$(get_volume)"
    ;;
m)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    mute "speaker"
    ;;
mm)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    mute "mic"
    ;;
*) printf "use i,d,m,mm" ;;
esac
