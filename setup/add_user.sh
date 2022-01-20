USER=work

sudo zfs create rpool/USERDATA/$USER
sudo zfs set mountpoint=/home/$USER /rpool/USERDATA/$USER

sudo adduser --home /home/$USER --shell $(which zfs) --no-create-home $USER
