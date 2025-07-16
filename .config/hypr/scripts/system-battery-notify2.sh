#!/bin/bash

MIN_CRITICAL_THRESHOLD=5
MAX_CRITICAL_THRESHOLD=80
MIN_LOW_THRESHOLD=20
LOW_UNPLUG_BOUNDARY_THRESHOLD=80
MAX_UNPLUG_THRESHOLD=100
MIN_TIMER_SECONDS=60
MAX_TIMER_SECONDS=1000
MIN_FULL_THRESHOLD=80
MAX_FULL_THRESHOLD=100
MIN_NOTIFY_MINUTES=1
MAX_NOTIFY_MINUTES=60
MIN_INTERVAL_PERCENT=1
MAX_INTERVAL_PERCENT=10
is_verbose=false
notify_on_status_change=false

trap resume_processes SIGINT

in_range() {
    local num=$1
    local min=$2
    local max=$3
    [[ $num =~ ^[0-9]+$ ]] && ((num >= min && num <= max))
}

is_laptop() { # Check if the system is a laptop using upower
    if upower -e | grep -q 'battery'; then
        return 0
    else
        echo "Cannot Detect a Battery."
        exit 0
    fi
}

fn_verbose() {
    if $is_verbose; then
        cat <<VERBOSE
=============================================
        Battery Status: $battery_status
        Battery Percentage: $battery_percentage
=============================================
VERBOSE
    fi
}

fn_notify() {                                    # Send notification
    notify-send -a "Power" $1 -u $2 "$3" "$4" -p # Call the notify-send command with the provided arguments \$1 is the flags \$2 is the urgency \$3 is the title \$4 is the message
}

fn_percentage() {
    if [[ "$battery_percentage" -ge "$unplug_charger_threshold" ]] && [[ "$battery_status" != "Discharging" ]] && [[ "$battery_status" != "Full" ]] && (((battery_percentage - last_notified_percentage) >= $notify_interval_percent)); then
        if $is_verbose; then echo "Prompt:UNPLUG: $battery_unplug_threshold $battery_status $battery_percentage"; fi
        fn_notify "-t 5000 " "CRITICAL" "Battery Charged" "Battery is at $battery_percentage%. You can unplug the charger!"
        last_notified_percentage=$battery_percentage
    elif [[ "$battery_percentage" -le "$battery_critical_threshold" ]]; then
        count=$((critical_action_countdown_seconds > $MIN_TIMER_SECONDS ? critical_action_countdown_seconds : $MIN_TIMER_SECONDS)) # reset count
        while [ $count -gt 0 ] && [[ $battery_status == "Discharging"* ]]; do
            for battery in /sys/class/power_supply/BAT*; do battery_status=$(<"$battery/status"); done
            if [[ $battery_status != "Discharging" ]]; then break; fi
            fn_notify "-t 5000 -r 69 " "CRITICAL" "Battery Critically Low" "$battery_percentage% is critically low. Device will execute $critical_action_command in $((count / 60)):$((count % 60)) ."
            count=$((count - 1))
            sleep 1
        done
        [ $count -eq 0 ] && fn_action
    elif [[ "$battery_percentage" -le "$battery_low_threshold" ]] && [[ "$battery_status" == "Discharging" ]] && (((last_notified_percentage - battery_percentage) >= $notify_interval_percent)); then
        if $is_verbose; then echo "Prompt:LOW: $battery_low_threshold $battery_status $battery_percentage"; fi
        fn_notify "-t 5000 " "CRITICAL" "Battery Low" "Battery is at $battery_percentage%. Connect the charger."
        last_notified_percentage=$battery_percentage
    fi
}
fn_action() {                              #handles the $critical_action_command command
    count=$((critical_action_countdown_seconds > $MIN_TIMER_SECONDS ? critical_action_countdown_seconds : $MIN_TIMER_SECONDS)) # reset count
    nohup $critical_action_command
}

fn_status() {
    if [[ $battery_percentage -ge $battery_full_threshold ]] && [ "$battery_status" == *"Charging"* ]; then
        echo "Full and $battery_status"
        battery_status="Full"
    fi
    case "$battery_status" in # Handle the power supply status
    "Discharging")
        if $is_verbose; then echo "Case:$battery_status Level: $battery_percentage"; fi
        if [[ "$prev_status" != "Discharging" ]] || [[ "$prev_status" == "Full" ]]; then
            prev_status=$battery_status
            urgency=$([[ $battery_percentage -le "$battery_low_threshold" ]] && echo "CRITICAL" || echo "NORMAL")
            fn_notify "-t 5000 -r 54321 " "$urgency" "Charger Plug OUT" "Battery is at $battery_percentage%."
        fi
        fn_percentage
        ;;
    "Not"* | "Charging")
        if $is_verbose; then echo "Case:$battery_status Level: $battery_percentage"; fi
        # Due to modifications of some devices Not Charging after reaching 99 or limits
        #if [[ ! -f "/tmp/hyprdots.batterynotify.status.$battery_status-$$" ]] && [[ "$battery_status" == "Not"* ]] ; then
        #touch "/tmp/hyprdots.batterynotify.status.$battery_status-$$"
        #count=$(( critical_action_countdown_seconds > $MIN_TIMER_SECONDS ? critical_action_countdown_seconds :  $MIN_TIMER_SECONDS )) # reset count
        #echo "Status: '==>> "$battery_status" <<==' Device Reports Not Charging!,This may be device Specific errors."
        #fn_notify  "-t 5000  " "CRITICAL" "Charger Plug In" "Battery is at $battery_percentage%."
        #fi
        if [[ "$prev_status" == "Discharging" ]] || [[ "$prev_status" == "Not"* ]]; then
            prev_status=$battery_status
            count=$((critical_action_countdown_seconds > $MIN_TIMER_SECONDS ? critical_action_countdown_seconds : $MIN_TIMER_SECONDS)) # reset count
            urgency=$([[ "$battery_percentage" -ge $unplug_charger_threshold ]] && echo "CRITICAL" || echo "NORMAL")
            fn_notify "-t 5000 -r 54321 " "$urgency" "Charger Plug In" "Battery is at $battery_percentage%."
        fi
        fn_percentage
        ;;
    "Full")
        if $is_verbose; then echo "Case:$battery_status Level: $battery_percentage"; fi

        if [[ $battery_status != "Discharging" ]]; then
            now=$(date +%s)
            if [[ "$prev_status" == *"harging"* ]] || ((now - last_full_notification_timestamp >= $((full_notify_interval_minutes * 60)))); then
                fn_notify "-t 5000 -r 54321" "CRITICAL" "Battery Full" "Please unplug your Charger"
                prev_status=$battery_status last_full_notification_timestamp=$now
            fi
        fi
        ;;
    *)
        if [[ ! -f "/tmp/hyprdots.batterynotify.status.fallback.$battery_status-$$" ]]; then
            echo "Status: '==>> "$battery_status" <<==' Script on Fallback mode,Unknown power supply status.Please copy this line and raise an issue to the Github Repo.Also run 'ls /tmp/hyprdots.batterynotify' to see the list of lock files.*"
            touch "/tmp/hyprdots.batterynotify.status.fallback.$battery_status-$$"
        fi
        fn_percentage
        ;;
    esac
}

fn_status_change() { # Handle when status changes
    for battery in /sys/class/power_supply/BAT*; do
        battery_status=$(<"$battery/status") battery_percentage=$(<"$battery/capacity")
        if [ "$battery_status" != "$last_battery_status" ] || [ "$battery_percentage" != "$last_battery_percentage" ]; then
            last_battery_status=$battery_status last_battery_percentage=$battery_percentage # Check if battery status or percentage has changed
            fn_verbose
            fn_percentage
            if $notify_on_status_change; then fn_status echo yes; fi
        fi
    done
}

resume_processes() {
    for pid in $pids; do if [ $pid -ne $current_pid ]; then
        kill -CONT $pid
        notify-send -a "Battery Notify" -t 2000 -r 9889 -u "CRITICAL" "Debugging ENDED, Resuming Regular Process"
    fi; done
}

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "A script to monitor battery status and send notifications."
    echo ""
    echo "Options:"
    echo "  -v, --verbose         Enable verbose mode for debugging."
    echo "  --undock, on          Show notifications for charger plug/unplug and full battery."
    echo "  -f, --full PERCENT    Set the battery full threshold (default: 100). Range: $MIN_FULL_THRESHOLD-$MAX_FULL_THRESHOLD."
    echo "  -c, --critical PERCENT Set the battery critical threshold (default: 10). Range: $MIN_CRITICAL_THRESHOLD-$MAX_CRITICAL_THRESHOLD."
    echo "  -l, --low PERCENT     Set the battery low threshold (default: 20). Range: $MIN_LOW_THRESHOLD-$LOW_UNPLUG_BOUNDARY_THRESHOLD."
    echo "  -u, --unplug PERCENT  Set the unplug charger notification threshold (default: 80). Range: $LOW_UNPLUG_BOUNDARY_THRESHOLD-$MAX_UNPLUG_THRESHOLD."
    echo "  -t, --timer SECONDS   Set the countdown timer in seconds for the critical action (default: 120). Range: $MIN_TIMER_SECONDS-$MAX_TIMER_SECONDS."
    echo "  -i, --interval PERCENT Set the notification interval for low/unplug warnings (default: 5). Range: $MIN_INTERVAL_PERCENT-$MAX_INTERVAL_PERCENT."
    echo "  -n, --notify MINUTES  Set the notification interval in minutes for the 'full' status (default: 1440). Range: $MIN_NOTIFY_MINUTES-$MAX_NOTIFY_MINUTES."
    echo "  -e, --execute COMMAND The command to execute when the critical threshold is reached (default: 'systemctl suspend')."
    echo "  -h, --help            Show this help message and exit."
    echo ""
    echo "Examples:"
    echo "  $0 --critical 15 --low 25"
    echo "  $0 -c 15 -l 25"
    echo "  $0 --execute 'shutdown now'"
    echo ""
    echo "For more information, visit: https://github.com/prasanthrangan/hyprdots"
    exit 0
}

# Main function
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -f|--full)
            if in_range "$2" "$MIN_FULL_THRESHOLD" "$MAX_FULL_THRESHOLD"; then
                battery_full_threshold=$2
                shift 2
            else
                echo "Error: --full must be between $MIN_FULL_THRESHOLD and $MAX_FULL_THRESHOLD." >&2
                exit 1
            fi
            ;;
        -c|--critical)
            if in_range "$2" "$MIN_CRITICAL_THRESHOLD" "$MAX_CRITICAL_THRESHOLD"; then
                battery_critical_threshold=$2
                shift 2
            else
                echo "Error: --critical must be between $MIN_CRITICAL_THRESHOLD and $MAX_CRITICAL_THRESHOLD." >&2
                exit 1
            fi
            ;;
        -l|--low)
            if in_range "$2" "$MIN_LOW_THRESHOLD" "$LOW_UNPLUG_BOUNDARY_THRESHOLD"; then
                battery_low_threshold=$2
                shift 2
            else
                echo "Error: --low must be between $MIN_LOW_THRESHOLD and $LOW_UNPLUG_BOUNDARY_THRESHOLD." >&2
                exit 1
            fi
            ;;
        -u|--unplug)
            if in_range "$2" "$LOW_UNPLUG_BOUNDARY_THRESHOLD" "$MAX_UNPLUG_THRESHOLD"; then
                unplug_charger_threshold=$2
                shift 2
            else
                echo "Error: --unplug must be between $LOW_UNPLUG_BOUNDARY_THRESHOLD and $MAX_UNPLUG_THRESHOLD." >&2
                exit 1
            fi
            ;;
        -t|--timer)
            if in_range "$2" "$MIN_TIMER_SECONDS" "$MAX_TIMER_SECONDS"; then
                critical_action_countdown_seconds=$2
                shift 2
            else
                echo "Error: --timer must be between $MIN_TIMER_SECONDS and $MAX_TIMER_SECONDS." >&2
                exit 1
            fi
            ;;
        -n|--notify)
            if in_range "$2" "$MIN_NOTIFY_MINUTES" "$MAX_NOTIFY_MINUTES"; then
                full_notify_interval_minutes=$2
                shift 2
            else
                echo "Error: --notify must be between $MIN_NOTIFY_MINUTES and $MAX_NOTIFY_MINUTES." >&2
                exit 1
            fi
            ;;
        -i|--interval)
            if in_range "$2" "$MIN_INTERVAL_PERCENT" "$MAX_INTERVAL_PERCENT"; then
                notify_interval_percent=$2
                shift 2
            else
                echo "Error: --interval must be between $MIN_INTERVAL_PERCENT and $MAX_INTERVAL_PERCENT." >&2
                exit 1
            fi
            ;;
        -v|--verbose)
            is_verbose=true
            shift
            ;;
        --undock)
            notify_on_status_change=true
            shift
            ;;
        -e|--execute)
            critical_action_command=$2
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

if is_laptop; then
    rm -fr /tmp/hyprdots.batterynotify* # Cleaning the lock file
    battery_full_threshold=${battery_full_threshold:-100}
    battery_critical_threshold=${battery_critical_threshold:-10}
    unplug_charger_threshold=${unplug_charger_threshold:-80}
    battery_low_threshold=${battery_low_threshold:-20}
    critical_action_countdown_seconds=${critical_action_countdown_seconds:-120}
    full_notify_interval_minutes=${full_notify_interval_minutes:-1140}
    notify_interval_percent=${notify_interval_percent:-5}

    critical_action_command=${critical_action_command:-"systemctl suspend"}
    cat <<EOF
Script is running...
Check $0 --help for options.

      STATUS      THRESHOLD    INTERVAL
      Full        $battery_full_threshold          $full_notify_interval_minutes Minutes
      Critical    $battery_critical_threshold           $critical_action_countdown_seconds Seconds then "$critical_action_command"
      Low         $battery_low_threshold           $notify_interval_percent Percent
      Unplug      $unplug_charger_threshold          $notify_interval_percent Percent


EOF
    if $is_verbose; then
        for line in "Verbose Mode is ON..." "" "" "" ""; do echo $line; done
        current_pid=$$
        pids=$(pgrep -f "/bin/bash $HOME/.config/hypr/scripts/batterynotify.sh")
        for pid in $pids; do if [ $pid -ne $current_pid ]; then
            kill -STOP $pid
            notify-send -a "Battery Notify" -t 2000 -r 9889 -u "CRITICAL" "Debugging STARTED, Pausing Regular Process"
        fi; done
        trap resume_processes SIGINT
    fi
    fn_status_change # initiate the function
    last_notified_percentage=$battery_percentage
    prev_status=$battery_status

    dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',path='$(upower -e | grep battery)'" 2>/dev/null | while read -r battery_status_change; do fn_status_change; done
fi
