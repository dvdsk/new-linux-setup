# new-linux-setup

setup [gitmoji](https://github.com/carloscuesta/gitmoji-cli)
```bash
sudo apt install npm
sudo npm i -g gitmoji-cli
```


add [commit verification](https://help.github.com/en/articles/managing-commit-signature-verification)
```bash
sudo apt install gpg
gpg --full-generate-key  # default settings except key length use 4096
gpg --list-secret-keys --keyid-format LONG  # copy the bit after 'sec rsa4096/' call it A
gpg --armor --export <A>  # paste this key at github.com/settings/keys
git config --global user.signingkey <A>
git config --global commit.gpgsign true
# sign tags using git tag -s
```
