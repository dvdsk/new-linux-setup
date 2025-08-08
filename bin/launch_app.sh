#!/usr/bin/env bash

set -e

export PATH="$PATH:$HOME/.cargo/bin"

flatpaks=$(flatpak list --app --columns=name --columns=application | tail -n +1 | sed 's/\t\(.\+\)/ = flatpak run \1/') 
snaps=$(snap list | awk '($1 != "Name") {print $1 "= snap run " $1;}')
desktops=$(kickoff-dot-desktop)
screenshot="\
	Area to clipboard = ~/bin/screenshot.sh area clipboard
	Area to file = ~/bin/screenshot.sh area file
	Fullscreen to clipboard = ~/bin/screenshot.sh fullscreen clipboard
	Fullscreen to file = ~/bin/screenshot.sh fullscreen file
	Edit clipboard image = wl-paste | swappy -f -
"

echo "${screenshot}${flatpaks}${snaps}${desktops}" | kickoff --from-stdin
