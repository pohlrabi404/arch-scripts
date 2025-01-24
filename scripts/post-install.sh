sudo pacman -S sudo vim --noconfirm
cp /etc/pacman.conf tmp
cat <<EOF > tmp
[oglo-arch-repo]
SigLeel = Optional DatabaseOptional
Server = https://gitlab.com/Oglo12/$repo/-/raw/main/$arch
EOF
sudo mv tmp /etc/pacman.conf
