- install neovim (> 5.0 if possible)
```
sudo apt install neovim
```

- install vim plugin manager for neovim
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

- copy the neovim config (init.vim) from here to `~/.config/nvim/init.vim`
- start neovim skip the errors and install the plugins using `:PlugInstall`

#Install fonts
[Iosevka](https://github.com/be5invis/Iosevka)
- download the patched Iosevka font from this repos font dir
or 
- download the consolas style (ss03) release with default spacing
- extract is somewhere and use the [font patcher](https://github.com/ryanoasis/nerd-fonts#option-8-patch-your-own-font) to patch it

- move the fonts to `~/.local/share/fonts`
- regenerate font cache: `fc-cache -f -v`
- select Iosevka SS03 Medium Extended

