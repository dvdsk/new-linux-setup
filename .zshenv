# to update shell without reboot: exec zsh --login

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH=$"HOME/.local/bin:$PATH"

path+=('/snap/bin/')
# export to sub-processes (make it inherited by child processes)
export PATH

# aliasses
alias bat="bat --theme ansi-light"
alias ls="exa"
alias la="exa -la"
