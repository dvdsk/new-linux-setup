#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

RED='\033[0;31m'
GREEN='\e[0;32m'
source deps.sh

arg=${1-"do_not_update"}

# rust
if ! exists rust-analyzer || [ "$arg" == "--update" ]; then
	rustup=$(ensure_rustup)
	$rustup component add rust-src
	release="rust-analyzer-x86_64-unknown-linux-gnu.gz"
	base_url="https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/"
	local_path="$HOME/.local/bin/rust-analyzer"
	curl -L "$base_url$release" | gunzip -c - > $local_path
	chmod +x $local_path
	exists rust-analyzer || echo -e "${RED}please make sure $HOME/.local/bin is in path"
fi

# python
if ! exists pylsp || [ "$arg" == "--update" ]; then
	pip=$(ensure_pip)
	$pip install --user --upgrade 'python-lsp-server[all]'
fi

# latex
if ! exists texlab || [ "$arg" == "--update" ]; then
	cargo=$(ensure_cargo)
	$cargo install --git https://github.com/latex-lsp/texlab.git --locked
	exists texlab || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"
fi

# bash
if ! exists bash-language-server || [ "$arg" == "--update" ]; then
	npm=$(ensure_npm)
	mkdir -p ~/.local/bin
	$npm config set prefix '~/.local' # npm will syslink to ~/.local/bin
	$npm install -g bash-language-server
	exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
fi

# C and friends
function install_C_lsp()
{
	if ! exists clangd && sudo_ok; then
		sudo apt install clangd
	fi

	if ! exists bear && sudo_ok; then
		sudo apt install bear # to generate compile_commands.json
	fi
}

# lua, contains lsp binary and needed main.lua
lua_lsp="$HOME/.local/share/lua-language-server"
if [ ! -d $lua_lsp ] || [ "$arg" == "--update" ]; then
	check git
	check g++
	ninja=$(ensure_ninja)

	(
		export PATH="$ninja:$PATH"
		cd /tmp
		rm -rf lua-language-server
		git clone "https://github.com/sumneko/lua-language-server"
		cd lua-language-server
		git submodule update --init --recursive

		cd 3rd/luamake
		compile/install.sh >/dev/null
		cd ../..
		./3rd/luamake/luamake rebuild >/dev/null
	)

	mkdir -p ~/.local/bin
	rm -rf $HOME/.local/share/lua-language-server
	mv /tmp/lua-language-server $HOME/.local/share/
fi

# install general purpose lang server on which we can
# add the autoformatter
if ! exists efm-langserver; then 
	go=$(ensure_go) # efm enables need to wrap luaformat
	$go get github.com/mattn/efm-langserver
fi

# install lua formatter
if ! exists stylua; then
	cargo=$(ensure_cargo)
	$cargo install stylua
fi

echo -e "${GREEN}done or already installed, use --update to update all lsp"
