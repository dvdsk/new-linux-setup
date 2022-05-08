#!/usr/bin/env bash

set -e
source deps.sh

install_basics_from_package_manager() {
	sudo apt install firefox zsh curl htop wget git make g++ gcc python3 python3-pip sshfs entr imagemagick w3m neomutt urlscan gnupg2 pass wl-clipboard
}

get_zsh_plugin_manager() {
	sh -c "$(curl -fsSL https://git.io/zinit-install)"
}

install_rust_and_tools() {
	tools=(
		"zoxide"     # smart cd
		"exa"         # ls replacement
		"bat"         # cat replacement
		"skim"        # general fuzzy finder
		"ripgrep"     # use: rg
		"fd-find"     # find like, used: fd
		"du-dust"     # folder disk space, use: dust
		"git-delta"   # diff replacement with syntax highlighting
		"difftastic"  # diff replacement comparing on syntax
	)

	cargo=$(ensure_cargo)
	$cargo install "${tools[@]}"
}

install_gnome_specific_tools() {
	sudo apt install gnome-tweaks gnome-shell-pomodoro
}

remove_snaps() {
	if command -v snap &> /dev/null
	then
		sudo snap remove firefox
	fi
}

add_flatpack() {
	sudo apt install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install com.discordapp.Discord com.github.wwmm.easyeffects org.telegram.desktop org.darktable.Darktable com.github.vikdevelop.photopea_app
}

remove_snaps
add_flatpack
install_basics_from_package_manager
install_rust_and_tools
install_gnome_specific_tools
get_zsh_plugin_manager
