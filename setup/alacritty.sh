#!/usr/bin/env bash
set -e

# set alacritty as the default terminal
set_as_default() {
	gsettings set \
		org.gnome.desktop.default-applications.terminal \
		exec alacritty
	gsettings set \
		org.gnome.desktop.default-applications.terminal \
		exec-arg ''
}

# copy the gnome terminal app .desktop to the users applications folder
# (this overrides the system wide one) and modify it to start alacritty
# instead
set_as_desktop_terminal_app() {
	local target=~/.local/share/applications/org.gnome.Terminal.desktop
	cp /usr/share/applications/org.gnome.Terminal.desktop $target
	sed -i 's/TryExec=gnome-terminal/TryExec=alacritty/' $target
	sed -i 's/Exec=gnome-terminal/Exec=alacritty/' $target
	sed -i 's/Icon=org.gnome.Terminal/Icon=com.alacritty.Alacritty/' $target
}

# install fonts
source fonts.sh
install_fonts

# install themes
if [ -d $HOME/.config/alacritty/themes ]; then
    git pull
else
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
fi

# # move config in place
CONFIGPATH=~/.config/alacritty/alacritty.toml
mkdir -p $(dirname $CONFIGPATH)
[ -f $CONFIGPATH ] || cp ../alacritty.toml $CONFIGPATH

sudo apt-get install alacritty \
	&& set_as_default \
	&& set_as_desktop_terminal_app \
	&& echo "installed alacritty" \
	&& exit 0 \
	|| true
