#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

RED='\033[0;31m'
GREEN='\e[0;32m'
source deps.sh

arg=${1-"do_not_update"}

mkdir -p ~/.local/bin

# rust
if ! exists rust-analyzer || [ "$arg" == "--all" ] || [ "$arg" == "--rust" ]; then
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
if ! exists pylsp || [ "$arg" == "--all" ] || [ "$arg" == "--python" ]; then
	pip=$(ensure_pip)
	$pip install --user --upgrade 'python-lsp-server[all]'
	$pip install --user --upgrade 'pylsp-mypy'
fi

# latex
if ! exists texlab || [ "$arg" == "--all" ] || [ "$arg" == "--latex" ]; then
	cargo=$(ensure_cargo)
	$cargo install --git https://github.com/latex-lsp/texlab.git --locked
	exists texlab || echo -e "${RED}please make sure $HOME/.cargo/bin is in path"
fi

# json
if ! exists vscode-json-language-server || [ "$arg" == "--all" ] || [ "$arg" == "--json" ]; then
	npm=$(ensure_npm)
	mkdir -p ~/.local/bin
	$npm config set prefix '~/.local' # npm will syslink to ~/.local/bin
	$npm install -g vscode-langservers-extracted
	exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
fi

# bash
if ! exists bash-language-server || [ "$arg" == "--all" ] || [ "$arg" == "--bash" ]; then
	npm=$(ensure_npm)
	mkdir -p ~/.local/bin
	$npm config set prefix '~/.local' # npm will syslink to ~/.local/bin
	$npm install -g bash-language-server
	exists bash-language-server || echo -e "${RED}please make sure $($npm bin) is in path"
fi

# spell/grammer
if ! exists ltex-ls || [ "$arg" == "--all" ] || [ "$arg" == "--ltex" ]; then
	base_url="https://github.com/valentjn/ltex-ls/releases"
	url="$base_url/download/15.2.0/ltex-ls-15.2.0-linux-x64.tar.gz"
	tmp=`mktemp -d`/targ.gz
	wget -nc -O $tmp $url
	mkdir -p ~/.local/share/ltex
	tar -xf $tmp -C ~/.local/share/ltex
	ln -sf ~/.local/share/ltex/ltex-ls-15.2.0/bin/ltex-ls ~/.local/bin/ltex-ls
fi

# C and friends
if [ "$arg" == "--all" ] || [ "$arg" == "--c" ]; then
	if ! exists clangd && sudo_ok; then
		sudo apt install clangd
	fi
fi

# spell/grammer
if ! exists vale || [ "$arg" == "--all" ] || [ "$arg" == "--vale" ]; then
	latest_version=$(latest_github_release_version https://github.com/errata-ai/vale)
	fname="vale_${latest_version:1}_Linux_64-bit.tar.gz"
	url="https://github.com/errata-ai/vale/releases/download/$latest_version/$fname"
	curl --location $url | tar --gzip --extract --directory ~/.local/bin vale

	tmp=`mktemp -d`
	mkdir -p ~/.local/share/styles
	styles="Microsoft Google write-good proselint Joblint alex"
	for style in $styles; do
		release=$(latest_github_release_version https://github.com/errata-ai/$style)
		version=$(echo $release | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
		url="https://github.com/errata-ai/$style/releases/download/$version/$style.zip"
		curl --location --output "$tmp/$style.zip" $url 
		unzip -o -q "$tmp/$style.zip" -d ~/.local/share/styles
	done

	# yes vale has to pollute home, yes it is frustrating, no they wont change it :(
	echo "StylesPath = $HOME/.local/share/styles" > ~/.vale.ini
fi

# lua, contains lsp binary and needed main.lua
lua_lsp="$HOME/.local/share/lua-language-server"
if [ ! -d $lua_lsp ] || [ "$arg" == "--all" ] || [ "$arg" == "--lua" ]; then
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
		echo "*******************************"
		# do not touch user shell config
		SHELL="noshell" compile/install.sh
		echo "*******************************"
		
		cd ../..
		./3rd/luamake/luamake rebuild 1>/dev/null
	)

	mkdir -p ~/.local/bin
	rm -rf $HOME/.local/share/lua-language-server
	mv /tmp/lua-language-server $HOME/.local/share/
fi

echo -e "${GREEN}done or already installed, use --update to update all lsp"
