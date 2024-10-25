#! /usr/bin/bash

# ---------------------------------------------------------------------------------------------------------------------

STATUS="Beginning execution"
CLIENT=1

readonly AUTHOR="luks"
readonly VERSION="1.0.0"
readonly DATE="2024-10-21"

readonly SUPPORTED_DISTRIBUTIONS=("Arch Linux")
readonly CURRENT_DISTRIBUTION=$(cat /etc/os-release | grep -E "^NAME=" | cut -d'=' -f2 | tr -d '"')

# ---------------------------------------------------------------------------------------------------------------------

function statusbar () {
	printf "\x1b[s\x1b[0;0H\x1b[2K"
	printf "\x1b[1;4;5;36mpostinstall v$VERSION by $AUTHOR ($DATE)\x1b[0m\n"
	printf "\x1b[2K\x1b[1mStatus: \x1b[0;3m$STATUS"
	printf "\x1b[u\n"
}

function ask_continue () {
	msg="$1"
	if [[ -z $1 ]]; then
		msg="Do you want to continue"
	fi
	printf "$msg [Y/n] "
	read -r answer
	if [[ "$answer" =~ ^[Nn]$ ]]; then
        return 1
	fi
	return 0
}

function check_status () {
	if [[ $? -eq 0 ]]; then
		okay
	else
		warn
	fi
}

# ---------------------------------------------------------------------------------------------------------------------

function info () {
	STATUS=$1
	statusbar
	sleep 0.2
}

function okay () {
	local message="$1"
	if [[ -z "$message" ]]; then
		message="$STATUS"
	fi
	printf "\x1b[1;32;7m[OKAY]\x1b[0m  $STATUS"
}

function warn () {
	local message="$1"
	if [[ -z "$message" ]]; then
		message="$STATUS"
	fi
	printf "\x1b[1;33;7m[WARN]\x1b[0m  $STATUS"
	if ! ask_continue; then
		exit 2
	fi
}

function fail () {
	local message="$1"
	if [[ -z "$message" ]]; then
		message="$STATUS"
	fi
	printf "\x1b[1;31;7m[FAIL]\x1b[0m  $STATUS"
	exit 1
}

# ---------------------------------------------------------------------------------------------------------------------

clear
statusbar
if ! ask_continue "Do you want to install graphical applications?"; then
	CLIENT=0
fi


info "checking permissions"
if [[ "$UID" -eq 0 ]]; then
	fail "script must not be run as root"
fi
check_status


info "checking operating system"
if [[ ! " ${SUPPORTED_DISTRIBUTIONS[@]} " =~ " ${CURRENT_DISTRIBUTION} " ]]; then
	fail "operating system not supported"
fi
check_status


info "adjusting /etc/pacman.conf"
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 17\nILoveCandy/g' /etc/pacman.conf
check_status


info "setting up $HOME"
cd $HOME
mkdir -p dev/ldsoft 
mkdir tmp
touch tmp/.lock


info "setting up /mnt"
cd /mnt
sudo mkdir media nas share temp virt vol
cd share
sudo mkdir od bzod
sudo chown -R $USER:$USER /mnt/*
ln -sF /mnt $HOME/mnt
check_status


info "setting up arch user repository"
cd /opt
git clone https://aur.archlinux.org/yay-git
sudo chown -R $USER:$USER yay-git
cd yay-git
makepkg -si
check_status


info "updating system"
sudo pacman -Syyu
check_status

info "installing packages"
sudo pacman -S --noconfirm fish ranger neofetch vim neovim tmux vi git nasm base-devel bat exa lsd wget w3m nfs-utils rclone radare2 feh lolcat ttf-font-awesome fzf awesome-terminal-fonts sl parallel alsa-utils jq yt-dlp mesa cmatrix asciiquarium ncdu tree
if [[ "$CLIENT" -eq 1 ]]; then
	sudo pacman -S --noconfirm kitty xorg xorg-xinit i3 polybar firefox rofi xfce4-terminal pcmanfm signal-desktop element-desktop telegram-desktop xfce4-screenshooter qbittorrent virtualbox pavucontrol lxappearance picom arandr lightdm lightdm-webkit2-greeter mpv kdenlive tmux mesa llvm xf86-video-intel mosquitto exfat-utils cmatrix go net-tools cron vlock atril nodejs ttf-dejavu figlet
fi
check_status

info "installing arch user repository packages"
yay -S netextender sweet-gtk-theme sweet-cursor-theme sweet-cursor sweet-cursors-hyprcursor-git candy-icons kubectl python-telegram-bot python-mariadb-connector nordvpn-git nordvpn-bin cbonsai onefetch cava filebrowser-bi
check_status


info "setting up keys"
cd $HOME
git config --global user.name "$USER"
git config --global user.email "$USER@redacted.com"
git clone https://git.ldsoft.dev/luks/keys
cd keys
readonly KEY_LDSOFT=$(gpg --decrypt git.ldsoft.dev.gpg)
cd ..
mv keys .keys


info "setting up configs"
cd $HOME
git clone https://$KEY_LDSOFT@git.ldsoft.dev/luks/dotfiles
cd dotfiles
cp -Rfv * .* $HOME/.config/
cd ..

info "setting up vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c "PlugInstall" -c ":q!" -c ":q!"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim -c "PlugInstall" -c ":q!" -c ":q!"


info "setting up binaries"
git clone https://$KEY_LDSOFT@git.ldsoft.dev/luks/scripts
mv scripts $HOME/dev/ldsoft/
ln -sF $HOME/dev/ldsoft/scripts $HOME/bin
