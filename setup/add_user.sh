USER=work

sudo zfs create rpool/USERDATA/$USER
sudo zfs set mountpoint=/home/$USER /rpool/USERDATA/$USER

sudo adduser --home /home/$USER --shell $(which zsh) --no-create-home $USER
