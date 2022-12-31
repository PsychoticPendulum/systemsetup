#! /usr/bin/bash

Header () {
	printf "\x1B[32m$1\x1B[0m\n"
}

Header "Checking permissions ..."
if [[ "$(whoami)" == "root" ]]; then
	printf "\x1B[31mScript must not be run as root\x1B[0m\n"
	exit 1
fi

Header "Updating system ..."
sudo apt update
sudo apt upgrade
sudo apt autoremove

Header "Installing packages ..."
sudo apt install exa tmux htop ranger neofetch vim net-tools build-essential fish htop cmatrix bat wget git curl ncdu cron sl

Header "Installing configurations ..."
git clone https://github.com/psychoticpendulum/dotfiles
cd dotfiles
cp -Rfv * .* ~/.config
mv vimrc ~/.vimrc
mv bashrc ~/.bashrc
cd ..
rm -Rfv dotfiles
git clone https://github.com/psychoticpendulum/scripts
mkdir ~/Developer
cp -Rfv scripts ~/Developer/.scripts
rm -Rfv scripts

Header "Cleaning up ..."
cd ~/
rmdir *

source ~/.bashrc
Header "Done!"
