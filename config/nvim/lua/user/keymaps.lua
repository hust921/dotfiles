local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--========== Normal ==========--
-- Resize with arrows
keymap("n", "<Up>", ":resize +1<CR>", opts)
keymap("n", "<Down>", ":resize -1<CR>", opts)
keymap("n", "<Left>", ":vertical resize -1<CR>", opts)
keymap("n", "<Right>", ":vertical resize +1<CR>", opts)

-- NvimTree
keymap("n", "<F5>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<C-s>", ":NvimTreeFindFile<CR>", opts)

-- Extra newline
keymap("n", "oo", "o<Enter>", opts)
keymap("n", "OO", "O<Esc>O<Esc>k", opts)

-- Remove search highlight
keymap("n", "<Enter>", ":noh<CR><CR>", opts)

-- Navigate buffers
keymap("n", "<C-k>", ":bnext<CR>", opts)
keymap("n", "<C-j>", ":bprevious<CR>", opts)
--keymap("n", "<C-k>", ":BufferLineCycleNext<CR>", opts)
--keymap("n", "<C-j>", ":BufferLineCyclePrev<CR>", opts)

-- Spelling
keymap("n", "<leader>c", ":setlocal spell!<CR>", opts)
keymap("n", "<leader>8", "[s", opts)
keymap("n", "<leader>9", "]s", opts)

-- FKeys
keymap("n", "<F6>", ":NvimTreeOpen<CR> :e ~/.config/nvim/init.lua<CR>:e ~/.config/nvim/lua/user/plugins.lua<CR>:e ~/.config/nvim/lua/user/keymaps.lua<CR>:e ~/.config/nvim/lua/user/options.lua<CR>", opts)
keymap("n", "<F7>", ":cnext<CR>", opts)
keymap("n", "<leader><F7>", ":cprev<CR>", opts)
keymap("n", "<F8>", ":lnext<CR>", opts)
keymap("n", "<leader><F8>", ":lprev<CR>", opts)
keymap("n", "<F9>", ":bp<CR>:bd #<CR>", opts)
keymap("n", "<F10>", ":q<CR>", opts)

-- Close current window
keymap("n", "<C-q>", ":q<CR>", opts)
keymap("i", "<C-q>", "<Esc>:q<CR>", opts)

-- LSP
keymap("n", "<F1>", ":lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<F2>", ":lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<C-S-Space>", ":lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<F8>", ':lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
keymap("n", "<leader>e", ':lua vim.diagnostic.open_float()<CR>', opts)


-- Telescope
keymap("n", "<C-l>", ":Telescope current_buffer_fuzzy_find<CR>", opts)
keymap("n", "<C-p>", ":Telescope find_files<CR>", opts)
keymap("n", "<C-g>", ":Telescope git_files<CR>", opts)
keymap("n", "<C-t>", ":Telescope tags<CR>", opts)
keymap("n", "<leader>q", ":Telescope quickfix<CR>", opts)
keymap("n", "<leader>l", ":Telescope loclist<CR>", opts)
--keymap("n", "<C-m>", ":Telescope marks<CR>", opts)
keymap("n", "<C-b>", ":Telescope buffers<CR>", opts)
keymap("n", "<C-c>", ":Telescope commands<CR>", opts)
keymap("n", "<C-h>", ":Telescope command_history<CR>", opts)
keymap("n", "qa", ":Telescope command_history<CR>", opts)
keymap("n", "<leader>j", ":Telescope jumplist<CR>", opts)
keymap("n", "<leader>0", ":Telescope spell_suggest<CR>", opts)

keymap("n", "<leader>d", ":Telescope lsp_document_symbols<CR>", opts)
--keymap("n", "<leader>d", ":Telescope lsp_dynamic_workspace_symbols<CR>", opts)
keymap("n", "<leader>a", ":Telescope lsp_code_actions<CR>", opts)
keymap("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<F12>", ":Telescope lsp_definitions<CR>", opts)
keymap("n", "<leader><F12>", ":Telescope lsp_implementations<CR>", opts)
keymap("n", "<leader>r", ":Telescope lsp_references<CR>", opts)
keymap("n", "<leader><F8>", ":Telescope diagnostics<CR>", opts)

-- GitSign
keymap('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', opts)
keymap('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', opts)
keymap('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', opts)
keymap('n', '<leader>hb', ':Gitsigns blame_line<CR>', opts)
keymap('n', '<leader>hd', ':Gitsigns diffthis<CR>', opts)

-- FloatTerm
keymap('n', '<leader>t', ':FloatermToggle<CR>', opts)
keymap('t', 'jk', [[<C-\><C-n>]], opts)
keymap('t', '<esc>', [[<C-\><C-n>]], opts)

--========== Insert ==========--
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

--========== Visual ==========--
-- Stay in indent mode
--keymap("v", "<", "<gv", opts)
--keymap("v", ">", ">gv", opts)

-- Run Column -t on visual selection
keymap("v", "<leader>t", ":!cat |column -t<CR>", opts)

--========== Visual Block ==========--
-- Run Column -t on visual selection
keymap("x", "<leader>t", ":!cat |column -t<CR>", opts)

--========== Terminal ==========--
keymap("t", "jk", "<ESC>", { silent = true })
