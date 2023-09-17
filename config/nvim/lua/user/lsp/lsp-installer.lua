-- Guard check for lsp-installer
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server.name == "rust-analyzer" then
    local jsonls_opts = require("user.lsp.settings.rust_analyzer")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server.name == "jsonls" then
    local jsonls_opts = require("user.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

--  if server.name == "sumneko_lua" then
--    local sumneko_opts = require("user.lsp.settings.sumneko_lua")
--    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
--  end

  if server.name == "pyright" then
    local pyright_opts = require("user.lsp.settings.pyright")
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)

-- Automatically install the servers below if not installed
local lsp_installer_servers = require('nvim-lsp-installer.servers')

local servers = {
    "bashls",
    "dockerls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    --"sumneko_lua",
    "vimls",
    "tsserver",
}

-- Loop through the servers listed above.
for _, server_name in pairs(servers) do
  local server_available, server = lsp_installer_servers.get_server(server_name)
  local servers_missing = false
  if server_available then
    if not server:is_installed() then
      server:install()
      print("Installing [" .. server_name .. "] LSP server...")
      servers_missing = true
    end
    else
      print("LSP Server [" .. server_name .. "] not found...")
  end

  if servers_missing then
    require'nvim-lsp-installer'.info_window.open()
  end
end
