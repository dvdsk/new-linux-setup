#!/usr/bin/env bash

recording_path=/tmp/last_record_screen.mp4

# concurrent recordings dont make sense, always kill
# any ongoing recording
pkill --euid "$USER" --signal SIGINT wf-recorder
if [[ $1 == "stop" ]]; then
	notify-send "stopped recording"
	exit
fi

if [[ $2 == "area" ]]; then
	coords=$(echo "-g \"$(slurp)\" ") || exit
fi

# timeout and exit after 10 minutes as user has almost certainly forgotten it's running
echo "timeout 600 wf-recorder $coords -f \"$recording_path\" || exit" | bash
