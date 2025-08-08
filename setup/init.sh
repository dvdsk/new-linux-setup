#!/usr/bin/env bash

set -e
source deps.sh

install_basics_from_package_manager() {
	sudo apt install firefox fish curl htop btop wget git make g++ gcc python3 python3-pip sshfs entr imagemagick w3m neomutt urlscan gnupg2 pass wl-clipboard vlc audacity grim slurp swappy ffmpeg
}

install_rust_and_tools() {
	tools=(
		"zoxide"      # smart cd
		"exa"         # ls replacement
		"bat"         # cat replacement
		"skim"        # general fuzzy finder
		"ripgrep"     # use: rg
		"fd-find"     # find like, used: fd
		"du-dust"     # folder disk space, use: dust
		"git-delta"   # diff replacement with syntax highlighting
		"difftastic"  # diff replacement comparing on syntax
		"rmpc"        # mpd (music server) client
	)

	cargo=$(ensure_cargo)
	$cargo install "${tools[@]}"
}

add_flatpack() {
	sudo apt install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install com.discordapp.Discord com.github.wwmm.easyeffects org.darktable.Darktable com.github.vikdevelop.photopea_app
}

add_homeauto_stuff() {
	cargo=$(ensure_cargo)
	$cargo install --locked --git https://github.com/dvdsk/HomeAutomation ui
}

add_homeauto_stuff
add_flatpack
install_basics_from_package_manager
install_rust_and_tools

echo "now change your shell to fish using chsh (for safety reasones we can not script this)"
