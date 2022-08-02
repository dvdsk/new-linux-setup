#!/usr/bin/env bash

set -e

CONFIG_PATH="$HOME/.config/alacritty/alacritty.yml"

function sleep_till {
	local deadline=$1
	local deadline_secs=`date --date=$deadline +%s`
	local now_secs=`date +%s`

	if [[ $now_secs > $deadline_secs ]]; then
		deadline_secs=`date --date="$deadline tomorrow" +%s`
	fi

	local duration=$((deadline_secs-now_secs))
	echo sleeping till $deadline \($duration seconds\) >&2
	sleep $duration
}


function update_config_parts {
	config=$(cat $CONFIG_PATH)

	before_colors=$(echo "$config" \
		| grep --text "# COLORS LIGHT START" -B 9999 \
		| head -n -1)
	colors_light=$(echo "$config" \
		| grep --text "# COLORS LIGHT START" -A 9999 \
		| grep --text "# COLORS DARK START" -B 9999 \
		| head -n -1 \
		| sed s/^#--#// )
	colors_dark=$(echo "$config" \
		| grep --text "# COLORS DARK START" -A 9999 \
		| grep --text "# COLORS DONE" -B 9999 \
		| head -n -1 \
		| sed s/^#--#//)
	after_colors=$(echo "$config" \
		| grep --text "# COLORS DONE" -A 9999)
}

function set_dark {
	update_config_parts
	commented=$(echo "$colors_light" | sed s/^/#--#/)
	printf "$before_colors\n$commented\n$colors_dark\n$after_colors" > $CONFIG_PATH
	touch $CONFIG_PATH # trigger terminal refresh
}

function set_light {
	update_config_parts
	commented=$(echo "$colors_dark" | sed s/^/#--#/)
	printf "$before_colors\n$colors_light\n$commented\n$after_colors" > $CONFIG_PATH
	touch $CONFIG_PATH # trigger terminal refresh
}


while true; do
	now=`date +%H:%M`
	if [[ $now < 06:00 ]] || [[ $now > 21:00 ]]; then
		set_dark
		sleep_till 06:00
	elif [[ $now < 12:00 ]]; then
		set_light
		sleep_till 21:00
	fi
done
