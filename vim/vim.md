- install neovim (> 0.5) note for now download nightly
```
sudo apt install neovim
```

- install paq plugin manager for neovim
```
git clone https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim
```

- copy the neovim configs from here to `~/.config/nvim/`
- start neovim and let it install all plugins `nvim +PaqInstall`
- from neovim install some language servers and treesitter parsers 
	- `:TSInstall python rust lua c`
	- `:LspInstall pyls rust_analyzer` note use tab for completion

#Install fonts
[Iosevka](https://github.com/be5invis/Iosevka)
- download the patched Iosevka font from this repos font dir
or 
- download the consolas style (ss03) release with default spacing
- extract is somewhere and use the [font patcher](https://github.com/ryanoasis/nerd-fonts#option-8-patch-your-own-font) to patch it

- move the fonts to `~/.local/share/fonts`
- regenerate font cache: `fc-cache -f -v`
- select Iosevka SS03 Medium Extended

