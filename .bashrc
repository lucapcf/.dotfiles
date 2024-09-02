#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Unlimited shell history
export HISTFILESIZE=
export HISTSIZE=

# Recording time
HISTTIMEFORMAT="%d/%m/%y %T "

# Default Browser
export BROWSER=/usr/bin/firefox

# Enabling vi mode
set -o vi

# Function to get the current Git branch name
get_git_branch() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
      echo " ($(git branch --show-current 2>/dev/null))"
    fi
}

# PS1 prompt with Git branch (if inside a Git repository)
export PS1='[\[\033[1;34m\]\H\[\033[1;32m\]@\[\033[1;33m\]\u \[\033[1;31m\]\w\[\033[1;35m\]$(get_git_branch)\[\033[0m\]]\[\033[1;96m\] \$ \[\033[0m\]' 
#export PS1='[\[\033[1;34m\]\H\[\033[0m\]\[\033[1;32m\]@\[\033[1;32m\]\u\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] \[\033[1;31m\]$(get_git_branch)\[\033[0m\]] \$ ' 

# Adding different colors for distinc filetypes
export LS_COLORS='di=1;32:ln=1;36:ex=1;32:*.gz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.bmp=1;35:*.pdf=1;33:*.txt=1;33:*.md=1;33:*.c=1;32:*.h=1;32:*.cpp=1;32:*.java=1;32:*.py=1;32:*.sh=1;32:*.pl=1;32:*.rb=1;32:*.html=1;34:*.css=1;34:*.js=1;34:*.php=1;34'

# Set default editor
export EDITOR=nvim

# Enable command auto-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ALIASES

# Alias for ls to use color
alias ls='ls --color=auto'

# List all files
alias la='ls -a'

# vim => nvim
alias vim='nvim'

# Link display
alias linkdisplay='xrandr --output HDMI-1 --mode 1920x1080  --right-of eDP-1'

# Remove display
alias removedisplay='xrandr --output HDMI-1 --off'

# Alias for grep to use color
alias grep='grep --color=auto'
