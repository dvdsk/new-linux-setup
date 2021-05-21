#!/usr/bin/env bash

build_lines_array() {
	keys="$(gpg2 --list-secret-keys --keyid-format LONG | tail -n +3)"
	IFS=$'\n' 
	for key in $keys; do
		lines+=($key)
	done
}

build_previews() {
	lines=()
	build_lines_array
	previews+=("import gpg key")
	previews+=("make new gpg key")

	i=0
	j=0
	for i in ${!lines[@]}; do
		if [[ "${lines[i]}" == "sec   "* ]]; then
			sec=$(echo ${lines[$i]} | cut -c 7- | cut -d " " -f 1)
			date=$(echo ${lines[$i]} | cut -c 7- | cut -d " " -f 2-)
			preview=$(echo -e "sec   $sec\n      $date\n${lines[$((i + 1))]}\n")
			previews+=("$preview")
		fi
	done
}

build_list() {
	lines=()
	build_lines_array
	uid_list="$uid_list\\n1: import gpg key"
	uid_list="$uid_list\\n2: make new gpg key"

	i=0
	j=3
	for i in ${!lines[@]}; do
		if [[ "${lines[i]}" == "sec   "* ]]; then
			uid=$(echo -e ${lines[$((i + 2))]} | cut -c 5- | sed -e 's/^[[:space:]]*//')
			uid_list="$uid_list\\n$j: $uid"
			j=$((j + 1))
		fi
	done
}

previews=()
build_previews
if [ ! -z $1 ]; then 
	echo "${previews[$(($1 - 1))]}"
fi
