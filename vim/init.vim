set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'git://github.com/altercation/vim-colors-solarized.git'
Plug 'overcache/NeoSolarized'

Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

" needs pyvim (pip3 install pynvim) replaces nerdtree
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
"Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" Theme
set termguicolors
set background=light
colorscheme NeoSolarized "solarized
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0

let g:airline_theme='solarized'

" Change the Solarized background to dark or light depending upon the time of 
" day (5 refers to 5AM and 17 to 5PM). Change the background only if it is not 
" already set to the value we want.
function! SetSolarizedBackground()
    if strftime("%H") >= 5 && strftime("%H") < 17 
        if &background != 'light'
            set background=light
        endif
    else
        if &background != 'dark'
            set background=dark
        endif
    endif
endfunction


" Every time you save a file, call the function to check the time and change 
" the background (if necessary).
if has("autocmd")
    autocmd bufwritepost * call SetSolarizedBackground()
endif

" syntastic recommended defaults
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" rebinds
tnoremap <ESC> <C-w>:q!<CR> "allow escape in terminal mode
