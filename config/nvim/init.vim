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
autocmd BufEnter * silent! lcd %:p:h

" Ignore folding, syntax & FileType autocmd's for larger files
augroup LargeFile
    autocmd BufReadPre * call LargeFileOptions()
augroup END

set foldmethod=manual
function LargeFileOptions()
    let f=expand("<afile>")
    if getfsize(f) > (1024 * 150) " > 150KB
        set eventignore+=FileType 
        setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1
    else 
        set eventignore-=FileType
        syntax on
        autocmd BufWinEnter * silent! :%foldopen!
    endif
endfunction

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
command! W w !sudo tee % > /dev/null
vmap <leader>t :!cat \|column -t<CR>
nnoremap <leader>b :.FloatermSend<CR>
nnoremap <leader>k :.FloatermSend<CR>:FloatermShow<CR>

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
map <F6> :e ~/.config/nvim/init.vim<CR>
map <F7> :bp<CR>
map <F8> :bn<CR>
map <F9> :bp<CR>:bd #<CR>
map <silent> <F10> :q<CR>
map <silent> <C-q> :q<CR>
imap <silent> <C-q> <Esc>:q<CR>

"=== Plugin Manager (vim-plug) {{{1       --
"------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" -- FloatTerm: Floating terminal {{{2
" ----- Make stuff float
Plug 'voldikss/vim-floaterm'
let g:floaterm_height = 0.9
let g:floaterm_width = 0.8
nnoremap <leader>t :FloatermToggle<CR>
let g:floaterm_borderchars =  ['─', '│', '─', '│', '╭', '╮', '╯', '╰']


function! s:floatermSettings()
    setlocal number
endfunction
autocmd Filetype floaterm call s:floatermSettings()

" -- vim-signature: Mark(s) in gutter {{{2
" -----
Plug 'kshenoy/vim-signature'

" -- Markdown
" --- Math, Charts, Diagrams, etc: https://github.com/iamcco/markdown-preview.nvim
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 0 "Update only when save/leave insert
"let g:mkdp_browser = '/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
let g:mkdp_echo_preview_url = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }
let g:mkdp_browserfunc = 'Xdgopen'
function! Xdgopen(url) abort
    let g:mkdp_browser_open_already = 1
    if executable('xdg-open')
        execute '!xdg-open ' . a:url 
    else
        echoerr "xdg-open command not available!"
    endif
endfunction



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
let g:ale_linters = {'rust': ['analyzer']}

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

" -- Neovim LSP Settings {{{2
" -- nvim-lsp: Usefull (native nvim) lsp configurations
Plug 'neovim/nvim-lsp'
Plug 'sheerun/vim-polyglot'

" -- Neovim Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" -- Code action "lightbulb"
Plug 'kosayoda/nvim-lightbulb'

" -- Deoplete (dark powered neo-completion) {{{2
" -- Auto-Completion framework for neovim/vim

" -- Specific language support:
" -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
" -----
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
let g:neosnippet#enable_completed_snippet = 0
autocmd CompleteDone * call neosnippet#complete_done()
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
Plug 'joshdick/onedark.vim', { 'as': 'onedark' }

" -- vim-airline {{{2
" -----
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = "onedark"

" -- Auto-pair: Matching brackets {{{2
" -----
Plug 'jiangmiao/auto-pairs'

" -- Surround by Tpope {{{2
" -----
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

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
nnoremap <C-a> :Marks<CR>
nnoremap qa :History:<CR>
nnoremap <C-h> :History/<CR>

" RON (Rust Objection Notation) support
Plug 'ron-rs/ron.vim'

call plug#end()

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust", "regex", "css", "javascript", "json", "toml", "c_sharp", "cpp", "lua", "ruby", "python", "yaml", "bash", "html"},  -- list of language that will be disabled
  },
}
EOF

" code action lightbulb
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
lua require'nvim-lightbulb'.update_lightbulb { sign = { enable = true, priority = 10, } }

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
    lua require'lspconfig'.rust_analyzer.setup{}
    lua require'lspconfig'.vimls.setup{}
    lua require'lspconfig'.pyls.setup{}
    lua require'lspconfig'.html.setup{}
    lua require'lspconfig'.bashls.setup{}
    
    " Code navigation shortcuts
    nnoremap <silent> <leader>a  <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <F12>      <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> <F1>       <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <F2>       <cmd>lua vim.lsp.buf.rename()<CR>
    "inoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.signature_help()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.implementation()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.type_definition()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> <leader>r    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> <leader>d    <cmd>lua vim.lsp.buf.document_symbol()<CR>

    " Use omnifunc
    autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype html setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype sh,bash,zsh setlocal omnifunc=v:lua.vim.lsp.omnifunc

    " Open lsp hover menu
    inoremap <buffer><silent> <C-y><C-y> <Cmd>lua vim.lsp.buf.hover()<CR>

endif

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
else
    echo "Failed to locate win32yank.exe: /mnt/c/Windows/System32/win32yank.exe"
endif

"=== Colorscheme {{{1              --
" -----------------------------------
colorscheme onedark

"=== Help open in current window
command! -nargs=1 -complete=help H :enew | :set buftype=help | :h <args>

"=== Local Overwrite {{{1          --
" -----------------------------------
if filereadable(expand("~/.vimlocal.vim"))
    exe 'source ~/.vimlocal.vim'
endif
