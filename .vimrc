" Vundle setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" Vundle plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Chiel92/vim-autoformat'
Plugin 'kien/ctrlp.vim'
" Plugin 'derekwyatt/vim-fswitch'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdtree'
" Plugin 'derekwyatt/vim-protodef'
" Plugin 'msanders/snipmate.vim'
" Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'airblade/vim-rooter'
" Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'mkitt/tabline.vim'
"Plugin 'scrooloose/syntastic'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'mattn/emmet-vim'
Plugin 'tikhomirov/vim-glsl'
Plugin 'beyondmarc/opengl.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdcommenter'
"Plugin 'majutsushi/tagbar'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
" Plugin 'edkolev/tmuxline.vim'
Plugin 'evidens/vim-twig'
Plugin 'c-cube/vim-tptp'
Plugin 'editorconfig/editorconfig-vim'

" Colorschemes
Plugin 'joshdick/onedark.vim'
Plugin 'fneu/breezy'

if has('gui_running')
  " Use YouCompleteMe only in GVim for 'serious' coding,
  " since the plugin slows the startup
  Plugin 'Valloric/YouCompleteMe'
endif

set t_Co=256

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Create vim swap files in dedicated directory
set backupdir=~/.vim-swap,~/.tmp,/tmp
set directory=~/.vim-swap,~/.tmp,/tmp

" set clipboard=unnamed
set showmatch  " Show matching brackets.
set ignorecase  " Do case insensitive matching
set smartcase  " Do smart case matching
set mouse=a  " Enable mouse usage (all modes)

set ai
set smartindent
" set sm
set cindent
set autoindent
set shiftwidth=4
set tabstop=4
set smarttab
set wildmenu
set wildmode=longest:full,full
set expandtab
set nomagic
set backspace=indent,eol,start

set noshowmode

" Upgrade the status line
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P

" Show the command in normal mode
set showcmd

" Search options
set hlsearch
set incsearch

" Keep the cursor 2 lines from top and bottom shen scrolling
set scrolloff=2

" Show dollar sign when changing
" set cpoptions+=$

" Line numbers can be annoying sometimes
set nu

" Do not wrap the line
set tw=0

" Fold based on indentation
set foldmethod=manual  

" Omni completition
"filetype plugin on
"set ofu=syntaxcomplete

filetype indent on

" Let me switch to another buffer while the current one is modified
set hidden

" Dont redraw window while executing macros
set lazyredraw

" Always show status line
set laststatus=2

" Highlight line below cursor (dont use it in terminal vim)
" set cursorline

" Vim autoformater
let g:formatprg_args_cpp = ""

" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" Smart tab complete
so ~/.vim/smarttab.vim

" Java complete
"if has("autocmd") 
"  autocmd Filetype java setlocal omnifunc=javacomplete#Complete 
"endif 

" Use rules for good commits :)
autocmd Filetype gitcommit setlocal spell textwidth=72

" Force utf-8
set encoding=utf-8

" Vim-latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_ViewRule_pdf='zathura'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'

" Session restore
set sessionoptions=buffers,curdir,resize,winpos,winsize,tabpages

" Load mappings from specialized file
so ~/.vim/mapp.vim

" Buffer explorer Vim-like navigation
let g:miniBufExplMapWindowNavVim = 1 

" Buffer explorer switch buffers
let g:miniBufExplMapCTabSwitchBufs = 1

" Vim-airline
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
""let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
""let g:airline_symbols.linenr = '␊'
""let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
""let g:airline_symbols.paste = 'ρ'
""let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#whitespace#enabled = 0

" Syntastic
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler_options = '-std=c++11'
let g:syntastic_cpp_check_header = 1
" let g:syntastic_check_on_wq = 0

" Fswitch
au! BufEnter *.cc let b:fswitchdst = 'h'
au! BufEnter *.h let b:fswitchdst = 'cc'

" UltiSnips
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger = '<c-l>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsListSnippets = '<c-\>'

" No preview window
set completeopt=menuone
let g:EclimCompletionMethod = 'omnifunc'

" Mark folds
set foldmethod=marker
" Unfold all by default
set foldlevel=98

" Delete trailing whitespace
au FileType c,cpp,java,php au BufWritePre <buffer> :%s/\s\+$//e

" Supertab completition based on context
let g:SuperTabDefaultCompletionType = "context"

" Latex-Box
let g:LatexBox_build_dir = "build"
let g:LatexBox_latexmk_async = 0
let g:LatexBox_quickfix = 0

" Load rainbow vim
au Syntax * RainbowParenthesesLoadRound

" Wrap lines longer than 80 characters in LaTEX
au FileType tex setlocal tw=80
au FileType tex setlocal spell

" Disable automatic comment insertion in C/C++
au FileType c,cpp setlocal comments-=:// comments+=f://

" Yaml specific tabwidth
au FileType yml,yaml setlocal shiftwidth=2 tabstop=2

" Google translate
set keywordprg=trans\ -no-ansi\ :cs

if (has("termguicolors"))
    set termguicolors
endif

" onedark.vim override: Don't set a background color when running in a terminal;
" just use the terminal's background color
" `gui` is the hex color code used in GUI mode/nvim true-color mode
" `cterm` is the color code used in 256-color mode
" `cterm16` is the color code used in 16-color mode
if (has("autocmd") && !has("gui_running"))
  let s:white = { "gui": "#eff0f1", "cterm": "145", "cterm16" : "7" }
  let s:black = { "gui": "#31363b", "cterm": "235", "cterm16": "0" }
  autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white, "bg": s:black }) " No `bg` setting
end

" colorscheme default
" colorscheme molokai
" colorscheme solarized
colorscheme onedark
" set cursorline


hi Normal ctermbg=NONE
hi NonText ctermbg=none


" Cscope
if has('cscope')
  set cscopetag cscopeverbose

  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  command! -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src
endif
