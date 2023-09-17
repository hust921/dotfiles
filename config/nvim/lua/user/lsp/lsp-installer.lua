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
