" Set rtp & path. Vundle
set rtp+=~/vimfiles/bundle/Vundle.vim/
" FuzzyFinder
set rtp+=~/.fzf
let path='~/vimfiles/bundle'

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
" Change working dir to git repo root
command CWDG lcd `cd %:p:h; git rev-parse --show-toplevel`

" ------------------------------ Mappings ------------------------------ "
" Test Esc :
imap jk <Esc>

" Insert newline remaps
nmap oo o<Enter>
nmap OO O<Esc>O<Esc>k

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

" ------------------------------ Functions ------------------------------ "
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" ------------------------------ Leader commands ------------------------------ "
map <Space> <leader>

" Toggle location list
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" FuzzyFinder
nmap <leader>s :FZF<CR>

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
set nofoldenable

" ------------------------------ Vundle ------------------------------ "
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
call vundle#begin(path)
" alternatively, pass a path where Vundle should install plugins

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"Browser link. Auto updates browser
Plugin 'jaxbot/browserlink.vim'
function! RefreshTheme()
    " Temperary Drupal quickfix - sigh
    :!drush cc all
    :BLReloadPage
endfunction
autocmd BufWrite *.html,*.js,*.css,*.php :call RefreshTheme()
:set autoread

" Repeat
Plugin 'tpope/vim-repeat'

" Easy Motion
Plugin 'easymotion/vim-easymotion'

" Emmet
Plugin 'mattn/emmet-vim'

" css color
Plugin 'ap/vim-css-color'

" ctags test
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

" Tern (js completion)
Plugin 'marijnh/tern_for_vim'

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

" Syntastic Syntactic errors and more
Plugin 'scrooloose/syntastic'

" Javascript advanced syntax, including jQuery, underscore, etc..
Plugin 'othree/javascript-libraries-syntax.vim'

" Surround plugin
Plugin 'tpope/vim-surround'

" vim dev icons - Super pretty icons in powerline & NERDTree
Plugin 'ryanoasis/vim-devicons'
set encoding=utf-8

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" ------------------------- End of vundle ------------------------- "

" YCM auto load ycm config
let ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Snipmate
imap <C-J> <esc>a<Plug>snipMateNextOrTrigger
smap <C-J> <Plug>snipMateNextOrTrigger

" Snipmate. Enable in other file types. eg. js in html and html in python.
autocmd BufRead,BufNewFile *.html set ft=html.javascript.css
autocmd BufRead,BufNewFile *.js set ft=javascript.html.css
autocmd BufRead,BufNewFile *.php set ft=php.javascript.html.css
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

" Syntastic noobie settings. To populate locations list
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Surround mapping
vmap s S
nmap s viwS
nmap S yss

" Emmet
let g:user_emmet_leader_key='<C-E>'

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable defaul mapping
" Use leader+f to search in file
nmap <leader>f <Plug>(easymotion-overwin-f)
" case insensitive
let g:EasyMotion_smartcase = 1

" Enable omni completion.
set omnifunc=syntaxcomplete#Complete
let g:ycm_python_binary_path = '/usr/bin/python'

" Change local env after loading plugins
filetype plugin on
:CWD
