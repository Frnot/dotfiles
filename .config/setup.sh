#!/bin/bash

# Generate SSH key
SSH_KEY_FILEPATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_FILEPATH" ]; then
    ssh-keygen -t ed25519 -N "" -f "$SSH_KEY_FILEPATH"
fi

# Sync dotfiles
alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
git clone --bare https://github.com/Frnot/dotfiles $HOME/.dotfiles.git
dotgit config status.showUntrackedFiles no # if the config is synced, this may be unecessary to run every time
dotgit checkout  # this may fail, is there a FORCE flag?

# Install yay
if ! command -v yay &>/dev/null; then
    echo "Installing yay"
    cd ~
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
    sudo rm -rf yay-bin
fi

# Setup samba share
SAMBA_TARGET="fileserver.lab.frnot.com/vault"
if [ $(df -h | grep "$SAMBA_TARGET" | wc -l) -eq 0 ]; then
    echo "Configuring samba share"
    read -sp "Enter password for frnot@$SAMBA_TARGET: " smbpasswd
    sudo tee /root/.smbcred >/dev/null <<EOL
username=frnot
password=$smbpasswd
EOL
    if [ $(grep "/vault " /etc/fstab | wc -l) -eq 0 ]; then
        echo "//$SAMBA_TARGET  /vault  cifs  credentials=/root/.smbcred,x-systemd.automount,uid=1000,forceuid  0 0" | sudo tee -a /etc/fstab >/dev/null
    fi
    sudo systemctl daemon-reload
    sudo mount -av
fi

# configure syncthing
systemctl enable --now syncthing --user
