#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias trashcan='bash /home/ta/.config/scripts/trashcan.sh'

PS1='[\u@\h \W]\$ '

# Extra PATHs
export PATH=$PATH:~/.config/scripts
export GOPATH=$HOME/.go
