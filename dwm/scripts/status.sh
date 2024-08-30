#!/bin/bash

# Function to get current time
dwm_status() {
    while true; do
        # Get the current time and format it as you wish
        TIME=$(date +"%a - %d/%m/%y | %T")

        # Get the battery info
	      BAT=$(cat /sys/class/power_supply/BAT0/capacity)
	      BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
	
	      # Get the volume level
	      VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' |     head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
	
	      # Limits max volume
	      if [ "$VOLUME" -gt 150 ]; then
		        pactl set-sink-volume 0 150%
	      fi

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
        USER=$(awk '/^cpu / {print $2}' /proc/stat)
        NICE=$(awk '/^cpu / {print $3}' /proc/stat)
        SYSTEM=$(awk '/^cpu / {print $4}' /proc/stat)
        IDLE=$(awk '/^cpu / {print $5}' /proc/stat)

        # Calculate total and usage time
        TOTAL_TIME=$(bc <<< "$USER + $NICE + $SYSTEM + $IDLE")
        CPU_USAGE=$(bc <<< "scale=2; ($USER + $SYSTEM) * 100 / $TOTAL_TIME")

	      # Ensure used RAM is displayed with two decimal places
        FORMATTED_CPU_USAGE=$(printf "%.2f" "$CPU_USAGE")

        # Update dwm status bar
	      xsetroot -name "   $CPU_USAGE% |   $FORMATTED_USED_GB"GB"/$TOTAL_GB"GB" |   $VOLUME |   $BAT% and $BAT_STATUS | $TIME"

        # Wait for 1 second before updating again
        sleep 1
    done
}

dwm_status &
