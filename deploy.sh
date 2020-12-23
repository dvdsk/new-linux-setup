#!/usr/bin/bash

files=( 
    "vim/init.vim, ~/.config/nvim" 
	"vim/.vimrc, ~"
    ".zshenv, ~"
    ".zshrc, ~"
	".tmux.conf, ~"
	".gitconfig, ~"
)

for paths in "${files[@]}"; do
    repo_path=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
    disk_folder=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')
    disk_folder=${disk_folder/#\~/$HOME} #replace tilde with current home folder
	disk_path=$disk_folder/$(basename $repo_path)

	[ -f $disk_path ] && mv $disk_path "${disk_path}.backup"
	[ -f $disk_folder ] || mkdir -p $disk_folder
	cp $repo_path $disk_path
done
