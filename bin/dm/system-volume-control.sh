#!/usr/bin/env sh

# Directory for volume icons
ICON_DIR="$HOME/.config/dunst/icons/vol"

# Sends a notification using dunstify
# Usage: send_notification "title" "icon_path"
send_notification() {
    dunstify "t2" -a "Volume: ${1}%" -h "int:value:${1}" -r 91190 -t 800
}

# Toggles mute for a given device type (mic or speaker) and sends a notification
# Usage: toggle_mute "mic" | "speaker"
toggle_mute() {
    device_type=$1
    set_cmd=""
    get_cmd=""
    default_device=""

    case $device_type in
    mic)
        set_cmd="set-source-mute"
        get_cmd="get-source-mute"
        default_device="@DEFAULT_SOURCE@"
        ;;
    speaker)
        set_cmd="set-sink-mute"
        get_cmd="get-sink-mute"
        default_device="@DEFAULT_SINK@"
        ;;
    *)
        echo "Invalid device type: $device_type" >&2
        exit 1
        ;;
    esac

    # Toggle the mute state
    pactl "$set_cmd" "$default_device" toggle

    # Get the new mute status
    mute_status=$(pactl "$get_cmd" "$default_device" | awk '{print $2}')

    if [ "$mute_status" = "yes" ]; then
        dunstify "t2" -a "$device_type muted" -i "${ICON_DIR}/muted-${device_type}.svg" -r 91190 -t 800
    else
        dunstify "t2" -a "$device_type unmuted" -i "${ICON_DIR}/unmuted-${device_type}.svg" -r 91190 -t 800
    fi
}

# Changes the volume for the default sink and sends a notification
# Usage: change_volume "+5%" | "-5%"
change_volume() {
    pactl set-sink-volume @DEFAULT_SINK@ "$1"
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)
    send_notification "${volume}"
}

# Main script logic
case $1 in
i)
    change_volume "+5%"
    ;;
d)
    change_volume "-5%"
    ;;
m)
    toggle_mute "speaker"
    ;;
mm)
    toggle_mute "mic"
    ;;
*)
    printf "Usage: %s [i|d|m|mm]\n" "$0" >&2
    exit 1
    ;;
esac
