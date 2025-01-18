#!/usr/bin/env bash

set -e
source deps.sh

# install sway and launcher
sudo apt install sway redshift lxpolkit

# install bar
cargo=$(ensure_cargo)

if ! which rwaybar; then
	sudo apt install libfontconfig1-dev
	$cargo install --git https://github.com/danieldg/rwaybar
fi

if ! which kickoff-dot-desktop; then
	sudo apt install libxkbcommon-dev
	$cargo install --git https://github.com/j0ru/kickoff-dot-desktop
fi

if ! which kickoff; then
	$cargo install kickoff
fi

if ! which break-enforcer; then
	curl -L https://github.com/evavh/break-enforcer/releases/latest/download/break-enforcer_x86_64 --output break-enforcer
	chmod +x break-enforcer
	sudo ./break-enforcer wizard
	sudo ./break-enforcer install -w 15m -b 5m -l 30s -t
	rm break-enforcer
fi
