**What is it?**

It's an interactive utility installer for Arch + pacman based systems. It installs my personal barebones system utilities, formats home folder, downloads my shell scripts, configs and my fork of suckless dwm and st.
**BEWARE! THIS VERSION HAS NOT BEEN TESTED (will be in a couple of days)**


**How to run it?**



Firstly, install necessary programs with 

> sudo pacman -S git base-devel

afterwards clone this git repo with

> git clone https://github.com/anejl/archer
> cd archer

> ./installer.sh

**How to change it?**

However you like... It's free software so use it as you please!

Script structure easily allows adding your own modules and modifying existing ones.

**What do all these files do?**

*installer.sh* - main script that makes all the changes to the system

*aur* - list of AUR programs

*essentials* - list of essential official arch packages for creating a small and functional system

*configs* - directory for all the config files that are copied or compiled in the installation process 


Made by Anej Lekše
