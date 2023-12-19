#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias dotgit='/usr/bin/git --git-dir=/home/frnot/.dotfiles.git/ --work-tree=/home/frnot'
