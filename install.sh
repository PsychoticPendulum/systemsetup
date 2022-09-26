#! /bin/bash

cd $HOME

sudo pacman -S cowsay

function feed () {
	cowsay -f tux $1
}

feed 'Installing base packages'
sudo pacman -S xorg xorg-xinit i3 adobe-source-code-pro-fonts vim fish ranger neofetch kitty git ttf-font-awesome htop bpytop cmatrix asciiquarium bat base-devel lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan openssh openvpn wget python-pip nasm w3m qbittorrent firefox awesome-terminal-fonts arandr sof-firmware rofi unzip pcmanfm lxappearance gimp code qbittorrent sdl2 sdl2_ttf ncdu veracrypt jdk11-openjdk libreoffice simplescreenrecorder speedtest-cli tmux youtube-dl sl figlet xfce4-screenshooter xfce4-appfinder lolcat feh exa lsd picom arc-gtk-theme net-tools


feed 'Installing Python Libraries'
pip3 install pygame
pip3 install requests
pip3 install numpy


feed 'Setting up configuration'
git clone https://github.com/psychoticpendulum/dotfiles
cp -Rfv dotfiles/.* dotfiles/* .config/
rm -Rfv dotfiles
rm .bashrc
ln .config/bashrc .bashrc
ln .config/vimrc .vimrc


feed 'Setting up home'
git clone https://github.com/psychoticpendulum/scripts
git clone https://github.com/psychoticpendulum/coreutils
git clone https://github.com/psychoticpendulum/unilog
mkdir Developer
mv scripts Developer/.scripts
mv coreutils Developer/CoreUtils
sudo cp Developer/CoreUtils/sep/sep /bin/sep
mv unilog Developer/unilog
sh Developer/unilog/install.sh
mkdir Wallpapers


feed 'Installing yay'
cd /opt
sudo git clone https://aur.archlinux.org/yay-bin
sudo chown $USER:$USER yay-bin
cd yay-bin
makepkg -si


feed 'Installing basic yay packages'
yay -S polybar sweet-cursor-theme-git sweet-folders-icons-git checkupdates+aur sweet-gtk-theme-dark onefetch


feed 'Handcrafting some configs'
sudo vim /etc/default/grub
sudo vim /etc/lightdm/lightdm.conf
sudo vim /etc/lightdm/lightdm-webkit2-greeter.conf
sudo systemctl enable lightdm


feed 'Creating mountpoints'
cd /mnt
mkdir NAS media virtual share
sudo chown $USER:$USER -R *
cd

feed 'Creating GTK Theme'
lxappearance
sudo lxappearance


feed 'Setting up VPN'
cd /etc/openvpn
sudo wget https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
sudo unzip ovpn.zip
sudo rm ovpn.zip


cd $HOME
python3 Develpoper/.scripts/clean.py


feed 'We are done' | lolcat
