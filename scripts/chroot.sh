#!/bin/bash
set -e
DISK="/dev/sda"
PART=""

ln -sf /usr/share/zoneinfo/Japan /etc/localtime
hwclock --systohc

# localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8"

# network
echo "nowhere" > /etc/hostname

curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
./cachyos-repo.sh
cd ..

rm -r cachyos-repo
rm cachyos-repo.tar.xz
pacman -Syu --noconfirm

cat <<EOF > /etc/hosts
127.0.0.1               localhost
::1                     localhost ip6-localhost ip6-loopback
ff02::1                 ip6-allnodes
ff02::2                 ip6-allrouters
EOF

bootctl install
cat <<EOF > /boot/loader/loader.conf
default                 arch.conf
timeout                 2
console-mode            auto
editor                  no
EOF
ROOT_PART="${DISK}${PART}3"
ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
cat <<EOF > /boot/loader/entries/arch.conf
title                   Arch Linux
linux                   /vmlinuz-linux
initrd                  /amd-ucode.img
initrd                  /initramfs-linux.img
options                 root=UUID=${ROOT_UUID} rw
EOF

cat <<EOF > /boot/loader/entries/arch-fallback.conf
title                   Arch Liux (fallback)
linux                   /vmlinuz-linux
initrd                  /amd-ucode.img
initrd                  /initramfs-linux-fallback.img
options                 root=UUID=${ROOT_UUID} rw
EOF

# set password
systemctl enable NetworkManager
passwd

useradd -m pohlrabi
echo "Add password for pohlrabi"
passwd pohlrabi

cat <<EOF > /etc/sudoers
root ALL=(ALL:ALL) ALL

Defaults targetpw
ALL ALL=(ALL:ALL) ALL
EOF

# security 
sudo echo "auth optional pam_faildelay.so delay=4000000" >> /etc/pam.d/system-login

# download post install script
curl -O https://raw.githubusercontent.com/pohlrabi404/arch-scripts/refs/heads/main/scripts/post-install.sh
chmod +x post-install.sh
mv post-install.sh /home/pohlrabi/post-install.sh

rm chroot.sh
bootctl status
