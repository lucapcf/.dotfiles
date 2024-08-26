#!/bin/bash -v

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
	

	# Extract memory data
 #       TOTAL_KB=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
#        FREE_KB=$(awk '/MemFree:/ {print $2}' /proc/meminfo)
  #      BUFFERS_KB=$(awk '/Buffers:/ {print $2}' /proc/meminfo)
   #     CACHED_KB=$(awk '/Cached:/ {print $2}' /proc/meminfo)

 #       echo $TOTAL_KB
#        echo $FREE_KB
  #      echo $BUFFERS_KB
   #     echo $CACHED_K
        # Calculate total and used RAM in GB
    #    TOTAL_GB=$(echo "scale=2; $TOTAL_KB / 1024 / 1024" | bc)
        #USED_GB=$(echo "scale=2; ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024" | bc)

	#USED_GB=$(bc <<< "scale=2; ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024")

#	TOTAL_GB=$(awk "BEGIN {print $TOTAL_KB / 1024 / 1024}")
#	USED_GB=$(awk "BEGIN {print ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 / 1024}")

#	TOTAL_MB=$(($TOTAL_KB / 1024))
#	USED_MB=$(echo "(( ($TOTAL_KB - $FREE_KB - $BUFFERS_KB - $CACHED_KB) / 1024 ))")




        # Update dwm status bar
	#xsetroot -name "Total RAM: $TOTAL_GB GB | Used RAM: $USED_GB GB | Volume: $VOLUME | $BAT% and $BAT_STATUS | $TIME"
	xsetroot -name "Volume: $VOLUME | $BAT% and $BAT_STATUS | $TIME"

        # Wait for 1 second before updating again
        sleep 1
    done
}

dwm_status &
