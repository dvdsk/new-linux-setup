# new-linux-setup

add [commit verification](https://help.github.com/en/articles/managing-commit-signature-verification)

```bash
sudo apt install gpg
gpg --full-generate-key  # default settings except key length use 4096
gpg --list-secret-keys --keyid-format LONG  # copy the key after 'sec rsa4096/'
gpg --armor --export <key-here>  # paste this key at github.com/settings/keys
git config --global user.signingkey <key-here>
git config --global commit.gpgsign true
# sign tags using git tag -s
```
