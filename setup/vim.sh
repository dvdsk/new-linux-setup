#!/usr/bin/env bash
set -e

if ! command -v  xclip; then
	echo "trying to install xclip using apt, this needs sudo."\
	     "It is okay to skip this step with Ctrl+C however copying"\
	     "to/from sys clipboard might not work"
	sudo apt install xclip || true # can continue if fails
fi

# get latest nvim (update to non nightly once 0.5 hits stable)
NVIM="$HOME/bin/nvim.appimage"
rm $NVIM || true # if there is no existing install thats fine
wget "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" \
	--output-document $NVIM
chmod +x $NVIM

# move configs
VIMDIR="$HOME/.config/nvim"
mkdir -p $VIMDIR
cp ../vim/init.lua $VIMDIR
cp -r ../vim/lua $VIMDIR/lua/

# setup plugin manager
PAQDIR="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
[[ -d $PAQDIR ]] \
|| git clone --depth 1 "https://github.com/savq/paq-nvim.git" $PAQDIR

# install plugins, treesitter
$NVIM "+PaqInstall" "+TSInstall python rust lua c cpp toml latex bibtex" "+q"
echo "neovim install done"
