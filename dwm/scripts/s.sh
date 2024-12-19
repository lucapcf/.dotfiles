#!/bin/bash

killable_sleep() {
    # Ensure we don´t run an eventual sleep shell builtin
    command sleep &
    # TODO: get child pid
    echo "$sleep_pid" > "$XDG_RUNTIME_DIR/dwm_status_sleep.pid"
    # TODO: wait for sleep
}

# Function to get current time
dwm_status() {
    while true; do
        # Get the current time and format it as you wish
        TIME=$(date +"%a - %d/%m/%y | %T")

        # Get the battery info
	      BAT=$(cat /sys/class/power_supply/BAT0/capacity)
	      BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
	
	      # Get the volume level
	      VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
        VOLUME_STATUS=" "

        MUTE_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@)
	      
        # Limits max volume
	      if [ "$VOLUME" -gt 150 ]; then
		        pactl set-sink-volume 0 150%
	      fi

        if [ "$VOLUME" -le 0 ] || [ "$MUTE_STATUS" == "Mute: yes" ]; then
		        VOLUME_STATUS=" "
	      fi

        case $BAT_STATUS in

          "Not charging")
            BAT_ICON="󱉝 "
            ;;

          "Discharging")
            BAT_ICON="󰁾"
            ;;

          "Charging")
            BAT_ICON=" "
            ;;

          "Full")
            BAT_ICON="󰁹 󰸞"
            ;;
        esac

	      # Extract memory data
        TOTAL_KB=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
        FREE_KB=$(awk '/MemFree:/ {print $2}' /proc/meminfo)
        BUFFERS_KB=$(awk '/Buffers:/ {print $2}' /proc/meminfo)
        CACHED_KB=$(awk '/^Cached:/ {print $2}' /proc/meminfo)

	      # Calculate indicators
	      TOTAL_GB=$(bc <<< "scale=2; $TOTAL_KB / 1024 / 1024")
	      USED_GB=$(bc <<< "scale=2; ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024")
	
	      # Ensure used RAM is displayed with two decimal places
        FORMATTED_USED_GB=$(printf "%.2f" "$USED_GB")

        # Extract CPU data
        #USER=$(awk '/^cpu / {print $2}' /proc/stat)
        #NICE=$(awk '/^cpu / {print $3}' /proc/stat)
        #SYSTEM=$(awk '/^cpu / {print $4}' /proc/stat)
        #IDLE=$(awk '/^cpu / {print $5}' /proc/stat)

        # Calculate total and usage time
        #TOTAL_TIME=$(bc <<< "$USER + $NICE + $SYSTEM + $IDLE")
        #CPU_USAGE=$(bc <<< "scale=2; ($USER + $SYSTEM) * 100 / $TOTAL_TIME")
        CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}'
)

	      # Ensure CPU usage is displayed with two decimal places
        FORMATTED_CPU_USAGE=$(printf "%.2f" "$CPU_USAGE")

        # WIFI
        WIFI=$(nmcli connection show --active | awk '$3 == "wifi" {print $1}')
        
        if [ "$WIFI" == "" ]; then
          WIFI="No Signal"
        fi

        # Detect the active network interface (excluding loopback and inactive interfaces)
        interface=$(ip route | grep default | awk '{print $5}')
        # Check if an interface was detected
        if [ -z "$interface" ]; then
            rx_rate="0"
            tx_rate="0"
        fi

        # Capture the initial values
        initial_rx=$(awk -v iface="$interface" '$1 ~ iface {print $2}' /proc/net/dev)
        initial_tx=$(awk -v iface="$interface" '$1 ~ iface {print $10}' /proc/net/dev)

        sleep 1  # Interval to measure data rate (adjustable)

        # Capture the values after 1 second
        final_rx=$(awk -v iface="$interface" '$1 ~ iface {print $2}' /proc/net/dev)
        final_tx=$(awk -v iface="$interface" '$1 ~ iface {print $10}' /proc/net/dev)

        # Calculate the rate in KB/s
        dw_rate=$(( (final_rx - initial_rx) / 1024 ))
        up_rate=$(( (final_tx - initial_tx) / 1024 ))

        # Print the results
        echo -e "Download: ${rx_rate} KB/s | Upload: ${tx_rate} KB/s"

        INFO="|  $dw_rate KB/s |  $up_rate KB/s |  $WIFI |   $FORMATTED_CPU_USAGE% |   ${FORMATTED_USED_GB}GB/${TOTAL_GB}GB | $VOLUME_STATUS $VOLUME% | $BAT_ICON $BAT% | $TIME "

        if [ $(($BAT)) -le 20 ] && [ "$BAT_STATUS" != "Charging" ]; then
          xsetroot -name "                                                  "
          sleep 1
	        xsetroot -name "$INFO"
          sleep 5
          xsetroot -name "󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 󰯈 󰚌 "
        else 
          # Update dwm status bar
	        xsetroot -name "$INFO"
        fi

        # Wait for 1 second before updating again
        #sleep 1
    done
}

dwm_status &
