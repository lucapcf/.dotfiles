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

# List all files
alias la='ls -a'


# vim => nvim
alias vim='nvim'

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
#if [ -f /home/lucapcf/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
#	source /home/lucapcf/.config/synth-shell/synth-shell-prompt.sh
#fi



# NEW STUFF
# If the command is interactive (e.g., a terminal session), set the prompt
#if [ -n "$PS1" ]; then
    # Set the prompt string (PS1)
  #  export PS1='\u@\h:\w\$ '

# Function to get the current Git branch name
get_git_branch() {
    # Check if the current directory is inside a Git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Retrieve the branch name
        git branch --show-current 2>/dev/null
    fi
}

# PS1 prompt with Git branch (if inside a Git repository)
PS1='[\[\033[1;34m\]\H\[\033[0m\]@\[\033[1;32m\]\u\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] \[\033[1;31m\]$(get_git_branch)\[\033[0m\]] \$ ' 

export LS_COLORS='di=1;32:ln=1;36:ex=1;32:*.gz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.bmp=1;35:*.pdf=1;33:*.txt=1;33:*.md=1;33:*.c=1;32:*.h=1;32:*.cpp=1;32:*.java=1;32:*.py=1;32:*.sh=1;32:*.pl=1;32:*.rb=1;32:*.html=1;34:*.css=1;34:*.js=1;34:*.php=1;34'

# Set default editor
export EDITOR=nvim

# Enable command auto-completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Format: TYPE=COLOR_CODE
# Alias for ls to use color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
