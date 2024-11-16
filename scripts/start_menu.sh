#!/bin/bash

# Check if X is not already running
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  echo "Select your window manager/desktop environment:"
  echo "1) dwm"
  echo "2) KDE X11 (Plasma)"
  echo "3) KDE Wayland (Plasma)"
  echo "4) Hyperland"
  read -p "Enter your choice (1/2/3/4): " choice

  case $choice in
    1)
      startx ~/.xinitrc dwm
      ;;
    2)
      startx ~/.xinitrc kde-x11
      ;;
    3)
      exec startplasma-wayland
      ;;
    4)
      xbindkeys &
      exec hyprland
      ;;
    *)
      echo "Invalid choice. Exiting..."
      ;;
  esac
fi

