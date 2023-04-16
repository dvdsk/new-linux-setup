#!/usr/bin/env bash

set -e
source deps.sh

# install sway and launcher
sudo apt install sway j4-dmenu-desktop redshift lxpolkit

# install bar
cargo=$(ensure_cargo)

$cargo install --git https://github.com/danieldg/rwaybar

# install breaktime
URL=https://github.com/tom-james-watson/breaktimer-app/releases/latest/download/BreakTimer.AppImage 
curl $URL -L --output ~/.local/bin/BreakTimer.AppImage
chmod +x ~/.local/bin/BreakTimer.AppImage
