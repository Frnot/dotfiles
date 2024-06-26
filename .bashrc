#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias dotgit='/usr/bin/git --git-dir=/home/frnot/.dotfiles.git/ --work-tree=/home/frnot'


# Created by `pipx` on 2023-12-28 05:21:24
export PATH="$PATH:/home/frnot/.local/bin"

# Vivado
export PATH="$PATH:/tools/Xilinx/Vivado/2023.2/bin"


# Questa (modelsim)
export LM_LICENSE_FILE=/tools/intelFPGA_pro/LR-154835_License.dat
export PATH="$PATH:/tools/intelFPGA_pro/23.4/questa_fse/bin"
