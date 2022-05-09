USER=work

sudo zfs create home/$USER
sudo zfs set mountpoint=/home/$USER home/$USER

sudo zfs create home/$USER//Documents
sudo zfs create home/$USER//Downloads
sudo zfs create home/$USER//tmp

sudo adduser --home /home/$USER --shell $(which zsh) --no-create-home $USER
