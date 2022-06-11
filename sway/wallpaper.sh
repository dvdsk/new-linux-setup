#!/usr/bin/env bash

echo test >> /home/david/.config/sway/test.log

pid=None

function set_wallpaper {
	local file=$1
	echo setting wallpaper to: $file >&2

	# start new background over old one
	swaybg -m fill -i "$HOME/.local/share/sway/$file" &
	local new_pid=$!
	echo new pid: $new_pid >&2

	sleep 1
	# kill old background (now behind new one)
	if [[ $pid != None ]]; then
		echo killing $pid >&2
		kill $pid
	fi
	pid=$new_pid
}

function sleep_till {
	local deadline=$1
	local deadline_secs=`date --date=$deadline +%s`
	echo $deadline
	local now_secs=`date +%s`

	if [[ $now_secs > $deadline_secs ]]; then
		deadline_secs=`date --date="$deadline tomorrow" +%s`
	fi

	local duration=$((deadline_secs-now_secs))
	echo sleeping till $deadline \($duration seconds\) >&2
	sleep $duration
}

function wallpaper {
	local now=`date +%H:%M`
	echo now: $now
	if [[ $now < 06:00 ]] || [[ $now > 21:00 ]]; then
		set_wallpaper "night.png"
		sleep_till 06:00
	elif [[ $now < 12:00 ]]; then
		set_wallpaper "morning.jpg"
		sleep_till 12:00
	elif [[ $now < 16:00 ]]; then
		set_wallpaper "midday.jpg"
		sleep_till 16:00
	elif [[ $now < 21:00 ]] || [[ $now < 6:00 ]]; then
		set_wallpaper "evening.jpg"
		sleep_till 21:00
	fi
}

while true; do
	wallpaper
done
