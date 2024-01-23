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
source /tools/Xilinx/Vivado/2023.2/settings64.sh

# Questa (modelsim)
export LM_LICENSE_FILE=/tools/intelFPGA/LR-154835_License.dat
export PATH="$PATH:/tools/intelFPGA/23.1std/questa_fse/bin/"
