" ========================================================================
" # PLUGINS
" ========================================================================
" Plugins
call plug#begin('~/.vim/plugged')
" GUI
Plug 'machakann/vim-highlightedyank'
Plug 'https://github.com/lifepillar/vim-solarized8'  
Plug 'jnurmine/Zenburn'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'

" Semantic language support
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ervandew/supertab'

" Syntactic language support
Plug 'sheerun/vim-polyglot' "language pack (syntax+indents)

" GUI Tools
Plug 'simnalamburt/vim-mundo'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' } " needs pyvim 

" Tools
Plug 'tpope/vim-commentary'
Plug 'conradirwin/vim-bracketed-paste'
Plug 'airblade/vim-rooter'

" Nouns, Verbs, textobjects
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'

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
set spellsuggest+=10 "don't take up the entire screen with spell suggestions
set hidden "allow to hide an unsaved buffer
set splitbelow "new split goes bottom
set splitright "new split goes right
set tabstop=4
set shiftwidth=4

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
let b:coc_suggest_disable = 0
"disable undo dir popping up for every workspace
"let g:workspace_persist_undo_history = 1

let g:startify_list = [
  \ { 'type': 'sessions',  'header': ['   Sessions'],      },
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]

" ========================================================================
" # User Interface
" ========================================================================

syntax on
set number
set relativenumber
set laststatus=2 " always show status at bottom even if only one window
set termguicolors
set background=light
highlight Comment cterm=italic gui=italic

" Change the background to dark or light depending upon the time of 
" day (5 refers to 5AM and 17 to 5PM). Change the background only if it is not 
" already set to the value we want.
function! SetSolarizedBackground()
    if strftime("%H") >= 5 && strftime("%H") < 21 
        if &background != 'light'
            colors solarized8
			let g:clap_theme = 'solarized_dark'
			let g:airline_solarized_bg='light'
			AirlineTheme solarized
			set background=light
        endif
    else
        if &background != 'dark'
            let g:clap_theme = 'nord'
			colors zenburn
			set background=dark
			AirlineTheme zenburn
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
let mapleader="\<SPACE>" "Map the leader key to SPACE

"toggles between buffers
nnoremap <leader><leader> <c-^>
"set current tabs as a workspace
nnoremap <leader>s :ToggleWorkspace<CR>
"search for file to open
nnoremap <leader>o :Clap files<CR> 
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>f :CHADopen<CR>
nnoremap <leader>r :Clap grep<CR>
"comfy, use : over ; in normal map so map ;->: and :->;
nnoremap ; :
nnoremap : ;
"switch buffers/tabs move windows
nnoremap <Leader>b :buffers<CR>:buffer<Space>

"go to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>cr <Plug>(coc-rename)
nnoremap Y y$

"" ========================================================================
" # Other
" ========================================================================
