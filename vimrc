" Set rtp & path. Vundle
set rtp+=~/vimfiles/bundle/Vundle.vim/
let path='~/vimfiles/bundle'

" vimrc shortcut
map <F6> :e $MYVIMRC<CR>

" Saves swap (.swp) files in System var $TEMP.
set noswapfile

" Spelling
nmap <leader>c :setlocal spell!<CR>
nmap <leader>8 [s
nmap <leader>9 ]s
nmap <leader>0 z=
nmap <leader>m %

set spelllang=en,da

" Test Esc
imap jk <Esc>

" Insert newline remaps
nmap oo o<Enter>
nmap OO O<Esc>O<Esc>k

" Map arrows to resize windows
nmap <Down> :resize +1<CR>
nmap <Up> :resize -1<CR>
nmap <Left> :vertical resize +1<CR>
nmap <Right> :vertical resize -1<CR>

" Run current file using Python
map <F1> :w<CR>:cd %:p:h<CR>:!python %<CR>

" Run selection as python
map <F2> :w !python<CR>

" ------------------------------ Functions ------------------------------ "
"function! CWD()
"  if (argc())
"    lcd %:p:h
"  else
"    cd ~
"  endif
"endfunction
"call CWD()

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

" Toggle set paste
set pastetoggle=<leader>p

" ------------------------------ Visual ------------------------------ "
colorscheme default

" Fix backspace
set backspace=indent,eol,start

if has("gui_running")
    set guioptions -=m "remove menubar
    set guioptions -=T "remove toolbar
    set guifont=DejaVuSansMonoForPowerline\ NF:h12
    colorscheme Spink
else
    set t_Co=256
endif

syntax enable
set nowrap
set number
set ruler
set hidden " Allow unsaved files to be in buffer

" Auto indent :
set ai
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

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

" ctrlp - Fuzzy file, buffer, mru, tags finder
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_show_hidden = 1
set wildignore+=*.swp,*.zip,*.exe,*.pyc,*.png,*.jpg,*.ini,NTUSER.DAT*
map <C-p> :CtrlPMixed<CR>
map <C-l> :CtrlPLine<CR>

Plugin 'tacahiroy/ctrlp-funky'
nnoremap <C-k> :CtrlPFunky<CR>
" ctrlp speed
Plugin 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }


" NerdTree & plugins
Plugin 'scrooloose/nerdtree'
let g:NERDTreeWinSize=40
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <F5> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-arline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "ubaryd"

" git-gutter
Plugin 'tpope/vim-fugitive'

" git-gutter
Plugin 'airblade/vim-gitgutter'
map <leader>h <Plug>GitGutterNextHunk
map <leader>H <Plug>GitGutterPrevHunk

"Browser link. Auto updates browser
Plugin 'jaxbot/browserlink.vim'

" Repeat
Plugin 'tpope/vim-repeat'

" Easy Motion
Plugin 'easymotion/vim-easymotion'

" Emmet
Plugin 'mattn/emmet-vim'

" css color
Plugin 'ap/vim-css-color'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

" Nerd tree
Plugin 'The-NERD-tree'

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

" Syntastic noobie settings. To populate locations list
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Emmet
let g:user_emmet_leader_key='<C-E>'

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mapping
" Use leader+f to search in file
nmap <leader>f <Plug>(easymotion-overwin-f)
" case insensitive
let g:EasyMotion_smartcase = 1

" Enable omni completion.
set omnifunc=syntaxcomplete#Complete
let g:ycm_python_binary_path = '/usr/bin/python'

" Change local env after loading plugins
filetype plugin on
" search settings
set incsearch        " find the next match as we type the search
set ignorecase       " Required for smartcase to work
set smartcase        " Semi-Case sensitive
set hlsearch        " hilight searches by default
nnoremap <CR> :noh<CR><CR>

map <silent> <F10> :q<CR>

function! PepCheck()
  set makeprg=python\ -m\ pep8\ %
  :silent make
  :copen
  :wincmd w
  :wincmd w
endfunction
map <silent> <leader>n :cn<CR>
map <silent> <leader>N :cp<CR>
command Pep8 call PepCheck()


" ------------------------------ LINUX Specific ------------------------------ "
"command W w !sudo tee % > /dev/null
"map <F3> :w<CR>:!google-chrome %<CR>
"vmap <leader>t :!cat \|column -t<CR>
