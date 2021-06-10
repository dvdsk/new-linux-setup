#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\e[0;32m'
source deps.sh

# # rust
# rustup=$(ensure_rustup)
# $rustup "+nightly" component add rust-analyzer-preview
# exists rust-analyzer-preview || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"

# rust
if ! exists rust-analyzer || [ "$1" == "--update" ]; then
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
if ! exists pylsp || [ "$1" == "--update" ]; then
	pip=$(ensure_pip)
	$pip install --user --upgrade 'python-lsp-server[all]'
fi

# latex
if ! exists texlab || [ "$1" == "--update" ]; then
	cargo=$(ensure_cargo)
	$cargo install --git https://github.com/latex-lsp/texlab.git --locked
	exists texlab || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"
fi

# bash
if ! exists bash-language-server || [ "$1" == "--update" ]; then
	npm=$(ensure_npm)
	make -p ~/.local/bin
	$npm config set prefix '~/.local/'
	$npm install -g bash-language-server
	exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
fi

# lua
if ! exists lua-language-server || [ "$1" == "--update" ]; then
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
		compile/install.sh
		cd ../..
		./3rd/luamake/luamake rebuild
	)

	make -p ~/.local/bin
	mv /tmp/lua-language-server/bin/Linux/lua-language-server $HOME/.local/bin/
	rm /tmp/lua-language-server # cleanup

	exists lua-language-server || echo -e "${RED}please make sure $HOME/.local/bin in path"
fi

echo -e "${GREEN}done or already installed, use --update to update all lsp"
