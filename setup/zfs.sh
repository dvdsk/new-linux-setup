#!/bin/bash

curl -fsSL https://zrepl.cschwarz.com/apt/apt-key.asc | sudo tee -a /usr/share/keyrings/zrepl.asc
sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/zrepl.asc arch=amd64] https://zrepl.cschwarz.com/apt/ubuntu focal main' > /etc/apt/sources.list.d/zrepl.list"
sudo apt install zrepl
sudo cp ../system/zrepl.yml /etc/zrepl/zrepl.yml
