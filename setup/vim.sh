#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if ! command -v  xclip; then
	echo "trying to install xclip using apt, this needs sudo."\
	     "It is okay to skip this step with Ctrl+C however copying"\
	     "to/from sys clipboard might not work"
	sudo apt install xclip || true # can continue if fails
fi

# get latest nvim (update to non nightly once 0.5 hits stable)
NVIM="$HOME/.local/bin/nvim.appimage"
if [ ! -d $(dirname $NVIM) ]; then
        mkdir -p $(dirname $NVIM)
fi

rm $NVIM || true # if there is no existing install thats fine
RELEASE="https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage"
wget $RELEASE --output-document $NVIM
chmod +x $NVIM
ln -f $NVIM $(dirname $NVIM)/nvim

# move configs if none ar there
VIMDIR="$HOME/.config/nvim"
if [ ! -d "$VIMDIR" ]; then
	mkdir -p $VIMDIR
	cp ../vim/init.lua $VIMDIR
	cp -r ../vim/lua $VIMDIR/lua/
fi

# install plugins, treesitter
$NVIM --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
echo "neovim install done"
