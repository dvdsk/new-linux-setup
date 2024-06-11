#!/usr/bin/env bash

set -e
source deps.sh

# install sway and launcher
sudo apt install sway redshift lxpolkit

# install bar
cargo=$(ensure_cargo)

$cargo install --git https://github.com/danieldg/rwaybar
$cargo install --git https://github.com/j0ru/kickoff-dot-desktop
$cargo install kickoff

curl -L https://github.com/evavh/break-enforcer-s/releases/latest/download/break-enforcer_x86_64 --output break-enforcer
chmod +x break-enforcer
./break-enforcer install -w 15m -b 7m -l 30s -t
rm break-enforcer
