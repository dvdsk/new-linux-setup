#!/usr/bin/env bash
set -e


RED='\033[0;31m'
GREEN='\e[0;32m'
source deps.sh

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

# C and friends
function install_C_lsp()
{
	if ! exists clangd; then
		sudo apt install clangd
	fi

	if ! exists bear; then
		sudo apt install bear # to generate compile_commands.json
	fi
}

read -n1 -p $'C/C++ lsp are installed from apt, needs sudo. install them? [y,n]\n' awnser 
case $awnser in  
  y|Y) install_C_lsp ;; 
  n|N) echo skipping ;; 
  *) echo skipping ;; 
esac

# lua, contains lsp binary and needed main.lua
lua_lsp="$HOME/.local/share/lua-language-server"
if [ ! -d $lua_lsp ] || [ "$1" == "--update" ]; then
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

# if ! exists lua-format || [ "$1" == "--update" ]; then
# 	go=$(ensure_go) # efm enables need to wrap luaformat
# 	$go get github.com/mattn/efm-langserver

# 	libs=$(ensure_local_lua)
# 	release=$(curl -L "https://luarocks.github.io/luarocks/releases/" \
# 		| grep -o "luarocks\-[[:digit:]\.]*\.tar\.gz" \
# 		| sort -r | head -n 1)
# 	base_url="https://luarocks.github.io/luarocks/releases/"
# 	curl -L "$base_url$release" | tar -xzvf - -C /tmp

# 	(
# 		cd /tmp/luarocks-*
# 		./configure --with-lua-bin="$HOME/.local/bin" --with-lua-include=$libs
# 		make
# 	)
# fi

echo -e "${GREEN}done or already installed, use --update to update all lsp"
