# new-linux-setup

Install git then clone this repository and optionally:
- install programs  using `init.sh` from `setup/`
- install neovim using `vim.sh` from `setup/` 
- setup git configuration using `git.sh` from `setup/` 
- install texlive using `texlive.sh` from `setup/`
- deploy config files using `deploy.sh`

setup keyfiles
```bash
ssh-keygen #click enter for all options
cat /home/{username}/.ssh/id_rsa.pub #copy the output and save it to github
```

### Gnome desktop envirement setup
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
