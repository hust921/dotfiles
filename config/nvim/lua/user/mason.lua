-- Guard check for lsp-installer
local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

local status_ok_conf, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_conf then
	return
end


mason.setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}
mason_lspconfig.setup {
    automatic_installation = true,
    ensure_installed = {
        "bashls",
        "dockerls",
        "html",
        "jsonls",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "vimls",
        "tsserver",
    },
}

local status_ok_lsp, lspconfig = pcall(require, "lspconfig")
if not status_ok_lsp then
    return
end

lspconfig.pyright.setup({
  -- Force Pyright to consider the file's directory as the workspace root
  root_dir = function()
    return "~/dotfiles"
  end,
  settings = {
    python = {
      pythonPath = vim.fn.exepath("python3"),  -- Use the system's default Python 3 interpreter
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",          -- Optional: disable strict type-checking
      },
    },
  },
})

lspconfig.bashls.setup({})
lspconfig.dockerls.setup({})
lspconfig.html.setup({})
lspconfig.jsonls.setup({})
lspconfig.rust_analyzer.setup({})
