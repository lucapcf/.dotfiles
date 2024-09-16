#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Keybinds
xbindkeys &

# Starting compositor
exec picom -f &

# Setting wallpaper
~/.fehbg_fixed &

# Lockscreen
~/xssstate/xsidle.sh slock &

# Starting DWM status
~/dwm/scripts/status.sh &

# Starting DWM
exec dwm

# Window managers and Desktop Environments options
#exec startplasma-x11
#exec i3
