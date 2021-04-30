# new-linux-setup

Install git then clone this repository
run `init.sh` to install tools
run `deploy.sh` to move config files

setup keyfiles
```bash
ssh-keygen #click enter for all options
cat /home/{username}/.ssh/id_rsa.pub #copy the output and save it to github
```

setup git
populate git hooks with the content of the folder in this repo
```bash
git config --global user.name "github username"
git config --global user.email "github email" #for example use private mail offerd by github
git config --global core.hooksPath /home/kleingeld/bin/githooks
```

add [commit verification](https://help.github.com/en/articles/managing-commit-signature-verification)
```bash
sudo apt install gpg
# as we are setting up for use with github use your github username and 
# github email for Real Name and email during key generation
gpg --full-generate-key  # default settings except key length use 4096
gpg --list-secret-keys --keyid-format LONG  # copy the bit after 'sec rsa4096/' call it A
gpg --armor --export <A>  # paste this key at github.com/settings/keys
git config --global user.signingkey <A>
git config --global commit.gpgsign true
# sign tags using git tag -s
```

### Gnome desktop envirement setup
- install tweak tool en pomodoro
  ```bash
  apt install gnome-tweak-tool gnome-shell-pomodoro
  ```
- set pomodoro to send a popup when its time for a break by setting the following command to execute:
  ```bash
   zenity --timeout=300 --error --title "STOP WORKING" --width=2000 --height=500 --text="**Its time for a break, please stop, it can wait**"
  ```
- go to https://extensions.gnome.org/
- install extensions: [launch-new-instance](https://extensions.gnome.org/extension/600/launch-new-instance/) [put-windows](https://extensions.gnome.org/extension/39/put-windows/)
- copy the Templates dir to your home folder to allow creating templates from files program

### Firefox setup
- add extension AdGuard
- [optional, if work account] add extension LeechBlock and configure to block distracting sites

### Print to paper tablet
- follow: https://github.com/peerdavid/send-to-remarkable

### Install latest texlive
if applicable remove any old texlive:
```bash
- sudo apt-get remove texlive*
- rm -rf /usr/local/texlive/2020
- rm -rf ~/.texlive2020
- rm -rf /usr/local/texlive/2019
- rm -rf ~/.texlive2019
```
install fresh texlive
```bash
mkdir /tmp/texlive
cd /tmp/texlive
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip
unzip ./install-tl.zip -d install-tl
cd install-tl #might be called differently
perl ./install-tl
```
update the path in .zshenv to point to the texlive install (year might need to be changed from 2020)
