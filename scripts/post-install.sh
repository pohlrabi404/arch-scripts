#!/bin/bash
set -e

# set up network
SSID=$(cat ssid)
PSK_FILE="$SSID.psk"
PASSWORD=$(grep 'Passphrase=' "$PSK_FILE" | cut -d= -f2) 
until nmcli -t -f STATE general | grep -q "connected"; do
	sleep 2
done
nmcli device wifi connect "$SSID" password "$PASSWORD"

sudo pacman -S vim --noconfirm

# set up rebos
cp /etc/pacman.conf tmp
cat <<EOF >> tmp
[oglo-arch-repo]
SigLeel = Optional DatabaseOptional
Server = https://gitlab.com/Oglo12/\$repo/-/raw/main/\$arch
EOF
sudo mv tmp /etc/pacman.conf
sudo pacman -Syy
sudo pacman -S rebos paru stow openssh --noconfirm

git clone https://github.com/pohlrabi404/arch-scripts ~/scripts
cd ~/scripts/dotfiles
stow -v -t ~ .
cd ~
rebos setup
rebos config init
rebos gen commit "init commit"
rebos gen current build
