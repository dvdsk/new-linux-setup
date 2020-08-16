" ========================================================================
" # PLUGINS
" ========================================================================

" Plugins
call plug#begin('~/.vim/plugged')

" GUI
Plug 'machakann/vim-highlightedyank'
Plug 'https://github.com/lifepillar/vim-solarized8'  
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Semantic language support
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'sheerun/vim-polyglot' "language pack (syntax+indents)

" GUI Tools
Plug 'simnalamburt/vim-mundo'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' } " needs pyvim 

" Tools
Plug 'scrooloose/nerdcommenter'
Plug 'conradirwin/vim-bracketed-paste'
Plug 'airblade/vim-rooter'

call plug#end()


" ========================================================================
" # Basic behaviour
" ========================================================================

set backspace=indent,eol,start " backspace over anything
set autoindent
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.
set noerrorbells visualbell t_vb= "disable horrible bell
set incsearch " Enable searching as you type, rather than waiting till you press enter.
set ignorecase "ignore case in search
set smartcase "except when I put a capital in the query
set incsearch "highlight all matches:
set mouse+=a "enable mouse support
set undodir=~/.vimdid "permanent undo
set undofile "permanent undo
set nohlsearch "do not keep highlighting search after move
set spell spelllang=en_gb
set hidden "allow to hide an unsaved buffer

" ========================================================================
" # Plugin behaviour
" ========================================================================

" disables multiple modes in clap which allows escape to always quit clap
let g:clap_insert_mode_only = v:true
" let airline display ALE info
let g:airline#extensions#ale#enabled = 1
" we use coc for lsp
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 1
let b:coc_suggest_disable = 1

" ========================================================================
" # User Interface
" ========================================================================

syntax on
set number
set relativenumber
set laststatus=2 " always show status at buttom even if only one window
set termguicolors
set background=light
highlight Comment cterm=italic gui=italic

let g:solarized_extra_hi_groups = 1
colorscheme solarized8
let g:airline_theme='solarized'
let g:clap_theme = 'nord'

" Change the Solarized background to dark or light depending upon the time of 
" day (5 refers to 5AM and 17 to 5PM). Change the background only if it is not 
" already set to the value we want.
function! SetSolarizedBackground()
    if strftime("%H") >= 5 && strftime("%H") < 21 
        if &background != 'light'
            let g:clap_theme = 'solarized_dark'
	    let g:airline_solarized_bg='light'
	    AirlineTheme solarized
	    set background=light
        endif
    else
        if &background != 'dark'
            let g:clap_theme = 'solarized_dark'
	    let g:airline_solarized_bg='dark'
	    AirlineTheme solarized
	    set background=dark
        endif
    endif
endfunction


" Every time you save a file, call the function to check the time and change 
" the background (if necessary).
if has("autocmd")
    autocmd VimEnter * call SetSolarizedBackground()
    autocmd bufwritepost * call SetSolarizedBackground()
endif

"" ========================================================================
" # Key (re)Bindings
" ========================================================================

tnoremap <ESC> <C-w>:q!<CR> "allow escape in terminal mode
imap <^[[3> <ESC>
let mapleader="\<SPACE>" "Map the leader key to SPACE
"toggles between buffers
nnoremap <leader><leader> <c-^> 
"search for file to open
nnoremap <leader>o :Clap files<CR> 
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>f :CHADopen<CR>
nnoremap <leader>r :Clap grep<CR>
"suggestions for misspelled word TODO make this go to next misspelled if not on a misspelled word 
nnoremap z z= 

"only colomak remap we do, hjkl we hardly use thanks to 
"ergodox layout (easy left right etc) and better movement 
"alternatives (think w for next word e to end of word etc)
"f <-> s "use find character more and s has a comfortable position
nnoremap f s
nnoremap s f

"" ========================================================================
" # Other
" ========================================================================


" 'Smart' navigation
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
