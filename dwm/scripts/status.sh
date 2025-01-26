#!/bin/bash

# Utility function to get formatted time
get_time() {
    date +"%a - %d/%m/%y | %T"
}

# Utility function to get battery status and capacity
get_battery() {
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

    case $BAT_STATUS in
        "Not charging") BAT_ICON="󱉝 " ;;
        "Discharging")  BAT_ICON="󰁾" ;;
        "Charging")     BAT_ICON=" " ;;
        "Full")         BAT_ICON="󰁹 󰸞" ;;
        *)              BAT_ICON="󰂑 " ;;
    esac

    echo "$BAT_ICON $BAT%"
}

# Utility function to get volume level
get_volume() {
    #VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
    VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    MUTE_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@)
    
    if [ "$MUTE_STATUS" == "Mute: yes" ]; then
        VOLUME_STATUS=" "
    else
        VOLUME_STATUS=" "
    fi
    
    # Limits max volume
    if [ "$VOLUME" -gt 100 ]; then
        pactl set-sink-volume 0 100%
        VOLUME="100"
    fi
    #if [ "$VOLUME" -le 0 ] || [ "$MUTE_STATUS" == "Mute: yes" ]; then
		#    VOLUME_STATUS=" "
	  #fi
    echo "$VOLUME_STATUS $VOLUME%"
}


# Utility function to get memory usage
get_memory() {
    TOTAL_KB=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    FREE_KB=$(awk '/MemFree:/ {print $2}' /proc/meminfo)
    BUFFERS_KB=$(awk '/Buffers:/ {print $2}' /proc/meminfo)
    CACHED_KB=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
    
    TOTAL_GB=$(bc <<< "scale=2; $TOTAL_KB / 1024 / 1024")
    USED_GB=$(bc <<< "scale=2; ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024")
    
    printf " %.2fGB/%.2fGB" "$USED_GB" "$TOTAL_GB"
}

# Utility function to get CPU usage
get_cpu() {
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

    printf " %.2f%%" "$CPU_USAGE"
}

# Utility function to get WiFi status
get_wifi() {
    WIFI=$(nmcli connection show --active | awk '$3 == "wifi" {print $1}')
    echo "  ${WIFI:-No Signal}"
}


# Network monitor function
get_network_usage() {
    local interface
    interface=$(ip route | grep default | awk '{print $5}')

    if [ -z "$interface" ]; then
        echo " 0KB/s  0KB/s"
        return
    fi
    
    local rx_new
    rx_new=$(cat /sys/class/net/"$interface"/statistics/rx_bytes)
    local tx_new
    tx_new=$(cat /sys/class/net/"$interface"/statistics/tx_bytes)

    # Read previous values from files
    local rx_old
    rx_old=$(cat "$1")
    local tx_old
    tx_old=$(cat "$2")

    local rx_rate
    rx_rate=$(echo "scale=2; ($rx_new - $rx_old)" | bc)
    local tx_rate
    tx_rate=$(echo "scale=2; ($tx_new - $tx_old)" | bc)
    
    local rx_unit
    rx_unit="B/s"
    local tx_unit
    tx_unit="B/s"

    # Convert RX and TX rates to appropriate units
    if [ "$(echo "$rx_rate > 1024" | bc -l)" -eq 1 ]; then
        rx_rate=$(echo "scale=2; $rx_rate / 1024" | bc)
        rx_unit="KB/s"
    fi
    if [ "$(echo "$rx_rate > 1024" | bc -l)" -eq 1 ]; then
        rx_rate=$(echo "scale=2; $rx_rate / 1024" | bc)
        rx_unit="MB/s"
    fi
    if [ "$(echo "$rx_rate > 1024" | bc -l)" -eq 1 ]; then
        rx_rate=$(echo "scale=2; $rx_rate / 1024" | bc)
        rx_unit="GB/s"
    fi

    if [ "$(echo "$tx_rate > 1024" | bc -l)" -eq 1 ]; then
        tx_rate=$(echo "scale=2; $tx_rate / 1024" | bc)
        tx_unit="KB/s"
    fi
    if [ "$(echo "$tx_rate > 1024" | bc -l)" -eq 1 ]; then
        tx_rate=$(echo "scale=2; $tx_rate / 1024" | bc)
        tx_unit="MB/s"
    fi
    if [ "$(echo "$tx_rate > 1024" | bc -l)" -eq 1 ]; then
        tx_rate=$(echo "scale=2; $tx_rate / 1024" | bc)
        tx_unit="GB/s"
    fi

    # Save current values for next iteration
    echo "$rx_new" > "$1"
    echo "$tx_new" > "$2"

    echo " ${rx_rate}${rx_unit}  ${tx_rate}${tx_unit}"
}

update_status() {

    RX_FILE="$XDG_RUNTIME_DIR/.network_rx"
    TX_FILE="$XDG_RUNTIME_DIR/.network_tx"

    # Detect the active network interface (excluding loopback and inactive interfaces)
    interface=$(ip route | grep default | awk '{print $5}')

    rx=$(cat /sys/class/net/"$interface"/statistics/rx_bytes)
    tx=$(cat /sys/class/net/"$interface"/statistics/tx_bytes)
    echo "$rx" > "$RX_FILE"
    echo "$tx" > "$TX_FILE"
    
    while true
    do
        TIME=$(get_time)
        BATTERY=$(get_battery)
        VOLUME=$(get_volume)
        MEMORY=$(get_memory)
        CPU=$(get_cpu)
        WIFI=$(get_wifi)
        NET_USAGE=$(get_network_usage "$RX_FILE" "$TX_FILE")
        
        INFO=" $NET_USAGE | $WIFI | $CPU | $MEMORY | $VOLUME | $BATTERY | $TIME "
        
        # Low battery warning
        BAT=$(echo "$BATTERY" | grep -o '[0-9]*')
        if [ "$BAT" -le 20 ] && [[ "$BATTERY" == *"󰁾"* ]]; then
            xsetroot -name "   Low Battery!    "
            sleep 1
            xsetroot -name "$INFO"
            sleep 5
        else
            xsetroot -name "$INFO"
        fi
        
        sleep 1
    done
}

update_status

