#!/usr/bin/bash

function modified_in_repo() {
    blame=$(git blame $1 | head -1)
    fulldate=$(echo ${blame} | cut -d " " -f 3-4)
    ts=$(date --date="${fulldate}" +"%s")
    echo $ts
}

function modified_on_disk() {
    if test -f "$1"; then
        stat --format=%Y $1
    else
        return 0
    fi
}

files=( 
    "vim/init.vim, ~/.config/nvim" 
    ".zshenv, ~"
    ".zshrc, ~"
)

updated_in_repo=()
updated_on_disk=()
for paths in "${files[@]}"; do
    repo_path=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
    disk_path=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')/$(basename $repo_path)
    disk_path=${disk_path/#\~/$HOME} #replace tilde with current home folder

    if cmp --silent $repo_path $disk_path ;
    then
        continue
    fi

    if [ $(modified_in_repo $repo_path) -gt $(modified_on_disk $disk_path) ] 
    then
		if [ "$1" == "-c" ]; then
			cp $repo_path $disk_path
		fi
        updated_on_disk+=($disk_path)
    fi 
    if [ $(modified_in_repo $repo_path) -lt $(modified_on_disk $disk_path) ] 
    then
		if [ "$1" == "-c" ]; then
			cp $disk_path $repo_path
		fi
        updated_in_repo+=($repo_path)
    fi
done

if [ "$1" != "-c" ]; then
	printf 'test run, moving nothing use -c to confirm\n'
fi

if [ ${#updated_in_repo[@]} -gt 0 ]; then
    printf 'updated in repo: %s' "${updated_in_repo[0]}"
    printf ', %s' "${updated_in_repo[@]:1}"
    printf '\n'
fi

if [ ${#updated_on_disk[@]} -gt 0 ]; then
    printf 'updated on disk: %s' "${updated_on_disk[0]}"
    printf ', %s' "${updated_on_disk[@]:1}"
    printf '\n'
fi
