#!/usr/bin/env bash

set -e

format() {
	local line=$1
	local RESET="\033[0m"
	local BLUE="\033[0;34m"
	local GREEN="\033[0;32m"

	local OPTION=""
	local FOLDER=$GREEN

	# if file present as option
	if [ -f "$line" ]
	then
		echo -e "$OPTION$(basename $line)$RESET"
		return 
	fi

	# if template folder
	if [[ $line == *_ ]]
	then
		local file_name=$(basename $line)
		local file_name=${file_name::-1}
		echo -e "$OPTION$file_name$RESET"
		return 
	fi

	# is folder
	echo -e "$FOLDER$(basename $line)$RESET"
}

format_ls() {
	dir=$1
	lines="$(ls $dir)"
	for line in $lines
	do
		echo -e "$dir/$line $(format "$dir/$line")"
	done
}

pick_file() {
	dir=$1
	path=$(format_ls $dir \
		| sk --with-nth 2 --ansi --no-multi \
		| cut -d " " -f 1)

	# if template folder
	if [[ $(basename $path) == *_ ]]
	then
		echo $path
		return
	fi

	# if file
	if [ -f "$path" ]
	then
		echo $path
		return
	fi

	# must be a subfolder -> go deeper
	pick_file "${path}"
}

target=$(pick_file "${HOME}/Templates")
echo $target

