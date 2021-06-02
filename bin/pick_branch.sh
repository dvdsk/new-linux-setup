#!/usr/bin/env bash

# credits to contributers of: https://gist.github.com/jasonrudolph/1810768  
branch_list() {
	local branches=$1

	local list=""
	for branch in $branches; do
		# format sting introduces ^ which are later used to align columns
		local format="%ci _%C(magenta) %cr^ %C(bold cyan)$branch%Creset^ %s^ %C(bold blue)%an%Creset"
		local last_commit=$(git log --color --format="$format" $branch | head -n 1)
		list=$list$last_commit\\n
	done

	echo -e "$list" \
		| sort -r \
		| cut -d_ -f2- \
		| sed 's;origin/;;g' \
		| column -t -s '^'
}

branches=$(git branch -r | grep -v HEAD)
list=$(branch_list "$branches")
choice=$(echo "$list" | sk --ansi | xargs | cut -d " " -f 4)

git checkout $choice
