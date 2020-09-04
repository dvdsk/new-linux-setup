#!/usr/bin/bash

function modified_in_repo() {
    blame=$(git blame $1 | head -1)
    fulldate=$(echo ${blame} | cut -d " " -f 3-4)
    ts=$(date --date="${fulldate}" +"%s")
    return $ts
}

function modified_on_disk() {
    if test -f "$1"; then
        stat --format=%Y $1
    else
        return 0
    fi
}

files=( 
    "README.md, ~/Downloads" 
    "LICENSE, ~/Documents" 
)

updated_in_repo=()
updated_on_disk=()
for paths in "${files[@]}"; do
    in_repo=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
    on_disk=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')/$(basename $in_repo)
    on_disk=${on_disk/#\~/$HOME} #replace tilde with current home folder

    echo file $in_repo
    echo repo $(modified_in_repo $in_repo)
    echo disk $(modified_on_disk $on_disk)

    if [ $(modified_in_repo $in_repo) -gt $(modified_on_disk $on_disk) ] 
    then
        cp $in_repo $on_disk
        updated_on_disk+=$on_disk
    fi 
    if [ $(modified_in_repo $in_repo) -st $(modified_on_disk $on_disk) ] 
    then
        cp $on_disk $in_repo
        updated_in_repo+=$in_repo
    fi
done

if [ ${#updated_in_repo[@]} -gt 0 ]; then
    echo updated in repo: ${updated_in_repo[@]}
fi

if [ ${#updated_on_disk[@]} -gt 0 ]; then
    echo updated on disk: ${updated_on_disk[@]}
fi
