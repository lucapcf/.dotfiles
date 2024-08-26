#!/bin/bash

# Function to get current time
dwm_status() {
    while true; do
        # Get the current time and format it as you wish
        TIME=$(date +"%D | %T")

	# Get the battery info
	BAT=$(cat /sys/class/power_supply/BAT0/capacity)
	BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)
	
	# Get the volume level
	VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' |     head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
	
	if [ "$VOLUME" -gt 150 ]; then
		pactl set-sink-volume 0 150%
	fi
	
        # Update dwm status bar
	xsetroot -name "Volume: $VOLUME | $BAT% and $BAT_STATUS | $TIME"

        # Wait for 1 second before updating again
        sleep 1
    done
}

dwm_status &
