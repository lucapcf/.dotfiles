#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Unlimited shell history
export HISTFILESIZE=
export HISTSIZE=

# Recording time
HISTTIMEFORMAT="%d/%m/%y %T "

# List all files
alias la='ls -a'

# Remove display
alias removedisplay='xrandr --output HDMI-1 --off'

# Link display
alias linkdisplay='xrandr --output HDMI-1 --mode 1920x1080  --right-of eDP-1'

# Default Browser
export BROWSER=/usr/bin/firefox

# vi mode
set -o vi

##-----------------------------------------------------
# synth-shell-prompt.sh
if [ -f /home/lucapcf/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/lucapcf/.config/synth-shell/synth-shell-prompt.sh
fi
