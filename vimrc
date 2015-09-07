" Set rtp & path. Vundle
set rtp+=vimfiles/bundle/Vundle.vim/
let path='vimfiles/bundle'

" vimrc shortcut
map <F6> :e ~/.vimrc<CR>

" ------------------------------ LINUX Specific ------------------------------ "
command W w !sudo tee % > /dev/null

" ------------------------------ Functional ------------------------------ "
" Change working directory
cd ~/

" Saves swap (.swp) files in System var $TEMP.
set noswapfile

" ------------------------------ Command Mappings ------------------------------ "
command CWD lcd %:p:h

" ------------------------------ Mappings ------------------------------ "
" Test Esc :
imap jk <Esc>

" Insert newline remaps
nmap oo o<Enter>
nmap OO O<Esc>O<Esc>k

" Auto complete curly braces
inoremap {<CR> {<CR>}<Esc>O
inoremap { {}<Esc>i

" Map arrows to resize windows :
nmap <Down> :resize +1<CR>
nmap <Up> :resize -1<CR>
nmap <Left> :vertical resize +1<CR>
nmap <Right> :vertical resize -1<CR>

" Run current file using Python
map <F1> :w<CR>:cd %:p:h<CR>:!python %<CR>

" Run selection as python
map <F2> :w !python<CR>

" Open current file in browser
map <F3> :w<CR>:!google-chrome %<CR>
" ------------------------------ Leader commands ------------------------------ "
map <Space> <leader>
nmap <leader>l V>
nmap <leader>h V<

" ------------------------------ Visual ------------------------------ "
colorscheme bubblegum-256-dark

" Fix backspace
set backspace=indent,eol,start

if has("gui_running")
    set guioptions -=m "remove menubar
    set guioptions -=T "remove toolbar
else
    set t_Co=256
endif

syntax enable
set tabstop=4
set nowrap
set number
set ruler
set hidden " Allow unsaved files to be in buffer

" Auto indent :
set ai
set expandtab
set shiftwidth=4
set softtabstop=4

" Add powerline
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2

" Fold options
set foldmethod=syntax
autocmd BufWinEnter * silent! :%foldopen!

" ------------------------------ Vundle ------------------------------ "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
call vundle#begin(path)
" alternatively, pass a path where Vundle should install plugins

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

" Nerd tree
Plugin 'The-NERD-tree'

" buffer list/bar
Plugin 'bling/vim-bufferline'
"
" Matches complex tags like <div> with %
Plugin 'tmhedberg/matchit'


" ---- Snipmate ------------------------------ "
" Snipmate (code snippets) TAB to run snippet
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
" Optional snippets for snipmate
Plugin 'honza/vim-snippets'
" ---- Snipmate ------------------------------ "

" vCooler color picker Alt-c
Plugin 'KabbAmine/vCoolor.vim'

" Syntastic Syntactic errors and more
Plugin 'scrooloose/syntastic'

" Javascript advanced syntax, including jQuery, underscore, etc..
Plugin 'othree/javascript-libraries-syntax.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ------------------------- End of vundle ------------------------- "

" YCM auto load ycm config
let ycm_confirm_extra_conf = 0

" Snipmate
imap <C-J> <esc>a<Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger

" Snipmate. Enable in other file types. eg. js in html and html in python.
autocmd BufRead,BufNewFile *.html set ft=html.javascript.css
autocmd BufRead,BufNewFile *.js set ft=javascript.html.css
autocmd BufRead,BufNewFile *.py set ft=python.html.javascript.css

" Buffer line
map <F7> :bp<CR>
map <F8> :bn<CR>
map <F9> :bp<CR>:bd #<CR>

" NERDTree Setup
map <F5> :NERDTreeToggle<CR>
let NERDTreeWinSize = 35
" Open NERDTree if filename argument given and move cursor back
autocmd VimEnter * if @% != '' | NERDTree %
autocmd VimEnter * wincmd w
" Close if NERDTree is the last buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
