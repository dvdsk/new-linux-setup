#!/usr/bin/env bash

set -e
template_dir="${HOME}/Templates/"

# list of template options including those in subdirs
# prepended by their path from the Template dir

format() {
	local path="$1"
	local line=$(echo ${path#${template_dir}})

	local RESET="\033[0m"
	local BLUE="\033[0;34m"
	local GREEN="\033[0;32m"

	local OPTION=""
	local FOLDER=$GREEN

	# ignore backups
	if [[ $path == *.backup ]]; then
		return
	fi

	# if template folder
	if [[ $path == *__ ]]; then
		local line=${line::-2}
		printf "$path/ $OPTION$line$RESET"
		return 
	fi

	# if in template folder
	if [[ $path == *__* ]]; then
		return
	fi

	# if file present as option
	if [ -f "$path" ]; then
		printf "$path $OPTION$line$RESET"
		return 
	fi

}

format_lines() {
	local lines="$(find $template_dir -maxdepth 3)"
	for line in $lines; do
		local line=$(format $line)
		if [ "$line" != "" ]; then
			echo $line
		fi
	done
}

pick_template() {
	local path=$(format_lines $template_dir \
		| sk --delimiter " " --with-nth 2 --ansi --no-multi \
		| cut -d " " -f 1 \
		| sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")

	if [ -d "$path" ]; then
		local path=$(echo "$path*")
	fi
	
	cp $path .
}

pick_template
