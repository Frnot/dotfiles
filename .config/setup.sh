#!/bin/bash

# Sync dotfiles
alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
git clone --bare https://github.com/Frnot/dotfiles $HOME/.dotfiles.git
dotgit config status.showUntrackedFiles no # if the config is synced, this may be unecessary to run every time
dotgit checkout  # this may fail, is there a FORCE flag?

# Setup samba share 
echo "Configuring samba share"
read -sp "Password for frnot@fileserver.lab.frnot.com: " smbpasswd
cat >/home/frnot/.smbcred <<EOL
username=frnot
password=$smbpasswd
EOL
echo "//fileserver.lab.frnot.com/vault  /vault  cifs  credentials=/root/.smbcred,x-systemd.automount,uid=1000,forceuid  0 0" >> /etc/fstab
systemctl daemon-reload
mount -av

# install yay
## TODO: make this non-interactive
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
