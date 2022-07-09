#!/usr/bin/env bash

sudo apt install sanoid

# sudo cp will make the file root:root and set perm ok.
# ransomeware wont be able to delete the auto snapshots
sudo cp ../sanoid.conf /etc/sanoid/sanoid.conf

sudo systemctl restart sanoid
