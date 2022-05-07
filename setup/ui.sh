#!/usr/bin/env bash

# install sway
sudo apt install sway

# install bar
cargo=$(ensure_cargo)

tmpdir=`mktemp -d`
git clone https://github.com/danieldg/rwaybar $tmpdir
cd $tmpdir
$cargo build --release
cp target/release/rwaybar ~/.local/bin
cd - # back out to org wd.


# install launcher
# sudo apt install dmenu i3menu?
