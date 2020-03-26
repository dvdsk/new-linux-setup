export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH=$"HOME/.local/bin:$PATH"

path+=('/snap/bin/')
# export to sub-processes (make it inherited by child processes)
export PATH

# to update shell without reboot: exec zsh --login
