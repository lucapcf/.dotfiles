#!/bin/bash

# Utility functions
get_battery_info() {
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

    case $BAT_STATUS in
        "Not charging") BAT_ICON="󱉝 " ;;
        "Discharging") BAT_ICON="󰁾" ;;
        "Charging") BAT_ICON=" " ;;
        "Full") BAT_ICON="󰁹 󰸞" ;;
    esac
}

get_volume_info() {
    VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    MUTE_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@)

    VOLUME_STATUS=" "
    if [ "$VOLUME" -gt 150 ]; then
        pactl set-sink-volume 0 150%
    fi

    if [ "$VOLUME" -le 0 ] || [ "$MUTE_STATUS" == "Mute: yes" ]; then
        VOLUME_STATUS=" "
    fi
}

get_memory_info() {
    TOTAL_KB=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    FREE_KB=$(awk '/MemFree:/ {print $2}' /proc/meminfo)
    BUFFERS_KB=$(awk '/Buffers:/ {print $2}' /proc/meminfo)
    CACHED_KB=$(awk '/^Cached:/ {print $2}' /proc/meminfo)

    TOTAL_GB=$(bc <<< "scale=2; $TOTAL_KB / 1024 / 1024")
    USED_GB=$(bc <<< "scale=2; ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024")
    FORMATTED_USED_GB=$(printf "%.2f" "$USED_GB")
}

get_cpu_usage() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
    FORMATTED_CPU_USAGE=$(printf "%.2f" "$CPU_USAGE")
}

get_wifi_info() {
    WIFI=$(nmcli connection show --active | awk '$3 == "wifi" {print $1}')
    if [ "$WIFI" == "" ]; then
        WIFI="No Signal"
    fi
}

update_dwm_status() {
    INFO=" $WIFI |   $FORMATTED_CPU_USAGE% |   ${FORMATTED_USED_GB}GB/${TOTAL_GB}GB | $VOLUME_STATUS $VOLUME% | $BAT_ICON $BAT% | $TIME "
    if [ $(($BAT)) -le 20 ] && [ "$BAT_STATUS" != "Charging" ]; then
        xsetroot -name "                                                  "
        sleep 1
        xsetroot -name "$INFO"
        sleep 5
        xsetroot -name "󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 "
    else
        xsetroot -name "$INFO"
    fi
}

# Main function
dwm_status() {
    while true; do
        TIME=$(date +"%a - %d/%m/%y | %T")

        get_battery_info
        get_volume_info
        get_memory_info
        get_cpu_usage
        get_wifi_info
        get_network_info
        update_dwm_status

        sleep 1
    done
}

dwm_status &

