#!/usr/bin/bash

files=( 
    "vim/init.vim, ~/.config/nvim" 
    ".zshenv, ~"
    ".zshrc, ~"
	".tmux.conf, ~"
	".gitconfig, ~"
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

	printf "${repo_path} differs from ${disk_path}, diff:\n"
	diff $repo_path $disk_path
done
