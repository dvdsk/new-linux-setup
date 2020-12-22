#!/usr/bin/bash

files=( 
    "vim/init.vim, ~/.config/nvim" 
	"vim/.vimrc, ~"
    ".zshenv, ~"
    ".zshrc, ~"
	".tmux.conf, ~"
	".gitconfig, ~"
)

DIFF_EXPL="when deployed the red lines will be removed from the installed configs"
DIFF="delta --syntax-theme \"Monokai Extended Light\" --paging never"
if ! command -v delta &> /dev/null
then # fall back to diff if delta not present
	DIFF_EXPL="when deployed the lines starting with '<' will be removed from the installed configs"
	DIFF="diff"
fi

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

	printf "${repo_path} differs from ${disk_path}\n"
	printf "${DIFF_EXPL}\n"
	eval $DIFF $disk_path $repo_path
	echo 
done
