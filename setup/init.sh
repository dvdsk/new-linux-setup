#!/usr/bin/env bash

set -e
source deps.sh

install_basics_from_package_manager() {
	sudo apt install firefox zsh curl htop wget git make g++ gcc python3 python3-pip sshfs entr imagemagick w3m neomutt gnupg2 pass wl-clipboard
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
	)

	cargo=$(ensure_cargo)
	$cargo install "${tools[@]}"
}

install_gnome_specific_tools() {
	sudo apt install gnome-tweaks gnome-shell-pomodoro
}

remove_snaps() {
	sudo snap remove firefox

}

remove_snaps
install_basics_from_package_manager
get_zsh_plugin_manager
install_rust_and_tools
install_gnome_specific_tools
