#!/usr/bin/env bash

set -e
source deps.sh

# install sway
sudo apt install sway j4-dmenu-desktop

# install bar
cargo=$(ensure_cargo)

tmpdir=`mktemp -d`
git clone https://github.com/danieldg/rwaybar $tmpdir
cd $tmpdir
echo $cargo
sudo apt install 
$cargo build --release
cp target/release/rwaybar ~/.local/bin
cd - # back out to org wd.


# install launcher
# sudo apt install dmenu i3menu?
