" vim: foldmethod=marker
"=== Terminal Settings / Mappings {{{1    --
"------------------------------------------
" Mappings
tnoremap jk <C-\><C-n>
tnoremap <Esc> <C-\><C-n>

"=== Environment {{{1                     --
"------------------------------------------
set noswapfile " Saves swap (.swp) files in System var $TEMP.
set hidden " Allow unsaved files to be in buffer

set spelllang=en,da
syntax on
set foldmethod=manual
autocmd BufWinEnter * silent! :%foldopen!
autocmd BufEnter * silent! lcd %:p:h

" Fix backspace
set backspace=indent,eol,start

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

" -- Ale: Async Linting Engine
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
let g:NERDTreeWinSize=40
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" -- Deoplete (dark powered neo-completion) {{{2
" -- Auto-Completion framework for neovim/vim

" -- Specific language support:
" -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
" -----
Plug 'neovim/nvim-lsp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif " Auto close doc_string window when complete

" -- Deoplete (ish) Plugin: EchoDoc {{{3
" -- Displays function signatures from completions in the command line.
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
"let g:echodoc#events = ['CompleteDone']

" -- Deoplete Plugin: neoinclude {{{3
" -- Include completion framekwork for neocomplete/deoplete
Plug 'Shougo/neoinclude.vim/'

" -- Deoplete Plugin: deoplete-jedi {{{3
" -- Python support for deoplete
Plug 'davidhalter/jedi-vim'
let g:jedi#completion_enabled = 0 " Use deoplete (not jedi-vim) for completion
let g:jedi#goto_command = "<F12>"
Plug 'deoplete-plugins/deoplete-jedi'
let g:deoplete#sources#jedi#show_docstring = 1

" -- Deoplete Plugin: neco-vim {{{3
" -- Vimscript completion for deoplete
Plug 'Shougo/neco-vim'

" -- Deoplete Plugin: autocomplete-flow {{{3
" -- Javascript support for deoplete
Plug 'wokalski/autocomplete-flow'

" -- Deoplete Plugin: Shougo/deoplete-clangx {{{3
" -- Clang C/C++ Completion support for deoplete
Plug 'Shougo/deoplete-clangx'

" -- Dockerfile syntax highlighting {{{2
Plug 'ekalinin/Dockerfile.vim'

" -- Neosnippet + neosnippet-snippets {{{2
" -----
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
let g:neosnippet#enable_completed_snippet = 1
imap <C-j> <Plug>(neosnippet_expand_or_jump)
smap <C-j> <Plug>(neosnippet_expand_or_jump)
xmap <C-j> <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
    \ pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"<Paste>

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

function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir))
    "Not woking:
    "   :echo &rtp => /path/plugdir/fzf,/path/plugdir/nvim-lsp
    "   :echo g:plugs['fzf'].dir => /path/plugdir/fzf/
    "Notice the trailing "/". Makes "stridx" fail
    "
    "\ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction 

if PlugLoaded('nvim-lsp')
    " Rust completion
    " Use LSP omni-complete in Rust files
    lua require'nvim_lsp'.rust_analyzer.setup{}
    autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
endif



"=== Local Overwrite {{{1          --
" -----------------------------------
" From old (Vim 7.4 vimrc config: "source ~/vimfiles/vimlocal.vim

" Always use win32yank if available.
" Forcing this, so not to load xclip.
" Copied from: https://github.com/neovim/neovim/blob/master/runtime/autoload/provider/clipboard.vim
if executable('win32yank.exe')
    let g:clipboard = {
    \ 'name': 'win32yank.exe',
    \ 'copy': {
    \    '+': 'win32yank.exe -i --crlf',
    \    '*': 'win32yank.exe -i --crlf',
    \  },
    \ 'paste': {
    \    '+': 'win32yank.exe -o --lf',
    \    '*': 'win32yank.exe -o --lf',
    \ },
    \ 'cache_enabled': 1,
    \ }
endif

"=== Colorscheme {{{1              --
" -----------------------------------
colorscheme afterglow
