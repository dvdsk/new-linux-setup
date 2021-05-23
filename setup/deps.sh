#!/usr/bin/env bash
set -e

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
		sudo apt update \
		&& sudo apt install nodejs
	fi
	echo nodejs
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
	echo yo#~/.cargo/bin/rustup
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
