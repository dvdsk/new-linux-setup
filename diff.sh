#!/usr/bin/env bash

# enable ** pattern
shopt -s globstar

files=( 
	"Templates/**/*, ~/Templates"
	"bin/*.sh, ~/bin"
	".mailcap, ~"
	"neomutt/colors.muttrc, ~/.config/neomutt"
	"neomutt/mappings.muttrc, ~/.config/neomutt"
	"neomutt/neomuttrc, ~/.config/neomutt"
	"vim/init.lua, ~/.config/nvim" 
	"vim/lua/*.lua, ~/.config/nvim/lua" 
	"vim/lua/snippets/*.lua, ~/.config/nvim/lua/snippets" 
	"vim/lua/snippets/helpers_all/*.lua, ~/.config/nvim/lua/snippets/helpers_all" 
	"zed/*, ~/.config/zed"
	".zshenv, ~"
	".zshrc, ~"
	".tmux.conf, ~"
	"alacritty.toml, ~/.config/alacritty"
	"sway/config, ~/.config/sway"
	"sway/wallpapers/*, ~/.local/share/sway"
	"sway/wallpaper.sh, ~/.config/sway"
	"sway/swap_alacritty_colors.sh, ~/.config/sway"
	"sway/rwaybar.toml, ~/.config"
	
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
	repo_glob=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
	base_disk_path=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')
	base_disk_path=${base_disk_path/#\~/$HOME} #replace tilde with current home folder

    	# for each path in expanded paths
	for repo_path in $repo_glob; do

		if [[ "$repo_glob" == *"*"* ]]; then 
			# remove anything before /*
			to_remove=$(echo "$repo_glob" \
				| sed 's/\/\*.*//')
			glob=$(echo ${repo_path#"${to_remove}"})
			disk_path=$base_disk_path$glob
		else 
			disk_path=$base_disk_path/$(basename $repo_path)
		fi 

		# cant compare directories
		if [ -d $repo_path ]; then
			continue
		fi

		# if files are identical continue
		if cmp --silent $repo_path $disk_path; then
			continue
		fi

		printf "${repo_path} differs from ${disk_path}\n"
		printf "${DIFF_EXPL}\n"
		eval $DIFF $disk_path $repo_path
		echo 
	done
done
