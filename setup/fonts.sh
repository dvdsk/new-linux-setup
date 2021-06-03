#!/usr/bin/env bash

install_fonts() {
	FONTDIR=~/.local/share/fonts/
	mkdir -p $FONTDIR
	cp ../vim/font/*.ttf $FONTDIR
	fc-cache -f -v 
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
	set -e
	install_fonts
fi
