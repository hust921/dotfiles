local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

lualine.setup {
  options = { theme = 'onedark' },
  sections = {
    lualine_b = {'branch', 'diff', { 'diagnostics', sources = {'nvim_lsp'} } },
    lualine_c = { 'lsp_progress' }
  }
}
