" ========================================================================
" # PLUGINS
" ========================================================================
" Plugins
let b:has_vim_plug = 0
if has('nvim')
	if !empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
		let b:has_vim_plug = 1
	endif
else 
	if !empty(glob("~/.vim/autoload/plug.vim"))
		let b:has_vim_plug = 1
	endif
endif

if b:has_vim_plug
call plug#begin('~/.vim/plugged')
" GUI
Plug 'machakann/vim-highlightedyank'
Plug 'https://github.com/lifepillar/vim-solarized8'  
Plug 'jnurmine/Zenburn'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'ervandew/supertab'

" Syntactic language support
Plug 'sheerun/vim-polyglot' "language pack (syntax+indents)

" GUI Tools
Plug 'simnalamburt/vim-mundo'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' } " needs pyvim 

" Tools
Plug 'vim-scripts/Align'
Plug 'tpope/vim-commentary'
Plug 'conradirwin/vim-bracketed-paste'
Plug 'airblade/vim-rooter'

" Nouns, Verbs, textobjects
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'

call plug#end()
endif


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
set mouse=nic "enable mouse support except for selecting text
set undodir=~/.vimdid "permanent undo
set undofile "permanent undo
"set backup TODO look into this
set nohlsearch "do not keep highlighting search after move
set spell spelllang=en_gb
set spellsuggest+=10 "don't take up the entire screen with spell suggestions
if has('nvim')
	autocmd TermOpen * setlocal nospell "do not spell check terminal
endif
set hidden "allow to hide an unsaved buffer
set splitbelow "new split goes bottom
set splitright "new split goes right
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4
autocmd FileType * setlocal tabstop=4 "override plugins overriding tabstop
set foldmethod=syntax "enable code folding
set foldenable
set foldlevel=1

" ========================================================================
" # Advanced behaviour
" ========================================================================

" function! b:click_in_term()
" 	let b:last_mode = 0
" endfunction

" function! b:click_elsewhere()
" endfunction
if has('nvim')
	autocmd TermOpen * startinsert
	autocmd BufWinEnter,WinEnter term://* startinsert
endif


" ========================================================================
" # Plugin behaviour
" ========================================================================

" disables multiple modes in clap which allows escape to always quit clap
let g:clap_insert_mode_only = v:true
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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
highlight Comment cterm=italic gui=italic

" airline config, disable error and warning section
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ [ 'x', 'y', 'z' ]
  \ ]

if b:has_vim_plug
	" Change the background to dark or light depending upon the time of 
	" day (5 refers to 5AM and 17 to 5PM). Change the background only if it is not 
	" already set to the value we want.
	let s:themeset = 0
	function! SetTheme()
		if strftime("%H") >= 5 && strftime("%H") < 21 
			if (&background != 'light' || s:themeset != 1)
				colors solarized8
				let s:themeset = 1
				let g:clap_theme = 'solarized_dark'
				let g:airline_solarized_bg='light'
				set background=light
				AirlineTheme solarized
			endif
		else
			if (&background != 'dark' || s:themeset != 1)
				let s:themeset = 1
				let g:clap_theme = 'nord'
				colors zenburn
				set background=dark
				"zenburn overwrites this so we need to reset it
				highlight Comment cterm=italic gui=italic
				AirlineTheme zenburn
			endif
		endif
	endfunction


	" Every time you save a file,call the function to check the time and change 
	" the background (if necessary).
	if has("autocmd")
		autocmd VimEnter * call SetTheme()
		autocmd bufwritepost * call SetTheme()
	endif
endif

"" ========================================================================
" # Key (re)Bindings
" ========================================================================

" this dark magic makes hitting // in visual mode search for the next
" occurrence, then navigation goes with n and N like normal
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" tnoremap <ESC> <C-w>:q!<CR> "allow escape in terminal mode
tnoremap <ESC> <C-\><C-n>
let mapleader="\<SPACE>" "Map the leader key to SPACE

"-----------new functionality-----------
"search for file to open
nnoremap <leader>o :Clap files<CR> 
nnoremap <leader>f :CHADopen<CR>
nnoremap <leader>r :Clap grep<CR>
"view a tree of all undoes
nnoremap <leader>u :MundoToggle<CR>
"auto format
nnoremap <leader>m :Autoformat<CR>
"go to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>n <Plug>(coc-diagnostic-next)
nmap <leader>cr <Plug>(coc-rename)

" move windows with ctrl+arrows
tnoremap <C-left> <C-\><C-N><C-w>h
tnoremap <C-down> <C-\><C-N><C-w>j
tnoremap <C-up> <C-\><C-N><C-w>k
tnoremap <C-right> <C-\><C-N><C-w>l
nnoremap <C-left> <C-\><C-N><C-w>h
nnoremap <C-down> <C-\><C-N><C-w>j
nnoremap <C-up> <C-\><C-N><C-w>k
nnoremap <C-right> <C-\><C-N><C-w>l
inoremap <C-left> <C-\><C-N><C-w>h
inoremap <C-down> <C-\><C-N><C-w>j
inoremap <C-up> <C-\><C-N><C-w>k
inoremap <C-right> <C-\><C-N><C-w>l
"------------vim defaults changing re mapping----------

""TODO FIXME GIVES ISSUES WITH SELECTING AUTOCOMPLETE

""go up and down visual lines
"nmap <silent> <Down> gj
"nmap <silent> <Up> gk
"vmap <silent> <Down> gj
"vmap <silent> <Up> gk
"imap <silent> <Down> <C-o>gj
"imap <silent> <Up> <C-o>gk

"------------re mapping for comfort----------
"toggles between buffers
nnoremap <leader><leader> <c-^>
"comfy, use : over ; in normal map so map ;->: and :->;
nnoremap ; :
nnoremap : ;
"comfy spell with <leader>z over z= 
nnoremap <leader>z :z=
"switch buffers/tabs move windows
nnoremap <Leader>b :buffers<CR>:buffer<Space>
"yank till end of line
nnoremap Y y$

"" ========================================================================
" # Other
" ======================================================================== 
