local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

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

-- Toggle Local & Quick list
-- TODO: Toggle quickfix/local list. - Check plugin(s)

-- FloatTerm
--keymap("n", "<leader>b", ":.FloattermSend<CR>", opts)
--keymap("n", "<leader>k", ":.FloattermSend<CR>:FloatermShow<CR>", opts)
--keymap("n", "<leader>t", ":FloatermToggle", opts)

-- NvimTree
--keymap("n", "<F5>", ":NvimTreeToggle<CR>", opts)
--keymap("n", "<C-s>", ":NvimTreeFindFile<CR>", opts)
keymap("n", "<F5>", ":Lexplore 20<CR>", opts)

-- Fzf
--keymap("n", "<C-p>", ":Files<CR>", opts)
--keymap("n", "<C-g>", ":GFiles<CR>", opts)
--keymap("n", "<C-l>", ":BLines<CR>", opts)
--keymap("n", "<C-b>", ":Buffers<CR>", opts)
--keymap("n", "<C-c>", ":Commands<CR>", opts)
--keymap("n", "<C-t>", ":Tags<CR>", opts)
--keymap("n", "<C-a>", ":Marks<CR>", opts)
--keymap("n", "qa",    ":History:<CR>", opts)
--keymap("n", "<C-h>", ":History/<CR>", opts)

-- Extra newline
keymap("n", "oo", "o<Enter>", opts)
keymap("n", "OO", "O<Esc>O<Esc>k", opts)

-- Remove search highlight
keymap("n", "<CR>", ":noh<CR><CR>", opts)

-- Navigate buffers
keymap("n", "<C-k>", ":bnext<CR>", opts)
keymap("n", "<C-j>", ":bprevious<CR>", opts)
--keymap("n", "<C-k>", ":BufferLineCycleNext<CR>", opts)
--keymap("n", "<C-j>", ":BufferLineCyclePrev<CR>", opts)

-- Spelling
keymap("n", "<leader>c", ":setlocal spell!<CR>", opts)
keymap("n", "<leader>8", "[s", opts)
keymap("n", "<leader>9", "]s", opts)
keymap("n", "<leader>0", "z=", opts)

-- FKeys
keymap("n", "<F6>", ":e ~/config/nvim/init.lua<CR>", opts)
keymap("n", "<F7>", ":cnext<CR>", opts)
keymap("n", "<leader><F7>", ":cprev<CR>", opts)
keymap("n", "<F8>", ":lnext<CR>", opts)
keymap("n", "<leader><F8>", ":lprev<CR>", opts)
keymap("n", "<F9>", ":bp<CR>:bd #<CR>", opts)
keymap("n", "<F10>", ":q<CR>", opts)

-- Close current window
keymap("n", "<C-q>", ":q<CR>", opts)
keymap("i", "<C-q>", "<Esc>:q<CR>", opts)

--========== Insert ==========--
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

--========== Visual ==========--
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Run Column -t on visual selection
keymap("v", "<leader>t", ":!cat |column -t<CR>", opts)

--========== Visual Block ==========--
-- Run Column -t on visual selection
keymap("x", "<leader>t", ":!cat |column -t<CR>", opts)

--========== Terminal ==========--
