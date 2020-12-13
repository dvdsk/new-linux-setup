#!/usr/bin/bash

files=( 
    "vim/init.vim, ~/.config/nvim" 
    ".zshenv, ~"
    ".zshrc, ~"
)

for paths in "${files[@]}"; do
    repo_path=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
    disk_path=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')/$(basename $repo_path)
    disk_path=${disk_path/#\~/$HOME} #replace tilde with current home folder

	mv $disk_path "${disk_path}.backup"
	cp $repo_path $disk_path
done
