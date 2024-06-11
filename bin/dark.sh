#!/usr/bin/env bash

set -e

CONFIG_PATH="$HOME/.config/alacritty/alacritty.yml"

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

# -r van reverse
if [[ -z $1 ]]; then
	touch /tmp/darkmode
	set_dark
else
	rm /tmp/darkmode
	set_light
fi

