require 'user.options'
require 'user.keymaps'
require 'user.plugins'
require 'user.completion'
require 'user.lsp'
require 'user.treesitter'
require 'user.autopairs'
require 'user.gitsigns'
require 'user.nvim-tree'

-- Set Colorscheme
local colorscheme = "one"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end
