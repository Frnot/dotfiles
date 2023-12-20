#!/bin/bash

# Setup samba share 
echo "Configuring samba share"
read -sp "Password for frnot@fileserver.lab.frnot.com: " smbpasswd
cat >/home/frnot/.smbcred <<EOL
username=frnot
password=$smbpasswd
EOL
echo "//fileserver.lab.frnot.com/vault  /vault  cifs  credentials=/home/frnot/.smbcred  0 0" >> /etc/fstab

# install yay
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
