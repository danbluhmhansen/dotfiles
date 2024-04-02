#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GPG_TTY=$(tty)

eval "$(direnv hook bash)"
