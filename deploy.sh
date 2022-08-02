#!/usr/bin/env bash

files=( 
	"Templates/*, ~/Templates"
	"bin/*.sh, ~/bin"
	"vim/init.lua, ~/.config/nvim" 
	"vim/lua/*.lua, ~/.config/nvim/lua" 
	"vim/lua/snippets/*.lua, ~/.config/nvim/lua/snippets" 
	"vim/lua/snippets/helpers_all/*.lua, ~/.config/nvim/lua/snippets/helpers_all" 
	".mailcap, ~"
	"neomutt/colors.muttrc, ~/.config/neomutt"
	"neomutt/mappings.muttrc, ~/.config/neomutt"
	"neomutt/neomuttrc, ~/.config/neomutt"
	".zshenv, ~"
	".zshrc, ~"
	".tmux.conf, ~"
	"alacritty.yml, ~/.config/alacritty"
	"sway/config, ~/.config/sway/"
	"sway/wallpapers/*, ~/.local/share/sway"
	"sway/wallpaper.sh, ~/.config/sway"
	"sway/swap_alacritty_colors.sh, ~/.config/sway"
	"sway/rwaybar.toml, ~/.config/"
)

for paths in "${files[@]}"; do
    repo_path=$(echo ${paths} | cut -d "," -f 1 | tr -d '[:space:]')
    disk_folder=$(echo ${paths} | cut -d "," -f 2 | tr -d '[:space:]')
    disk_folder=${disk_folder/#\~/$HOME} #replace tilde with current home folder

	# for each path in expanded paths
	for repo_path in $repo_path
	do 
		disk_path=$disk_folder/$(basename $repo_path)

		[ -f $disk_path ] && mv $disk_path "${disk_path}.backup"
		[ -f $disk_folder ] || mkdir -p $disk_folder
		cp -r $repo_path $disk_path
	done
done
