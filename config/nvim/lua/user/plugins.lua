local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim.."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand to reload neovim whenever you save plugins.lua
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Guard to not blow up with errors, if packer fails
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border= "rounded" }
        end,
    },
}

-- Install plugins here
return packer.startup(function(use)
    -- Plugins
    use "wbthomason/packer.nvim" -- Packer manage itself
    use "nvim-lua/popup.nvim"    -- Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"  -- Useful lua functions

    -- Completion (cmp)
    use "hrsh7th/nvim-cmp"         -- The completion plugin
    use "hrsh7th/cmp-nvim-lsp"     -- LSP completions
    use "hrsh7th/cmp-buffer"       -- Buffer completions
    use "hrsh7th/cmp-path"         -- Path completions
    use "hrsh7th/cmp-cmdline"      -- Cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- Snippet completions
    use "hrsh7th/cmp-nvim-lua"     -- Lua completions

    -- Null-LS: Formatting, Linting & more passed to LSP
    use "jose-elias-alvarez/null-ls.nvim"

    -- Snippets
    use "L3MON4D3/LuaSnip"             -- Snippet engine
    use "rafamadriz/friendly-snippets" -- Library of snippets

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple lsp server installer

    -- Telescope
    use "nvim-telescope/telescope.nvim" -- fuzzy finder

    -- Treesitter: Syntax highlight & more
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    }

    -- Autopairs
    use "windwp/nvim-autopairs"

    -- Gitsigns: For staging, blaming, viewing changes, etc
    use "lewis6991/gitsigns.nvim"

    -- Nvim-tree
    use "kyazdani42/nvim-tree.lua"

    -- Bufferline
    use "kyazdani42/nvim-web-devicons"
    use "akinsho/bufferline.nvim"

    -- Lualine
    use "nvim-lualine/lualine.nvim"
    use "arkav/lualine-lsp-progress"

    -- Onedark colorscheme Theme
    use "navarasu/onedark.nvim"

    -- Floaterm
    use "voldikss/vim-floaterm"

    -- Alpha "Startify"
    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.config)
        end
    }

    -- Automatically setup configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
