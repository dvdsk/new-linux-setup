# to update shell without reboot: exec zsh --login

#add dirs to path 
#This lower-case syntax is using path as an array, yet also affects its upper-case partner equivalent, PATH (to which it is "bound" via typeset).
path+="$HOME/.cargo/bin"
path+="$HOME/bin"
path+="$HOME/.local/bin"
path+="/usr/local/texlive/2020/bin/x86_64-linux"
path+=('/snap/bin/')

# export to sub-processes (make it inherited by child processes)
export PATH

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
alias v="gnome-pomodoro --start && nvim"
alias tree2="tree -L 2"
alias rootvim="sudo -E nvim" #warning use with caution, any vim plugin now runs with ROOT privilege
