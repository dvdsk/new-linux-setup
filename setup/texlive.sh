#!/usr/bin/env bash
set -e

sudo apt-get --quiet --yes remove texlive* || true
sudo apt-get --quiet --yes install perl wget 

curr_year=$(date +'%Y')

# remove any old texlive
for ((year = 2018; year < curr_year; year++)); do
	sudo rm -rf /usr/local/texlive/$year
	sudo rm -rf ~/.texlive/$year
done

# install fresh texlive
TEMP=`mktemp --directory --suffix="_TEXLIVE"`
wget --output-document $TEMP/install-tl.zip \
	http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip
unzip -o $TEMP/install-tl.zip -d $TEMP/install-tl
path=$(ls $TEMP/install-tl | sort | tail -n 1)
sudo perl $TEMP/install-tl/$path/install-tl <<< I

# # add simlink so path need not be changed between updates
cd /usr/local/texlive
current=$(find . 20* -maxdepth 0 -type d | sort | tail -n 1)
cd -

sudo rm /usr/local/texlive/installed || true
sudo ln -s /usr/local/texlive/$current /usr/local/texlive/installed

# # clean up
rm -rf $TEMP
