#! /usr/bin/bash

Info () {
    printf "\x1B[1;7m[INFO]\x1B[0m\t$1\n"
}

Success () {
    printf "\x1B[1;32;7m [OK] \x1B[0m\t$1\n"
	sleep 1
}

Fail () {
    printf "\x1B[1;31;7m[FAIL]\x1B[0m\t$1\n"
	if [[ -z $2 ]]; then
		exit 1
	fi
}

Warning () {
    printf "\x1B[1;31m$1\x1B[0m\n"
}

Message () {
    printf "\x1B[1;35;7m$1\x1B[0m\n"
}


Status () {
	if [[ $? -eq 0 ]]; then
		Success "$1"
	else
		Fail "$2"
	fi
}


Info "Checking permissions ..."
if [[ $UID == 0 ]]; then
    Fail "Script must not be run as root"
fi
Success "Permissions are fine"


Info "Configuring pacman"
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 11\nILoveCandy/' /etc/pacman.conf


Info "Updating System"
sudo pacman -Syyu


Info "Installing Default Packages"
sudo pacman -S --noconfirm fish ranger neofetch vim neovim tmux vi git nasm base-devel bat exa lsd wget w3m nfs-utils rclone radare2 feh lolcat ttf-font-awesome fzf awesome-terminal-fonts sl parallel alsa-utils jq yt-dlp mesa cmatrix asciiquarium ncdu tree


Info "Installing GUI Packages"
sudo pacman -S --noconfirm kitty xorg xorg-xinit i3 polybar firefox rofi xfce4-terminal pcmanfm signal-desktop element-desktop telegram-desktop xfce4-screenshooter qbittorrent virtualbox pavucontrol lxappearance picom arandr lightdm lightdm-webkit2-greeter mpv kdenlive


Info "Arch User Repository"
cd /opt
sudo git clone https://aur.archlinux.org/yay-bin
sudo chown -R $USER:$USER yay-bin
cd yay-bin
makepkg -si
cd ~/


Info "Installing AUR Packages"
yay -S --noconfirm nordvpn-bin downgrade


Info "Installing System Configuration"
git clone https://github.com/psychoticpendulum/dotfiles
cd dotfiles
cp -Rfv * .* ~/.config
cd ~/
mv dotfiles .config
rm .bashrc .vimrc
ln -sF .config/bashrc .bashrc
ln -sF .config/vimrc .vimrc
tree
Success "Configuration files installed!"


Info "Creating /home Directory Layout"
mkdir dev file temp bin


Info "Installing Basic Scripts"
git clone https://github.com/psychoticpendulum/scripts
mv scripts dev/.scripts
tree
Success "Scripts installed!"


Info "Creating /mnt Directory Layout"
cd /mnt
sudo mkdir media volumes virtual temp nas share
sudo mkdir share/od share/bzod share/webdav share/gd
sudo chown -R $USER:$USER *
cd ~/
