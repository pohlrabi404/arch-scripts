#!/bin/bash
set -e

echo "Installation starting..."
timedatectl
DISK="/dev/sda"
PART=""

umount -R /mnt 2>/dev/null || true
swapoff "${DISK}${PART}2" 2>/dev/null || true

# wipe partitions
wipefs --all --force "$DISK"

# partition the disk
parted --script "$DISK" mklabel gpt
parted --script "$DISK" mkpart ESP fat32 1MiB 1025MiB 
parted --script "$DISK" set 1 esp on
parted --script "$DISK" mkpart swap linux-swap 1025MiB 5121MiB 
parted --script "$DISK" mkpart root ext4 5121MiB 100%

# format
mkfs.fat -F 32 "${DISK}${PART}1"  # format efi as fat32
mkswap "${DISK}${PART}2"
swapon "${DISK}${PART}2"
mkfs.ext4 -F "${DISK}${PART}3"

# mount partitions
mount "${DISK}${PART}3" /mnt
mount --mkdir "${DISK}${PART}1" /mnt/boot

pacstrap -K /mnt base linux linux-firmware networkmanager amd-ucode sudo

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# save wifi info
cd /var/lib/iwd/
SSID=$(ls *.psk | head -n1 | sed 's/.psk//')
echo "$SSID" > /mnt/ssid
cp $SSID.psk /mnt/

# setup bootloader and other thing in chroot
curl -O https://raw.githubusercontent.com/pohlrabi404/arch-scripts/refs/heads/main/scripts/chroot.sh
cp ./chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh

umount -R /mnt
echo "Instalation complete."
rm install.sh

reboot
