sudo pacman -S sudo vim --noconfirm

# set up rebos
cp /etc/pacman.conf tmp
cat <<EOF > tmp
[oglo-arch-repo]
SigLeel = Optional DatabaseOptional
Server = https://gitlab.com/Oglo12/$repo/-/raw/main/$arch
EOF
sudo mv tmp /etc/pacman.conf
sudo pacman -Syy
sudo pacman -S rebos paru stow --noconfirm
