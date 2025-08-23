#!/usr/bin/env bash

set -e

export PATH="$PATH:$HOME/.cargo/bin"

flatpaks=$(flatpak list --app --columns=name --columns=application | tail -n +1 | sed 's/\t\(.\+\)/ = flatpak run \1/') 
# Snap sometimes hangs for seconds, just dont list snaps in that case
snaps=$(timeout 0.1 snap list | awk '($1 != "Name") {print $1 "= snap run " $1;}' || true)
desktops=$(kickoff-dot-desktop)
screenshot="\
	Area to clipboard = ~/bin/screenshot.sh area clipboard
	Area to file = ~/bin/screenshot.sh area file
	Fullscreen to clipboard = ~/bin/screenshot.sh fullscreen clipboard
	Fullscreen to file = ~/bin/screenshot.sh fullscreen file
	Edit clipboard image = wl-paste | swappy -f -
"
record="\
	Record area (mod+x to stop) = ~/bin/record_screen.sh start area
	Record fullscreen (mod+x to stop) = ~/bin/record_screen.sh start fullscreen
	Recording gif to clipboard = ~/bin/to_gif.sh
	Recording mp4 to clipboard = wl-copy < /tmp/last_record_screen.mp4
"

echo "${screenshot}${record}${flatpaks}${snaps}${desktops}" | kickoff --from-stdin
