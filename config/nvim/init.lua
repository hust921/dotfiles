local lsp = require'nvim_lsp'

local on_attach = function(client)
  require'diagnostic'.on_attach()
  require'completion'.on_attach({
      sorter = 'alphabet',
      matcher = {'exact', 'fuzzy'}
    })
end

lsp.vimls.setup{
  on_attach = on_attach;
}

lsp.pyls.setup{
  on_attach = on_attach;
  settings = {
    pyls = {
      plugins = {
        pycodestyle = { enabled = false; },
      }
    }
  }
}

-- lsp.pyls_ms.setup{
  -- on_attach = require'on_attach'.on_attach;
-- }

lsp.rust_analyzer.setup{
  on_attach = on_attach;
}
