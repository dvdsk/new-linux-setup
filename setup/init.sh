#!/usr/bin/env bash

set -e
source deps.sh

install_basics_from_package_manager() {
	sudo apt install zsh curl htop wget git make g++ gcc python3 python3-pip sshfs entr imagemagick
}

get_zsh_plugin_manager() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
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
	sudo apt install gnome-tweak-tool gnome-shell-pomodoro
}

install_basics_from_package_manager
get_zsh_plugin_manager
install_rust_and_tools
install_gnome_specific_tools
