let mapleader = ","
let maplocalleader = ","

" Comment
imap <LocalLeader>c /*  */<Esc>2hi

" Comment line C style
map sc ^i/* <Esc>A */<Esc>
" Uncomment line C style
map sC ds/ds*

" Comment single line C++ style
map <LocalLeader>c ^i// <Esc>
" Uncomment single line
map <LocalLeader>C :s/^\/\/\s*//<cr>

" Window switching
map <C-space> <C-W>w
map <A-l> <C-W>l
map <A-k> <C-W>k
map <A-j> <C-W>j
map <A-h> <C-W>h
map <C-S-o> :sp<CR>
map <C-S-e> :vsp<CR>

" Control-P buffers
map <C-S-p> :CtrlPBuffer<cr>
map <C-p> :CtrlP<cr>

" Insert another record to Face list
imap <LocalLeader>n <Esc>yyp0<C-a>2Wd$"+pA<C-v>	<Esc>gEyvT.2gEdvT."0PwdEi

" Javadoc comments
imap <LocalLeader>@a @author Matej Vavrinec <wmatex@gmail.com>

" Gstatus
map <LocalLeader>gt :Gstatus<cr>

" Toggle search highlight
map <F3> :set hlsearch!<cr>

" Autoformat
noremap <F4> :Autoformat<CR><CR>

" Reload CommandT
map <F5> :CommandTFlush<CR>

" Run make
noremap <F6> :make<CR>

" Toggle NERDTree
noremap <F7> :NERDTreeToggle<CR>

" Toggle Tagbar
noremap <F8> :TagbarToggle<CR>

" Toggle light/dark background
function! BgToggle()
  if &g:background == "light"
    set background=dark
  else
    set background=light
  endif
endfunction
noremap <F9> :call BgToggle()<CR>

" Toggle between HTML, Javascript and PHP filetype
function! FtToggle()
  if &l:ft ==? "html"
    set ft=php
  elseif &l:ft ==? "php"
    set ft=javascript
  elseif &l:ft ==? "javascript"
    set ft=html
  endif
  echom "Filetype =" &l:ft
endfunction
noremap <F11> :call FtToggle()<CR>

" Clear CtrlP 
noremap <F10> :CtrlPClearCache<CR>

" Faster saving
imap <C-s> <Esc>:w<cr>
map <C-s> :w<cr>

" Tab switching
imap <C-Tab> <Esc>:tabn<cr>
imap <C-S-Tab> <Esc>:tabp<cr>
map <C-Tab> :tabn<cr>
map <C-S-Tab> :tabp<cr>

" Edit vimrc in horizontal split
map <Leader>v :sp ~/.vimrc<CR>

" Edit mapp.vim in horizontal split
map <Leader>map :sp ~/.vim/mapp.vim<CR>

" Show Syntastic errors
map <Leader>e :Errors<CR>

" SnipMate
 ino <c-\> <c-r>=TriggerSnippet()<cr>
 snor <c-\> <esc>i<right><c-r>=TriggerSnippet()<cr>

" Switch the annoying colon
nnoremap ; :

" Activate spellchecking on demand
function! SpellToggle()
  if &l:spell == 0
    setlocal spell
    echo "Spellchecking enabled"
  else
    setlocal nospell
    echo "Spellchecking disabled"
  endif
endfunction
nmap <Leader>s :call SpellToggle()<CR>

nmap <Leader>b :RainbowParenthesesToggle<CR>

