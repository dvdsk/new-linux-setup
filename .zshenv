# to update shell without reboot: exec zsh --login

#add dirs to path 
#This lower-case syntax is using path as an array, yet also affects its upper-case partner equivalent, PATH (to which it is "bound" via typeset).
path+="$HOME/bin"
path+="$HOME/.go/bin"
path+="$HOME/.cargo/bin"
path+="$HOME/.local/bin"

path+=('/snap/bin/')
path+="/usr/local/texlive/installed/bin/x86_64-linux" # sim link to actual install
path+="$HOME/.pyenv/bin"

# export to sub-processes (make it inherited by child processes)
export PATH
export VISUAL=nvim
export EDITOR="$VISUAL"
export GOPATH=$HOME/.go

# aliasses
alias bat="bat --theme 'Monokai Extended Light'"
alias ls="exa"
alias la="exa -la"
alias diff="delta --syntax-theme 'Monokai Extended Light'"
alias mpd="ncmpcpp -h 192.168.1.43"
alias python="python3" #if you ever need python2 you will have to disable this alias
alias ipython="ipython3"
alias pip="pip3" #prevents accidentally using pip for python2
alias open="xdg-open" 
alias v="nvim"
alias m="neomutt"

alias ctrlc="xclip -selection c"
alias ctrlv="xclip -selection c -o"
alias rootvim="echo use sudoedit instead" # works thanks to VISUAL

alias getaudio="youtube-dl -f 'bestaudio[ext=m4a]'" #followed by youtube url in quotes
alias on_change="entr -rc"
alias spellcheck="aspell -t -c" #followed by some file you want to spell check

# by default ignore using gitignore, 
# if you want a full tree use ftree
alias ftree="exa --tree" 
alias dtree="exa --tree --only-dirs" 
alias tree="exa --tree --git-ignore"
for i in {1..5}; do
    alias ftree${i}="ftree -L $i"
    alias dtree${i}="dtree -L $i"
    alias tree${i}="tree -L $i"
done

alias -s git="git clone"

# Mnemonic based aliases
alias tt="gio trash" # to trash
alias pc="pick_commit.sh"
alias pt="pick_template.sh"
alias pb="pick_branch.sh"

# cd directory  aliasses
alias pros="cd ~/.local/share/nvim/site/pack/manually_installed/opt/prosesitter.nvim"
