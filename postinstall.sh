#! /usr/bin/bash


echo $1
KEY="$1@"
if [[ -z $1 ]]; then
	KEY=""
fi


Info () {
    printf "\x1B[1;7m[INFO]\x1B[0;1m\t$1\x1B[0m\n"
}

Success () {
    printf "\x1B[1;32;7m [OK] \x1B[0;1m\t$1\x1B[0m\n"
	sleep 1
}


Info "Checking permissions ..."
if [[ $UID == 0 ]]; then
    Fail "Script must not be run as root"
fi
Success "Permissions are fine"


Info "Pacman Configuration"
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 11\nILoveCandy/' /etc/pacman.conf
Success "Pacman Configuration"


Info "Updating System"
sudo pacman -Syyu


Info "Installing Default Packages"
sudo pacman -S --noconfirm fish ranger neofetch vim neovim tmux vi git nasm base-devel bat exa lsd wget w3m nfs-utils rclone radare2 feh lolcat ttf-font-awesome fzf awesome-terminal-fonts sl parallel alsa-utils jq yt-dlp mesa cmatrix asciiquarium ncdu tree


Info "Installing GUI Packages"
sudo pacman -S --noconfirm kitty xorg xorg-xinit i3 polybar firefox rofi xfce4-terminal pcmanfm signal-desktop element-desktop telegram-desktop xfce4-screenshooter qbittorrent virtualbox pavucontrol lxappearance picom arandr lightdm lightdm-webkit2-greeter mpv kdenlive tmux mesa llvm xf86-video-intel mosquitto exfat-utils cmatrix go net-tools cron vlock atril nodejs ttf-dejavu figlet


Info "Arch User Repository"
cd /opt
sudo git clone https://aur.archlinux.org/yay-bin
sudo chown -R $USER:$USER yay-bin
cd yay-bin
makepkg -si
cd ~/


Info "Installing AUR Packages"
yay -S --noconfirm nordvpn-bin downgrade
sudo downgrade fish

Info "Installing System Configuration"
git clone https://$(KEY)github.com/psychoticpendulum/dotfiles
cd dotfiles
cp -Rfv * .* ~/.config
cd ~/
cp -Rfv dotfiles .config
rm -Rfv dotfiles
rm .bashrc .vimrc
ln -sF .config/bashrc .bashrc
ln -sF .config/vimrc .vimrc
Success "Configuration files installed!"


Info "Creating /home Directory Layout"
mkdir dev file temp bin
tree


Info "Installing Vim Plugins"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall" -c ":q!" -c ":q!"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c "PlugInstall" -c ":q!" -c ":q!"


Info "Installing Basic Scripts"
git clone https://$(KEY)github.com/psychoticpendulum/scripts
cd scripts
cp -Rfv * .* ~/bin
cd ~/
cp -Rfv scripts bin
rm -Rfv scripts
Success "Scripts installed!"


Info "Creating /mnt Directory Layout"
cd /mnt
sudo mkdir media volumes virtual temp nas share
sudo mkdir share/od share/bzod share/webdav share/gd
sudo chown -R $USER:$USER *
tree /mnt
Success "Mountpoints set up!"
cd ~/
