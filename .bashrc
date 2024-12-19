#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Running start menu
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  ~/scripts/start_menu.sh
fi

# Unlimited shell history
export HISTFILESIZE=
export HISTSIZE=

# Media
export VIDEO_PLAYER=vlc

# Terminal emulator
export TERMINAL=alacritty

export IMAGE_VIEWER=feh

# Recording time
HISTTIMEFORMAT="%d/%m/%y %T "

# Appends every executed command to shell history (fix for multiple simultaneous terminals)
export PROMPT_COMMAND='history -a'

# Default Browser
export BROWSER=/usr/bin/firefox

# Enabling vi mode
set -o vi

bind -m vi-command 'Control-l: clear-screen'

bind -m vi-insert 'Control-l: clear-screen'

# Function to get the current Git branch name
get_git_branch() {
    branch=" ($(git branch --show-current 2>/dev/null))"
    if [ "$?" == 0 ]; then
        echo "$branch"
    fi
}

# PS1 prompt with Git branch (if inside a Git repository)
export PS1='[\[\033[1;34m\]\H\[\033[1;32m\]@\[\033[1;33m\]\u \[\033[1;31m\]\w\[\033[1;35m\]$(get_git_branch)\[\033[0m\]]\[\033[1;96m\] \$ \[\033[0m\]' 
#export PS1='[\[\033[1;34m\]\H\[\033[0m\]\[\033[1;32m\]@\[\033[1;32m\]\u\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] \[\033[1;31m\]$(get_git_branch)\[\033[0m\]] \$ ' 

# Adding different colors for distinc filetypes
export LS_COLORS="\
di=1;34:\
ln=1;36:\
ex=1;32:\
*.gz=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.bmp=1;35:*.pdf=1;33:*.txt=1;33:*.md=1;33:*.c=1;32:*.h=1;32:*.cpp=1;32:*.java=1;32:*.py=1;32:*.sh=1;32:*.pl=1;32:*.rb=1;32:*.html=1;31:*.css=1;34:*.js=1;33:*.php=1;34"

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
alias linkdisplay='~/scripts/linkdisplay'

# Remove display
alias removedisplay='~/scripts/removedisplay'

# Setup bluetooth
alias blue='~/scripts/blue'

# Alias for grep to use color
alias grep='grep --color=auto'

# Git bare
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

