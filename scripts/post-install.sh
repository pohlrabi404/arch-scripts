pacman -S sudo vim --noconfirm
useradd -m pohlrabi
passwd pohlrabi

cat <<EOF > /etc/sudoers
root ALL=(ALL:ALL) ALL

Defaults targetpw
ALL ALL=(ALL:ALL) ALL
EOF

# Security
sudo echo "auth optional pam_faildelay.so delay=4000000" >> /etc/pam.d/system-login
