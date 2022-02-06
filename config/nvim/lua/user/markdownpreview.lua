vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_refresh_slow = 0 -- Update only when save/leave insert
vim.g.mkdp_echo_preview_url = 1

vim.g.mkdp_browserfunc = 'Xdgopen'
vim.api.nvim_exec([[
    function! Xdgopen(url) abort
        let g:mkdp_browser_open_already = 1
        if executable('xdg-open')
            execute '!xdg-open ' . a:url
        else
            echoerr "xdg-open command not available!"
        endif
    endfunction
]], false)

vim.api.nvim_exec([[
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
]], false)
