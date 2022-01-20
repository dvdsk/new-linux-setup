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
		&& sudo apt-get install --yes nodejs npm 1> /dev/null
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
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 1> /dev/null
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
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 1> /dev/null
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

ensure_go() {
	if exists go; then
		echo go
		return
	fi

	if exists $HOME/.local/bin/go; then
		echo ~/.local/bin/go
		return
	fi

	version="$(curl -s https://golang.org/VERSION?m=text)"
	release=".linux-amd64.tar.gz"
	base_url="https://golang.org/dl/"
	local_path="$HOME/.local/share"
	curl -L "$base_url$version$release" | tar -xzvf - -C $local_path

	for path in $local_path/go/bin/*; do
		chmod +x $path
		ln -s $path $HOME/.local/bin/$(basename $path)
	done

	echo ~/.local/bin/go
}

ensure_local_lua() {
	lua=~/.local/bin/lua
	libs=~/.local/lib/lua/include
	if exists $lua && [ -d $libs ]; then
		echo "$libs"
		return
	fi

	sudo apt-get install --yes build-essential libreadline-dev
	release=$(curl -L https://www.lua.org/ftp/ \
		| grep -o "lua\-[[:digit:]\.]*\.tar\.gz" \
		| sort -r | head -n 1)
	base_url="https://www.lua.org/ftp/"
	local_path="/tmp/${release%.tar.gz}"
	curl -L "$base_url$release" | tar -xzvf - -C /tmp
	(
		cd $local_path
		make local
		mkdir -p $libs
		mv $local_path/install/bin/* ~/.local/bin/
		mv $local_path/install/include/* $libs
	)
	echo "$libs"
}

check() {
	if exists $1; then
		return
	fi

	>&2 echo -e "${RED}needs $1 installed/in path, it is not"
	exit 1
}
