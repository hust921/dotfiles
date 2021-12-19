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
set foldmethod=syntax
set foldlevelstart=99
set autochdir
set mouse=a

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
map <F6> :e ~/.config/nvim/init.vim<CR>
map <leader><F8> :lnext<CR>
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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

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
let g:ale_sign_column_always = 1
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'
let g:ale_set_highlights = 1
nmap <silent> <leader>e :ALENext<CR>
nmap <silent> <leader>E :ALEPrevious<CR>
nmap <silent> <leader>d :ALEDetail<CR>
let g:ale_linters = {'rust': ['analyzer']}

" -- NvimTree {{{2
" -----
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
nnoremap <F5> :NvimTreeToggle<CR>
nnoremap <C-S> :NvimTreeFindFile<CR>
let g:nvim_tree_width = 40 "30 by default, can be width_in_columns or 'width_in_percent%'
let g:nvim_tree_auto_ignore_ft = [ 'startify' ] "empty by default, don't auto open tree on specific filetypes.
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names

let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'justfile': 1, 'cargo.toml': 1 }

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "",
    \   'staged': "",
    \   'unmerged': "",
    \   'renamed': "ﱴ",
    \   'untracked': "+",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }



" -- Neovim LSP Settings {{{2
" -- nvim-lsp: Usefull (native nvim) lsp configurations
Plug 'neovim/nvim-lsp'
Plug 'sheerun/vim-polyglot'

" -- Neovim Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" -- Code action "lightbulb"
Plug 'kosayoda/nvim-lightbulb'

" -- Cursor line
Plug 'yamatsum/nvim-cursorline'

" -- Automatically create missing LSP colors
Plug 'folke/lsp-colors.nvim'

" -- Deoplete (dark powered neo-completion) {{{2
" -- Auto-Completion framework for neovim/vim

" -- Specific language support:
" -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
" -----
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
let g:deoplete#enable_at_startup = 1
set completeopt-=preview

" -- Deoplete (ish) Plugin: EchoDoc {{{3
" -- Displays function signatures from completions in the command line.
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'
let g:echodoc#events = ['CompleteDone']

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

" -- just / justfile syntax highlighting
Plug 'vmchale/just-vim'

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

" -- Colorschemes {{{2
" -----
Plug 'jacoborus/tender', { 'as': 'tender' }
Plug 'joshdick/onedark.vim', { 'as': 'onedark' }
Plug 'marko-cerovac/material.nvim', { 'as': 'material' }

" -- Lualine {{{2
" -----
Plug 'hoob3rt/lualine.nvim'
Plug 'arkav/lualine-lsp-progress'


" -- nvim-bufferline
" -----
Plug 'akinsho/nvim-bufferline.lua'

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
nnoremap <C-b> :Buffers<CR>
nnoremap <C-c> :Commands<CR>
nnoremap <C-t> :Tags<CR>
nnoremap <C-a> :Marks<CR>
nnoremap qa :History:<CR>
nnoremap <C-h> :History/<CR>

" RON (Rust Objection Notation) support
Plug 'ron-rs/ron.vim'

call plug#end()

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
    lua require'lspconfig'.pylsp.setup{}
    lua require'lspconfig'.html.setup{}
    lua require'lspconfig'.bashls.setup{}

    " Code navigation shortcuts
    nnoremap <silent> <leader>a  <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <F12>      <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> <F1>       <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <F2>       <cmd>lua vim.lsp.buf.rename()<CR>
    inoremap <silent> <C-Space>  <cmd>lua vim.lsp.buf.signature_help()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.implementation()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.type_definition()<CR>
    "nnoremap <silent> <xxx>  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> <leader>r    <cmd>lua vim.lsp.buf.references()<CR>
    "nnoremap <silent> <leader>d    <cmd>lua vim.lsp.buf.document_symbol()<CR>

    " Use omnifunc
    autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype html setlocal omnifunc=v:lua.vim.lsp.omnifunc
    autocmd Filetype sh,bash,zsh setlocal omnifunc=v:lua.vim.lsp.omnifunc

    " Open lsp hover menu
    inoremap <buffer><silent> <C-y><C-y> <Cmd>lua vim.lsp.buf.hover()<CR>

endif

" Set Termdebugger
packadd termdebug
autocmd Filetype rust let termdebugger="rust-gdb"
autocmd Filetype c let termdebugger="gdb"

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
let g:material_style = "darker"
set termguicolors
hi Normal ctermbg=NONE guibg=#00000
colorscheme material

lua <<EOF

-- Material Theme
require'material'.setup({
  contrast = true,
  borders = false,
  italics = {
    comments = true,
    keywords = true,
    functions = true,
    variables = false,
    strings = false
  }
})

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "haskell" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust", "regex", "css", "javascript", "json", "toml", "c_sharp", "cpp", "lua", "ruby", "python", "yaml", "bash", "html"},  -- list of language that will be disabled
  },
}

-- lualine
require('lualine').setup { options = { theme = 'material-nvim' }, sections = { lualine_b = {'branch', 'diff', { 'diagnostics', sources = {'ale'} } }, lualine_c = { 'lsp_progress' } } }

-- nvim-tree
require'nvim-tree'.setup {
  filters = {
    dotfiles = true,
    -- custom = {'.git', 'node_modules', '.cache'}
  },
  git = {
    ignore = true
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  view = {
    auto_resize = false,
  },
  lsp_diagnotics = true,
  update_cwd = true
}

-- bufferline
require('bufferline').setup{
  options = {
    separator_style = "slant",
    numbers = "none",
    indicator_icon = '',
    diagnostics = "nvim_lsp",
    show_tab_indicators = true,
    show_close_icon = false,

    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
          or (e == "warning" and " " or "" )
        s = s .. n .. sym
      end
      return s
    end,

    offsets = {
      {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "center"
      }
    }

  }
}
EOF

nnoremap <silent><F7> :BufferLineCyclePrev<CR>
nnoremap <silent><C-j> :BufferLineCyclePrev<CR>
nnoremap <silent><F8> :BufferLineCycleNext<CR>
nnoremap <silent><C-k> :BufferLineCycleNext<CR>

"=== Local Overwrite {{{1          --
" -----------------------------------
if filereadable(expand("~/.vimlocal.vim"))
    exe 'source ~/.vimlocal.vim'
endif
