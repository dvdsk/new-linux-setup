# to update shell without reboot: exec zsh --login

#add dirs to path 
#This lower-case syntax is using path as an array, yet also affects its upper-case partner equivalent, PATH (to which it is "bound" via typeset).
path+="$HOME/.cargo/bin"
path+="$HOME/bin"
path+="$HOME/.local/bin"
path+="/usr/local/texlive/installed" # sim link to actual install
path+=('/snap/bin/')
path+="$HOME/.pyenv/bin"

# export to sub-processes (make it inherited by child processes)
export PATH
export VISUAL="$HOME/bin/nvim.appimage"
export EDITOR="$VISUAL"

# aliasses
alias bat="bat --theme 'Monokai Extended Light'"
alias ls="exa"
alias la="exa -la"
alias diff="delta --syntax-theme 'Monokai Extended Light'"
alias mpd="ncmpcpp -h 192.168.1.10"
alias python="python3" #if you ever need python2 you will have to disable this alias
alias ipython="ipython3"
alias pip="pip3" #prevents accidentally using pip for python2
alias open="xdg-open" 
alias getaudio="youtube-dl -f 'bestaudio[ext=m4a]'" #followed by youtube url in quotes
alias spellcheck="aspell -t -c" #followed by some file you want to spell check
alias nvim="$HOME/bin/nvim.appimage"
alias v="gnome-pomodoro --start && nvim"
alias rootvim="echo use sudoedit instead" # works thanks to VISUAL
alias on_change="entr -rc"

# by default ignore using gitignore, 
# if you want a full tree use ftree
alias ftree="exa --tree" 
alias tree="exa --tree --git-ignore"
for i in {1..5}; do
    alias ftree${i}="ftree -L $i"
    alias tree${i}="tree -L $i"
done

alias -s git="git clone"

# Mnemonic based aliases
alias tt="gio trash" # to trash
alias pc="pick_commit.sh"
alias pt="pick_template.sh"
