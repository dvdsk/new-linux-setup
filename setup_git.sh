#!/usr/bin/env bash
set -e

source preview.sh
gen_gpg_key() {
	gpg2 --batch --gen-key <<EOF
		%no-protection
		Key-Type: default
		Key-Length: 4096
		Expire-Date: 0
		Name-Real: $1
		Name-Email: $2
EOF
}

choose_key() {
	uid_list=""
	build_list
	choice=$(echo -e "${uid_list}" | sk \
		--ansi \
		--no-multi \
		--delimiter ':' \
		--preview "./preview.sh {1}" | cut -d ":" -f 1)
	echo $choice
}

if ! command -v gpg2 &> /dev/null; then
	sudo apt install gnupg2
fi

USERNAME="dskleingeld"
EMAIL="11743287+dskleingeld@users.noreply.github.com"

git config --global user.name $USERNAME
git config --global user.email $email
# # git config --global core.hooksPath /home/kleingeld/bin/githooks

keyid=""
for (( ; ;)); do 
	choice=$(choose_key)
	if [[ $choice == "1" ]]; then
		read -sp "path to private.key: " key_path
		gpg2 --import $key_path
		continue
	elif [[ $choice == "2" ]]; then
		gen_gpg_key $USERNAME $EMAIL
		continue
	else
		previews=()
		build_previews
		keyid="${previews[$(($choice - 1))]}"
		break 
	fi
done

keyid=$(echo $keyid | cut -d "/" -f 2 | cut -d " " -f 1)
pubkey=$(gpg2 --armor --export $keyid)  # paste this key at github.com/settings/keys

git config --global user.signingkey $keyid
git config --global commit.gpgsign true
echo -e "copy the following block to https://github.com/settings/gpg/new \n$pubkey"
