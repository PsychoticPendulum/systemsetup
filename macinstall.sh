#!/bin/bash

Info () {
    printf "\x1B[1;7m[INFO]\x1B[0m\t$1\n"
}

Success () {
    printf "\x1B[1;32;7m [OK] \x1B[0m\t$1\n"
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

Info "Checking Permissions ..."
if [[ $UID == 0 ]]; then
	Fail "Script should not be be run as root"
fi
Success "Permissions are ok!"

local_user=""
while true; do
	Info "Searching profiles ..."
	ls /Users/ | cat -b
	printf "Enter number of \x1B[1;4mlocal\x1B[0m profile: "
	read answer
	if [[ ! -z $answer ]]; then
		local_user=$(ls /Users | cat | head -n $answer | tail -n 1)
		printf "Old Profile: \x1B[36m$local_user\x1B[0m\nIs that right? [y/N] "
		read answer
		if [[ $answer == 'Y' ]] || [[ $answer == 'y' ]]; then
			Info "Selected User: \x1B[1;4m$local_user\x1B[0m"
			break
		fi
	fi
done

Info "Getting system information ..."
distro=$(lsb_release -d | awk '{print $2}')
Info "Detected distro: \x1B[1;4m$distro\x1B[0m"
ls /usr/bin/ | grep "apt"  > /dev/null
Status "Your OS is supported" "Your OS is not supported"

echo -n "Do you want to update the Operating System? [y/N] "
read answer
if [[ $answer = 'Y' ]] || [[ $answer = 'y' ]]; then
	Info "Updating Operating System ..."
	brew update
	brew upgrade
	Status "Updates installed successfully" "Unable to install updates"
fi

Info "Installing packages ..."
brew install tmux kitty htop fish vim curl ranger htop
Status "Packages installed" "Unable to install packages"

Info "Configuring system ..."
mkdir -p /Users/$local_user/.config/i3
curl -s https://raw.githubusercontent.com/PsychoticPendulum/dotfiles/main/i3/config_default > /Users/$local_user/.config/i3/config
Status "i3 config" "i3 config"
mkdir -p /Users/$local_user/.config/kitty
curl -s https://raw.githubusercontent.com/PsychoticPendulum/dotfiles/main/kitty/config > /Users/$local_user/.config/kitty/config
Status "kitty config" "kitty config"
curl -s https://raw.githubusercontent.com/PsychoticPendulum/dotfiles/main/vimrc > /Users/$local_user/.vimrc
Status "vimrc" "vimrc"
curl -s https://raw.githubusercontent.com/PsychoticPendulum/dotfiles/main/bashrc > /Users/$local_user/.bashrc
Status "bashrc" "bashrc"
Status "Configuration successful" "Unable to set up configuration"

Info "Downloading basic scripts ..."
git clone https://github.com/psychoticpendulum/scripts
mv -fv scripts/*.* /Users/$local_user/.scripts/
chown -R $local_user:$local_user /Users/$local_user/.scripts/*
rm -Rf scripts
Status "Scripts downloaded!" "Unable to download scripts"
