#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# la
alias la='ls -a'


alias linkdisplay='xrandr --output HDMI-1 --mode 1920x1080  --right-of eDP-1'

# Default Browser
export BROWSER=/usr/bin/firefox
