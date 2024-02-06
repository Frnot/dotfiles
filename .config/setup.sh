#!/bin/bash

# Generate SSH key
SSH_KEY_FILEPATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$SSH_KEY_FILEPATH" ]; then
    ssh-keygen -t ed25519 -N "" -f "$SSH_KEY_FILEPATH"
fi

if ! gh auth status >/dev/null 2>&1; then
    echo -e "\nLogin to github with SSH: $SSH_KEY_FILEPATH.pub\n"
    gh auth login
fi

# Sync dotfiles
GIT_DOTFILES_DIR="$HOME/.dotfiles.git"
if  [ ! -d "$GIT_DOTFILES_DIR" ]; then
    echo "Downloading dotfiles"
    git clone --bare git@github.com:Frnot/dotfiles.git $GIT_DOTFILES_DIR
    # .bashrc isnt synced yet, so need to add an alias
    dotgit="/usr/bin/git --git-dir=$GIT_DOTFILES_DIR --work-tree=$HOME"
    $dotgit config status.showUntrackedFiles no # if the config is synced, this may be unecessary to run every time
    # force update whatever files may already exist with copies from the repo
    $dotgit checkout -f  # this may fail, is there a FORCE flag?
fi

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
    #TODO: consume all previous keypresses here
    read -sp "Enter password for frnot@$SAMBA_TARGET: " smbpasswd
    echo
    sudo tee /root/.smbcred >/dev/null <<EOL
username=frnot
password=$smbpasswd
EOL
    sudo chmod 600 /root/.smbcred
    if [ $(grep "/vault " /etc/fstab | wc -l) -eq 0 ]; then
        sudo mkdir /vault
        echo -e "\n//$SAMBA_TARGET  /vault  cifs  credentials=/root/.smbcred,x-systemd.automount,uid=1000,forceuid  0 0" | sudo tee -a /etc/fstab >/dev/null
    fi
    sudo systemctl daemon-reload
    sudo mount -av
fi

# configure syncthing
systemctl enable --now syncthing --user
