#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Redirect stdout and stderr to a log file
exec &> ~/startx.log

# Keybinds (common to all WMs)
xbindkeys &

# Default session is kde-wayland if none is provided as an argument
session=${1:-'kde-x11'}

case $session in
  dwm)
    # Starting compositor
    picom -f &
    
    xrandr --output HDMI-1 --auto --primary
    xrandr --output eDP-1 --auto --left-of HDMI-1

    # Setting wallpaper
    ~/scripts/.fehbg_fixed &

    # Lockscreen
    ~/xssstate/xsidle.sh slock &
    xset s 600

    # Starting DWM status
    ~/dwm/scripts/status.sh &

    # Start DWM
    exec dwm
    ;;
  kde-x11)
    exec startplasma-x11
    ;;
  # No known session, try to run it as a command
  *)
    exec $1
    ;;
esac

