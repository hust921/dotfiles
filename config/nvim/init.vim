"------------------------------------------
"-- Environment
"------------------------------------------
autocmd BufEnter * silent! lcd %:p:h
set noswapfile " Saves swap (.swp) files in System var $TEMP.
set hidden " Allow unsaved files to be in buffer

set spelllang=en,da
"------------------------------------------
"-- Ready for uncomment: (old vimrc)
"------------------------------------------
"syntax on
"set foldmethod=syntax
"autocmd BufWinEnter * silent! :%foldopen!
"set background=dark

"" Fix backspace
"set backspace=indent,eol,start

set nowrap
set number
set ruler

"" Auto indent :
set ai
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

"" Always show statusline
set laststatus=2

"" Search settings {{{1
set incsearch        " find the next match as we type the search
set ignorecase       " Required for smartcase to work
set smartcase        " Semi-Case sensitive
set hlsearch        " hilight searches by default
nnoremap <CR> :noh<CR><CR>

"------------------------------------------
"-- Functions
"------------------------------------------
" GetBufferList {{{2
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

" ToggleList {{{2
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

"------------------------------------------
"-- Basic mappings
"------------------------------------------
" -- Misc Bidings
imap jk <Esc>
map <Space> <leader>
command W w !sudo tee % > /dev/null
vmap <leader>t :!cat \|column -t<CR>

" -- Toggle location list
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" -- Map arrows to resize windows {{{2
nmap <Down> :resize +1<CR>
nmap <Up> :resize -1<CR>
nmap <Left> :vertical resize +1<CR>
nmap <Right> :vertical resize -1<CR>

" -- Spelling {{{1
nmap <leader>c :setlocal spell!<CR>
nmap <leader>8 [s
nmap <leader>9 ]s
nmap <leader>0 z=
nmap <leader>m %

" -- <F(keys)>
" Moving between buffers
map <F7> :bp<CR>
map <F8> :bn<CR>
map <F9> :bp<CR>:bd #<CR>
map <silent> <F10> :q<CR>

"------------------------------------------
"-- Plugin Manager (vim-plug)
"------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" -----
" -- Neomake: Code syntax & build automation
" -----
Plug 'neomake/neomake'
let g:neomake_python_enabled_markers = ['flake8']
"call neomake#configure#automake('w')

" -----
" -- NerdTree
" -----
Plug 'scrooloose/nerdtree'
map <F5> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=40
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" -----
" -- Deoplete (dark powered neo-completion)
" -- Auto-Completion framework for neovim/vim

" -- Specific language support:
" -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
" -----
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif " Auto close doc_string window when complete

" -- Deoplete Plugin: deoplete-jedi
" -- Python support for deoplete
Plug 'davidhalter/jedi-vim'
let g:jedi#completion_enabled = 0 " Use deoplete (not jedi-vim) for completion
let g:jedi#goto_command = "<F12>"

Plug 'deoplete-plugins/deoplete-jedi'
let g:deoplete#sources#jedi#show_docstring = 1

" -----
" -- Colorscheme: tender
" -----
Plug 'jacoborus/tender', { 'as': 'tender' }

" -----
" -- vim-airline
" -----
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = "tender"

" -----
" -- Auto-pair: Matching brackets
" -----
Plug 'jiangmiao/auto-pairs'

" -----
" -- gitgutter
" -----
Plug 'airblade/vim-gitgutter'

" -----
" -- css colors
" -----
Plug'ap/vim-css-color'

" -----
" -- css colors
" -----
Plug 'ryanoasis/vim-devicons'

" -----
" -- Fzf + Auto "System install"
" -- PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
" -----
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

call plug#end()

" -----------------------------------
" -- Local Overwrite
" -----------------------------------
" From old (Vim 7.4 vimrc config: "source ~/vimfiles/vimlocal.vim
colorscheme tender
