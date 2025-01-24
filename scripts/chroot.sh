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
echo "pohlrabi" > /etc/hostname

curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
./cachyos-repo.sh

rm -r cachyos-repo
rm cachyos-repo.tar.xz
pacman -Syu

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
