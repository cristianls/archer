#!/bin/bash

# Helper functions 
#
# function for asking user something
function prompt() {
	echo -e "\n"
	read -p "$1 [y/n] " -n 1 -r
}

# checks if said packages are installed and installs them if they are missing
# be careful to check that packages exist as checking is not implemented
function installifmissing() {
	if [ ! $(pacman -Qi $* | grep error | wc -l) -gt 0 ]
	then
		echo -e "\n\n> Installing packages: $*\n\n"
		sudo pacman -S $*
	else
		echo -e "\n\n> Dependencies ok!\n\n"
	fi
}

# TODO add a function for specifying a custom destination folder

# defining global variables
THISDIR=$PWD
ESSENTIALS=$(cat essentials | tr "\n" " ")
AURPROGRAMS=$(cat aur | tr '\n' ' ')

# install packages provided in essential file
prompt "Install essential pacman packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo pacman -Syu
	sudo pacman -S $ESSENTIALS 
fi

cd $THISDIR

prompt "Install my patched version of suckless programs (dwm, st, dmenu)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	# install git and make if not installed already
	installifmissing git libx11 make

	# install dwm
	cd /opt
	sudo git clone https://github.com/AnejL/dwm
	cd dwm
	sudo make clean install

	# install st
	cd /opt
	sudo git clone https://github.com/AnejL/st
	cd st
	sudo make clean install
	
	# install dmenu
	cd /opt
	sudo git clone https://github.com/AnejL/dmenu
	cd dmenu
	sudo make clean install
fi

cd $THISDIR

#install configs and dotfiles
prompt "Install xorg configs for trackpad, intel graphics and keyboard? (recommended only if you use a ThinkPad)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "\n\n> Copying xorg configs"
	sudo cp "configs/xorg/"* /etc/X11/xorg.conf.d/
fi

#install configs and dotfiles
prompt "Download my dotfiles to $HOME?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git
	# TODO what files are in conflict here? WC - use fetch --all + reset method
	cd $HOME
	rm .bashrc .bash_profile .bash_history .bash_logout
	git init
	git remote add origin https://github.com/AnejL/dotfiles.git
	git pull origin master

	cd $HOME/.local/sysprog/dbc
	git init
	git remote add origin https://github.com/AnejL/dbc.git
	git pull origin master

	prompt "Select this computer's unique profile name:"

	echo "$REPLY" > $HOME/.config/profile
fi

# organize home folder and scripts and college files
prompt "Organize home folder (includes my Scripts and academic files which are private)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git
	cd $HOME
	mkdir Documents Pictures Downloads Devel Music Videos Backup # .fonts .themes .icons

	# college files
	prompt "Download my college files?"

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		cd $HOME/Documents
		mkdir Faks
		cd Faks
		git init
		git remote add origin https://github.com/AnejL/Faks
		git pull origin master
	fi
fi


prompt "Install yay and AUR packages?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing git make
	
	# manually install yay aur helper
	cd /opt
	sudo git clone https://aur.archlinux.org/yay.git
	sudo chown -R $USER yay 
	cd yay
	makepkg -si

	# install the array of aur programs
	yay -S $AURPROGRAMS
fi


prompt "Make pulseaudio bearable (convert to dumb and unintrusive pipe to alsa)?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	installifmissing pulseaudio

	cd $THISDIR
	echo -e "\n\n> Overwriting pulseaudio configs"
	sudo cp "configs/pulse/"* /etc/pulse/
fi

# systemd service for lidlock
prompt "Install systemd service for betterlockscreen and suspend on lid close?"

if [[ $REPLY =~ ^[Yy]$ ]]
then
	sudo cp configs/systemd/logind.conf /etc/systemd/logind.conf
	sudo cp configs/systemd/betterlockscreen.service "/etc/systemd/system/sleep.target.wants/betterlockscreen@$USER.service"
	sudo systemctl enable betterlockscreen@$USER.service
	echo -e "betterlockscreen -u /path/to/image"
fi

cd 

# start cups printer service
# sudo systemctl enable org.cups.cupsd.service
# sudo systemctl start org.cups.cupsd.service

echo -e "\nInstallation finished! Remove archer folder with rm -rf archer \n after that start xorg with startx"

exit 0
