#!/usr/bin/env bash
set -e

# set alacritty as the default terminal
set_as_default() {
	gsettings set \
		org.gnome.desktop.default-applications.terminal \
		exec alacritty
	gsettings set \
		org.gnome.desktop.default-applications.terminal \
		exec-arg ''
}

# move config in place
cp ../alacritty.yml ~/.config/alacritty/

# try installing via ppa
# echo "trying to install using apt, this needs sudo."\
#      "It is okay to skip this step with Ctrl+C then "\
#      "this will install locally"

sudo add-apt-repository ppa:aslatter/ppa \
	&& sudo apt-get install alacritty \
	&& set_as_default \
	&& echo "installed alacritty" \
	&& exit 0 \
	|| true


# TODO wip no way to get around some apt dependencies for now
# if ! command -v cargo; then
# 	echo "need rustup/cargo installed, exiting"
# 	exit 0
# fi

# TEMP=/tmp/alacritty
# mkdir -p $TEMP
# git clone git@github.com:alacritty/alacritty.git

# cd $TEMP/alacritty
# cargo build --release
# mv target/release/alacritty ~/bin/alacritty

# cp extra/logo/alacritty-term.svg ~/.local/share/applications/
# cp extra/linux/Alacritty.desktop ~/.local/share/applications/
# #TODO setup terminfo without sudo?
