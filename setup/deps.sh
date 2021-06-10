#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\e[0;32m'

exists() {
	command -v $1 &> /dev/null
	return $?
}

ensure_pip() {
	if exists pip3; then
		echo pip3
		return
	fi

	if exists pip && [ $(pip --version) == *"python 3."* ]; then
		echo pip
		return
	fi 

	exit 1 # could find a python 3 pip
}

ensure_npm() {
	if ! exists npm; then
		sudo apt-get update \
		&& sudo apt-get install --yes nodejs npm
	fi
	echo npm
}

ensure_rustup() {
	if exists rustup; then
		echo rustup
		return
	fi

	if exists ~/.cargo/bin/rustup; then
		echo ~/.cargo/bin/rustup
		return
	fi

	# rustup must not be intalled, install rust lang
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	echo ~/.cargo/bin/rustup
}

ensure_cargo() {
	if exists cargo; then
		echo cargo
		return
	fi

	if exists ~/.cargo/bin/cargo; then
		echo ~/.cargo/bin/cargo
		return
	fi

	# cargo must not be intalled, install rust lang
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	echo ~/.cargo/bin/cargo
}

ensure_ninja() {
	if exists ninja; then
		echo ninja
		return
	fi

	if exists $HOME/.local/bin/ninja; then
		echo ~/.local/bin/ninja
		return
	fi

	release="ninja-linux.zip"
	base_url="https://github.com/ninja-build/ninja/releases/latest/download/"
	local_path="$HOME/.local/bin/ninja"
	curl -L "$base_url$release" | gunzip -c - > $local_path
	chmod +x $local_path
	echo ~/.local/bin/ninja
}

check() {
	if exists $1; then
		return
	fi

	>&2 echo -e "${RED}needs $1 installed/in path, it is not"
	exit 1
}
