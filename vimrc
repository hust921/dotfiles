" vim: foldmethod=marker
" Enviroment {{{1
set rtp+=~/vimfiles/bundle/Vundle.vim/
let path='~/vimfiles/bundle'

set noswapfile " Saves swap (.swp) files in System var $TEMP.
set hidden " Allow unsaved files to be in buffer
set encoding=utf-8

" Vundle - Plugins {{{1
" -----------------------------------------------------
filetype off                  " required

call vundle#begin(path)
Plugin 'gmarik/Vundle.vim'
" -----------------------------------------------------

" MISC PLUGINS {{{2
"Browser link. Auto updates browser
Plugin 'jaxbot/browserlink.vim'

" Repeat
Plugin 'tpope/vim-repeat'

" css color
Plugin 'ap/vim-css-color'

" vim-fugitive
Plugin 'tpope/vim-fugitive'

" Matches complex tags like <div> with %
Plugin 'tmhedberg/matchit'

" Javascript advanced syntax, including jQuery, underscore, etc..
Plugin 'othree/javascript-libraries-syntax.vim'

" Surround plugin
Plugin 'tpope/vim-surround'

" vim dev icons - Super pretty icons in powerline & NERDTree
Plugin 'ryanoasis/vim-devicons'
" CtrlP {{{2
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

" NerdTree {{{2
Plugin 'scrooloose/nerdtree'
let g:NERDTreeWinSize=40
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
map <F5> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-airline {{{2
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = "tender"

" git-gutter {{{2
Plugin 'airblade/vim-gitgutter'
map <leader>h <Plug>GitGutterNextHunk
map <leader>H <Plug>GitGutterPrevHunk

" Easy Motion {{{2
Plugin 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0 " Disable default mapping
" Use leader+f to search in file
nmap <leader>f <Plug>(easymotion-overwin-f)
" case insensitive
let g:EasyMotion_smartcase = 1

" Emmet {{{2
Plugin 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-E>'

" YouCompleteMe {{{2
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
let ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
" Enable omni completion.
set omnifunc=syntaxcomplete#Complete
let g:ycm_python_binary_path = '/usr/bin/python'


" Syntastic {{{2
Plugin 'scrooloose/syntastic'

" Syntastic noobie settings. To populate locations list
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Set Syntastic passive mode for [.tex, .xx, ...] files.
let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "active_filetypes": [],
            \ "passive_filetypes": ["tex"] }
"}}}
" Ultisnips {{{2
Plugin 'Ultisnips'
Plugin 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<C-J>"
let g:tex_flavor = "latex"

" Haskell {{{2
Plugin 'lukerandall/haskellmode-vim'
au BufEnter *.hs compiler ghc
let g:haddock_browser="C:/Program Files (x86)/Google/Chrome/Application/chrome.exe"
let g:haddock_docdir="C:/Users/Morten/AppData/Local/Programs/stack/x86_64-windows/ghc-8.0.1/doc/html"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Tender colortheme {{{2
Plugin 'jacoborus/tender'

" Normal & Insert Mode {{{1
imap jk <Esc>

" Insert newline remaps
nmap oo o<Enter>
nmap OO O<Esc>O<Esc>k

" Map arrows to resize windows {{{2
nmap <Down> :resize +1<CR>
nmap <Up> :resize -1<CR>
nmap <Left> :vertical resize +1<CR>
nmap <Right> :vertical resize -1<CR>

" Visual {{{1
syntax on
set background=dark
colorscheme tender

" Fix backspace
set backspace=indent,eol,start

if has("gui_running")
    set guioptions -=m "remove menubar
    set guioptions -=T "remove toolbar
else
    set t_Co=256
endif

set nowrap
set number
set ruler

" Auto indent :
set ai
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Always show statusline
set laststatus=2

" Search settings {{{1
set incsearch        " find the next match as we type the search
set ignorecase       " Required for smartcase to work
set smartcase        " Semi-Case sensitive
set hlsearch        " hilight searches by default
nnoremap <CR> :noh<CR><CR>

" Platform specific {{{1
" Windows {{{2
if has("win32") || has("win64")
    if has("gui_running")
        set guifont=UbuntuMonoDerivativePowerline_N:h12:cANSI
    endif

  
" Unix {{{2
elseif has("unix")
    command W w !sudo tee % > /dev/null
    map <F3> :w<CR>:!google-chrome %<CR>
    vmap <leader>t :!cat \|column -t<CR>
    if has("gui_running")
        set guifont=DejaVuSansMonoForPowerline\ Nerd\ Font\ 12
    endif
endif

" Functions {{{1
function! PepCheck()
  set makeprg=python\ -m\ pep8\ %
  :silent make
  :copen
  :wincmd w
  :wincmd w
endfunction

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

" <F*> Keys {{{1
" Run current file using Python
map <F1> :w<CR>:cd %:p:h<CR>:!python %<CR>

" Run selection as python
map <F2> :w !python<CR>

" stock make
map <F4> :silent make<CR>

" vimrc shortcut
map <F6> :e ~/dotfiles/vimrc<CR>

" Moving between buffers
map <F7> :bp<CR>
map <F8> :bn<CR>
map <F9> :bp<CR>:bd #<CR>

map <silent> <F10> :q<CR>

" Commands & Auto Commands {{{1
command Pep8 call PepCheck()
autocmd BufEnter * silent! lcd %:p:h

" Support multiple syntax
autocmd BufRead,BufNewFile *.html set ft=html.javascript.css
autocmd BufRead,BufNewFile *.js set ft=javascript.html.css
autocmd BufRead,BufNewFile *.php set ft=php.javascript.html.css
autocmd BufRead,BufNewFile *.py set ft=python.html.javascript.css
autocmd BufRead,BufNewFile *.pl set ft=prolog

" Leader commands {{{1
map <Space> <leader>

" Toggle location list
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" quickfix: goto next, prev
map <silent> <leader>n :cn<CR>
map <silent> <leader>N :cp<CR>

" Toggle set paste
set pastetoggle=<leader>p

" Spelling {{{2
nmap <leader>c :setlocal spell!<CR>
nmap <leader>8 [s
nmap <leader>9 ]s
nmap <leader>0 z=
nmap <leader>m %

set spelllang=en,da

" Local Overites {{{1
source ~/vimfiles/vimlocal.vim
" Latex {{{1
" 'Compile' command.
command Latex silent !pdflatex "%" && del "%:r.aux" && del "%:r.log" && "%:r.pdf"
