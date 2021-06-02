#!/usr/bin/env bash
set -e

RED='\033[0;31m'
source deps.sh

# # rust
# rustup=$(ensure_rustup)
# $rustup "+nightly" component add rust-analyzer-preview
# exists rust-analyzer-preview || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"

# rust
if ! exists rust-analyzer; then
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
if ! exists pylsp; then
	pip=$(ensure_pip)
	$pip install --user --upgrade 'python-lsp-server[all]'
fi

# latex
if ! exists texlab; then
	cargo=$(ensure_cargo)
	$cargo install --git https://github.com/latex-lsp/texlab.git --locked
	exists texlab || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"
fi

# bash
if ! exists bash-language-server; then
	npm=$(ensure_npm)
	make -p ~/.local/bin
	$npm config set prefix '~/.local/'
	$npm install -g bash-language-server
	exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
fi
