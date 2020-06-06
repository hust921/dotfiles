" vim: foldmethod=marker
"=== Terminal Settings / Mappings {{{1    --
"------------------------------------------
" Mappings
tnoremap jk <C-\><C-n>
tnoremap <Esc> <C-\><C-n>

"=== Environment {{{1                     --
"------------------------------------------
set completeopt=menuone,noinsert,noselect
set noswapfile " Saves swap (.swp) files in System var $TEMP.
set hidden " Allow unsaved files to be in buffer
set spelllang=en,da
autocmd BufEnter * silent! lcd %:p:h


" Ignore folding, syntax & FileType autocmd's for larger files
augroup LargeFile
    autocmd BufReadPre * call LargeFileOptions()
augroup END

function LargeFileOptions()
    let f=expand("<afile>")
    if getfsize(f) > (1024 * 150) " > 150KB
        set eventignore+=FileType 
        setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 foldmethod=manual
    else 
        set eventignore-=FileType
        syntax on
        set foldmethod=syntax
        autocmd BufWinEnter * silent! :%foldopen!
    endif
endfunction

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

" Search settings
set incsearch        " find the next match as we type the search
set ignorecase       " Required for smartcase to work
set smartcase        " Semi-Case sensitive
set hlsearch        " hilight searches by default
nnoremap <CR> :noh<CR><CR>

"=== Functions {{{1                       --
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

"=== Basic mappings {{{1                  --
"------------------------------------------
" -- Misc Bidings
imap jk <Esc>
map <Space> <leader>
command W w !sudo tee % > /dev/null
vmap <leader>t :!cat \|column -t<CR>

" Insert newline remaps
nmap oo o<Enter>
nmap OO O<Esc>O<Esc>k

" -- Toggle location list
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" -- Map arrows to resize windows {{{2
nmap <Down> :resize +1<CR>
nmap <Up> :resize -1<CR>
nmap <Left> :vertical resize +1<CR>
nmap <Right> :vertical resize -1<CR>

"=== Spelling {{{1
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

"=== Plugin Manager (vim-plug) {{{1       --
"------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" -- Completion-nvim & Dianostics {{{2
" -----
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

" -- Snippets {{{2
" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" -- Rainbow Parentheses Improved {{{2
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" -- Syntax Support {{{2
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['v', 'vlang']

" -- Ale: Async Linting Engine {{{2
" -----
Plug 'dense-analysis/ale'
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_column_always = 1
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
let g:ale_set_highlights = 1
nmap <silent> <leader>e :ALENext<CR>
nmap <silent> <leader>E :ALEPrevious<CR>

" -- NerdTree {{{2
" -----
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
map <F5> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=30
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" -- Dockerfile syntax highlighting {{{2
Plug 'ekalinin/Dockerfile.vim'

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" -- Colorscheme: tender {{{2
" -----
Plug 'jacoborus/tender', { 'as': 'tender' }

" -- vim-airline {{{2
" -----
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = "tender"

" -- Auto-pair: Matching brackets {{{2
" -----
Plug 'jiangmiao/auto-pairs'

" -- Surround by Tpope {{{2
" -----
Plug 'tpope/vim-surround'

" -- gitgutter {{{2
" -----
Plug 'airblade/vim-gitgutter'

" -----
" -- css colors {{{2
" -----
Plug'ap/vim-css-color'

" -----
" -- Startify: The fancy start screen for Vim
" -----
Plug 'mhinz/vim-startify'

" -- Fzf + Auto "System install" {{{2
" -- PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
" -----
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <C-l> :BLines<CR>
nnoremap <C-f> :Buffers<CR>
nnoremap <C-k> :Commands<CR>
nnoremap <C-t> :Tags<CR>

" RON (Rust Objection Notation) support
Plug 'ron-rs/ron.vim'

call plug#end()

" Rust completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype rust setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype vim setl omnifunc=v:lua.vim.lsp.omnifunc

" completion-nvim
let g:completion_enable_auto_hover = 1
let g:completion_auto_change_source = 0

" - Enable snippet support
let g:completion_enable_snippet = 'Ultisnips'
" - Matching Strategy
let g:completion_matching_strategy_list = ['exact', 'fuzzy']
let g:completion_matching_ignore_case = 1

call sign_define("LspDiagnosticsErrorSign", {"text" : ">>", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚡", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})

" diagnostic-nvim
let g:diagnostic_level = 'Warning'
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
let g:diagnostic_insert_delay = 1


"=== Local Overwrite {{{1          --
" -----------------------------------
" From old (Vim 7.4 vimrc config: "source ~/vimfiles/vimlocal.vim

" Always use win32yank if available.
" Forcing this, so not to load xclip.
" Copied from: https://github.com/neovim/neovim/blob/master/runtime/autoload/provider/clipboard.vim
if executable('/mnt/c/Windows/System32/win32yank.exe')

    let g:clipboard = {
    \ 'name': '/mnt/c/Windows/System32/win32yank.exe',
    \ 'copy': {
    \    '+': '/mnt/c/Windows/System32/win32yank.exe -i --crlf',
    \    '*': '/mnt/c/Windows/System32/win32yank.exe -i --crlf',
    \  },
    \ 'paste': {
    \    '+': '/mnt/c/Windows/System32/win32yank.exe -o --lf',
    \    '*': '/mnt/c/Windows/System32/win32yank.exe -o --lf',
    \ },
    \ 'cache_enabled': 1,
    \ }
endif

"=== Colorscheme {{{1              --
" -----------------------------------
colorscheme tender

" Run lua init
luafile ~/.config/nvim/init.lua
