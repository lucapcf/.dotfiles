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
    VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
    MUTE_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@)
    
    if [[ "$MUTE_STATUS" == "Mute: yes" ]]; then
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
    # Detect the active network interface (excluding loopback and inactive interfaces)
    local interface=$(ip route | grep default | awk '{print $5}')
    
    # Fetch new values
    #rx_new=$(awk -v iface="$interface" '$1 ~ iface {print $2}' /proc/net/dev)
    #tx_new=$(awk -v iface="$interface" '$1 ~ iface {print $10}' /proc/net/dev)

    # Check if no interface was detected
    if [ -z "$interface" ]; then
        echo " 0KB/s  0KB/s"
        return
    fi
    
    local rx_new=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    local tx_new=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    # Calculate RX and TX rates in bytes per second
    local rx_rate=$(( (rx_new - rx_old) / 1024 ))
    local tx_rate=$(( (tx_new - tx_old) / 1024 ))
    
    rx_old=$rx_new
    tx_old=$tx_new

    # Return formatted output
    echo " ${rx_rate}KB/s  ${tx_rate}KB/s"
}


# Main status bar update loop
update_status() {

    # Initialize RX and TX values
    #rx_old=$(awk -v iface="$interface" '$1 ~ iface {print $2}' /proc/net/dev)
    #tx_old=$(awk -v iface="$interface" '$1 ~ iface {print $10}' /proc/net/dev)
    
    while true
    do
        TIME=$(get_time)
        BATTERY=$(get_battery)
        VOLUME=$(get_volume)
        MEMORY=$(get_memory)
        CPU=$(get_cpu)
        WIFI=$(get_wifi)
    #        NET_USAGE=$(get_network_usage)
        
        INFO=" $WIFI | $CPU | $MEMORY | $VOLUME | $BATTERY | $TIME"
        
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

# Detect the active network interface (excluding loopback and inactive interfaces)
interface=$(ip route | grep default | awk '{print $5}')
rx_old=$(cat /sys/class/net/$interface/statistics/rx_bytes)
tx_old=$(cat /sys/class/net/$interface/statistics/tx_bytes)    

update_status &

