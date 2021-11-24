# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit load djui/alias-tips
zinit ice depth=1; zinit load zdharma/fast-syntax-highlighting
zinit ice depth=1; zinit load zsh-users/zsh-completions
zinit ice depth=1; zinit load mdumitru/fancy-ctrl-z
zinit ice depth=1; zinit load mdumitru/git-aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle :compinstall filename '/home/kleingeld/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Setup history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
setopt extended_history

export HISTSIZE=10000
export HISTFILE="${HOME}/.zsh_history"
export SAVEHIST=${HISTSIZE}

# make search up and down work, so partially type and hit up/down to find relevant stuff
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" history-beginning-search-forward

# zoxide (z alternative) setup
eval "$(zoxide init zsh)"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

alias luamake=/tmp/lua-language-server/3rd/luamake/luamake
