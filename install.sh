#! /bin/bash

cd $HOME

# Installing basic packages
sudo pacman -S xorg xorg-xinit i3 adobe-source-code-pro-fonts vim fish ranger neofetch kitty git ttf-font-awesome htop bpytop cmatrix asciiquarium bat base-devel lightdm lightdm-webkit2-greeter lightdm-webkit-theme-litarvan openssh openvpn wget python-pip nasm w3m qbittorrent firefox awesome-terminal-fonts arandr sof-firmware rofi unzip pcmanfm lxappearance gimp code qbittorrent sdl2 sdl2_ttf ncdu veracrypt jdk11-openjdk libreoffice simplescreenrecorder speedtest-cli tmux youtube-dl sl figet cowsay xfce4-screenshooter xfce4-appfinder

# Installing python libraries
pip3 install pygame
pip3 install requests
pip3 install numpy

# Setting up configuration
git clone https://github.com/psychoticpendulum/dotfiles
cp -Rfv dotfiles/.* dotfiles/* .config/
rm -Rfv dotfiles
rm .bashrc
ln .config/bashrc .bashrc
ln .config/vimrc .vimrc

# Setting up home
git clone https://github.com/psychoticpendulum/scripts
git clone https://github.com/psychoticpendulum/coreutils
git clone https://github.com/psychoticpendulum/unilog
mkdir Developer
mv scripts Developer/.scripts
mv coreutils Developer/CoreUtils
mv unilog Developer/unilog
Developer/unilog/install.sh
mkdir Wallpapers

# Installing yay
cd /opt
sudo git clone https://aur.archlinux.org/yay-bin
sudo chown $USER:$USER yay-bin
cd yay-bin
makepkg -si

# Installing basic yay packages
yay -S polybar sweet-folder-icons-git sweet-cursor-theme-git sweet-folder-icons-git

# Handcrafting some configs
sudo vim /etc/default/grub
sudo vim /etc/lightdm/lightdm.conf
sudo vim /etc/lightdm/lightdm-webkit2-greeter.conf
sudo systemctl enable lightdm

# Setting up VPN
cd /etc/openvpn
sudo wget https://downloads.nordcdn.com/configs/archives/servers/openvpn.zip
sudo unzip ovpn.zip
sudo rm ovpn.zip

cd $HOME
Develpoper/.scripts/clean.py
