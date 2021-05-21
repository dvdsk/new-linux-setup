#!/usr/bin/env bash
set -e

# get latest nvim (update to non nightly once 0.5 hits stable)
NVIM="$HOME/bin/nvim.appimage"
rm $NVIM
wget "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" \
	--output-document $NVIM
chmod +x $NVIM

# move configs
VIMDIR="$HOME/.config/nvim"
mkdir -p $VIMDIR
cp init.lua $VIMDIR
cp -r lua $VIMDIR/lua/

# setup plugin manager
PAQDIR="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
[[ -d $PAQDIR ]] \
|| git clone --depth 1 "https://github.com/savq/paq-nvim.git" $PAQDIR

# install plugins, treesitter
$NVIM "+PaqInstall" "+TSInstall python rust lua c cpp" "+q"
echo "neovim install done"
