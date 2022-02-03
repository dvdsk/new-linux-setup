#!/usr/bin/env bash
set -e

sudo apt-get --quiet --yes remove texlive* || true
sudo apt-get --quiet --yes install perl wget 

curr_year=$(date +'%Y')

# remove any old texlive
for year in {2020..$(($curr_year - 1))}; do
	rm -rf /usr/local/texlive/$year
	rm -rf ~/.texlive/$year
done

# install fresh texlive
TEMP=/tmp/texlive
mkdir -p $TEMP
wget --output-document $TEMP/install-tl.zip \
	http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip
unzip -o $TEMP/install-tl.zip -d $TEMP/install-tl
path=$(ls $TEMP/install-tl | sort | tail -n 1)
sudo perl $TEMP/install-tl/$path/install-tl <<< I

# add simlink so path need not be changed between updates
cd /usr/local/texlive
current=$(find . 20* -maxdepth 0 -type d | sort | tail -n 1)
cd -

sudo rm /usr/local/texlive/installed
sudo ln -s /usr/local/texlive/$current /usr/local/texlive/installed

# clean up
rm -rf $TEMP
