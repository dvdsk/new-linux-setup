#!/usr/bin/env bash
#
# Install language servers not installed through mason.nvim 
# (see .config/nvim/lua/lsp.lua)

set -o errexit
set -o nounset
set -o pipefail

RED='\033[0;31m'
GREEN='\e[0;32m'
source deps.sh

arg=${1-"do_not_update"}

mkdir -p ~/.local/bin

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

echo -e "${GREEN}done or already installed, use --update to update all lsp"
