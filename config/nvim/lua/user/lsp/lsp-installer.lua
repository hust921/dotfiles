-- Guard check for lsp-installer
local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

lsp_installer.setup({
    automatic_installation = true,
    ensure_installed = {
        "bashls",
        "dockerls",
        "html",
        "jsonls",
        "pyright",
        "rust_analyzer",
        "sumneko_lua",
        "vimls",
        "tsserver",
    }
})

require("lspconfig").pyright.setup{}
require("lspconfig").bashls.setup{}
require("lspconfig").dockerls.setup{}
require("lspconfig").html.setup{}
require("lspconfig").jsonls.setup{}
require("lspconfig").pyright.setup{}
require("lspconfig").rust_analyzer.setup{}
-- deprecated
--require("lspconfig").sumneko_lua.setup{}
require("lspconfig").vimls.setup{}
require("lspconfig").tsserver.setup{}
