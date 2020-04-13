# to update shell without reboot: exec zsh --login

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

path+=('/snap/bin/')
# export to sub-processes (make it inherited by child processes)
export PATH

# aliasses
alias bat="bat --theme ansi-light"
alias ls="exa"
alias la="exa -la"
alias mpd="ncmpcpp -h 192.168.1.10"
alias python="python3" #if you ever need python2 you will have to disable this alias
alias pip="pip3" #prevents acidentally using pip for python2
