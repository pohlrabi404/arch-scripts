pacman -S sudo --noconfirm
useradd -m pohlrabi
passwd pohlrabi

cat <<EOF > /etc/sudoers
root ALL=(ALL:ALL) ALL

Defaults targetpw
ALL ALL=(ALL:ALL) ALL
EOF
