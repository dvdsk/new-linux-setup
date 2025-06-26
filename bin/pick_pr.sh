#!/usr/bin/env bash

# credits to contributers of: https://gist.github.com/jasonrudolph/1810768  

list=""
prs=$(git ls-remote origin 'pull/*/head')

user_name=$(git config user.name)
user_email=$(git config user.email)

echo "fetching more info ..."
while read line
do
	pr_numb=$(echo $line | awk '{print $2}' | sed -r 's/refs\/pull\/([0-9]+)\/head/\1/')
	pr_hash=$(echo $line | awk '{print $1}')

	# # format sting introduces ^ which are later used to align columns
	# format="%ci _%C(magenta) %cr^ %C(bold cyan)pr$pr_numb%Creset^ %s^ %C(bold blue)%an%Creset"
	# last_commit=$(git show -s --format="$format" --color "$pr_hash" 2> /dev/null) 
	# if [ $? -eq 0 ]; then
	# 	list="${list}${last_commit}\\n"
	# fi
	list="$list\n$pr_numb $pr_hash"
done <<< "(echo -e "$prs")"

list=$(echo -e "$list" \
	| sort -nr)
	# | cut -d_ -f2- \
	# | sed 's;origin/;;g' \

# list=$(pr_list "$prs")
choice=$(echo "$list" | sk --ansi)
pr_numb=$(echo $choice | awk '{print $1}')
pr_hash=$(echo $choice | awk '{print $2}')

git fetch origin pull/$pr_numb/head:pr$pr_numb
git checkout pr$pr_numb

# github/git screws these up (somehow I became github actions bot)
# this fixes them again
git config user.name $user_name
git config user.email $user_email
