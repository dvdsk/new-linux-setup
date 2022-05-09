#!/usr/bin/env bash

set -e
source deps.sh

# install sway and launcher
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

# install breaktime
URL=https://github.com/tom-james-watson/breaktimer-app/releases/latest/download/BreakTimer.AppImage 
curl $URL --output ~/.local/bin
chmod +x ~/.local/bin
