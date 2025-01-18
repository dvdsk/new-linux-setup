#!/usr/bin/env bash

set -e
source deps.sh

install_basics_from_package_manager() {
	sudo apt install firefox zsh curl htop wget git make g++ gcc python3 python3-pip sshfs entr imagemagick w3m neomutt urlscan gnupg2 pass wl-clipboard vlc audacity
}

get_zsh_plugin_manager() {
	sh -c "$(curl -fsSL https://git.io/zinit-install)"
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
	)

	cargo=$(ensure_cargo)
	$cargo install "${tools[@]}"

	rustup toolchain add nightly
	$cargo +nightly install rbtw # reboot to windows
}

add_flatpack() {
	sudo apt install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install com.discordapp.Discord com.github.wwmm.easyeffects org.telegram.desktop org.darktable.Darktable com.github.vikdevelop.photopea_app
}

add_flatpack
install_basics_from_package_manager
install_rust_and_tools
get_zsh_plugin_manager

echo "now change your shell to zsh using chsh (for safety reasones we can not script this")
