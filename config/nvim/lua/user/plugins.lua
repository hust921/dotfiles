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

-- Create snapshot (with autotmatic naming) before running PackerSync
---- Autocommand to reload neovim whenever you save plugins.lua
--vim.cmd [[
--    augroup packer_user_config
--        autocmd!
--        autocmd BufWritePost plugins.lua source <afile> | PackerSync
--    augroup end
--]]

-- Guard to not blow up with errors, if packer fails
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Packer's own configuration
packer.init {
    snapshot = nil,
    snapshot_path = fn.stdpath('config') .. '/packersnapshot',

    ---- Have packer use a popup window
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
    use "hrsh7th/nvim-cmp"          -- The completion plugin
    use "hrsh7th/cmp-nvim-lsp"      -- LSP completion
    use "hrsh7th/cmp-buffer"        -- Buffer completion
    use "hrsh7th/cmp-path"          -- Path completion
    use "saadparwaiz1/cmp_luasnip"  -- Snippet completion
    use { "hrsh7th/cmp-nvim-lua",   -- Lua completion
        ft = { 'lua' },
    }
    use { "saecki/crates.nvim",     -- Cargo.toml completion
        event = { "BufRead Cargo.toml" },
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function()
            require('crates').setup()
        end,
    }
    use "ray-x/cmp-treesitter"      -- Treesitter nodes as completion
    use { "tamago324/cmp-zsh",      -- Zsh completion
        ft = { 'zsh' }
    }

    -- LSP Signature
    use {
        'ray-x/lsp_signature.nvim',
        config = function()
            require('lsp_signature').setup()
        end
    }


    -- Null-LS: Formatting, Linting & more passed to LSP
    use "jose-elias-alvarez/null-ls.nvim"

    -- Snippets
    use "L3MON4D3/LuaSnip"             -- Snippet engine
    use "rafamadriz/friendly-snippets" -- Library of snippets

    -- Emmet
    use "mattn/emmet-vim"


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

    -- 3rd Party Syntax Highlight
    use "vmchale/just-vim"

    -- Autopairs
    use "windwp/nvim-autopairs"

    -- Gitsigns: For staging, blaming, viewing changes, etc
    use "lewis6991/gitsigns.nvim"

    -- Nvim-tree
    use "kyazdani42/nvim-tree.lua"

    -- Project-nvim
    use {
        "ahmedkhalf/project.nvim",
        config = function()
        require("project_nvim").setup {
        }
        end
    }

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

    -- tpope
    use "tpope/vim-surround"
    use "tpope/vim-repeat"

    -- Markdown
    use {
        "iamcco/markdown-preview.nvim",
        run = ":call mkdp#util#install()",
        ft = { 'markdown' },
    }

    -- Alpha "Startify"
    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    -- Whichkey
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup { }
        end
    }

    -- NeoMake
    use "neomake/neomake"

    -- Automatically setup configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
