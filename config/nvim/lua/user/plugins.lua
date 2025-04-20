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

    -- Snippets
    use "rafamadriz/friendly-snippets" -- Library of snippets
    use { -- Snippet engine
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
    }

    -- Emmet
    use "mattn/emmet-vim"

    -- LSP
    use {
      "williamboman/mason.nvim",
      run = ":MasonUpdate",
      config = function()
        require("mason").setup()
      end,
    }

    use {
      "williamboman/mason-lspconfig.nvim",
      after = "mason.nvim",  -- ensures mason.nvim loads first
      requires = { "williamboman/mason.nvim" },  -- Ensure mason.nvim is loaded first
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "pylsp", "ts_ls", "vimls", "rust_analyzer", "jsonls", "html", "dockerls", "bashls" },
        })
      end,
    }

use {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig    = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local servers      = { "lua_ls", "pylsp", "ts_ls", "vimls", "rust_analyzer", "jsonls", "html", "dockerls", "bashls" }

    for _, srv in ipairs(servers) do
      local opts = { capabilities = capabilities }

      if srv == "pylsp" then
        opts.settings = {
          pylsp = {
            plugins = {
              -- disable flake8 entirely and import pyflakes & pycodestyle manually
              flake8 = {
                  enabled = false,
                  maxLineLength = 100
              },
              pyflakes = {
                  enabled = true,
              },
              pycodestyle = {
                enabled        = true,
                maxLineLength  = 100,   -- (optional override)
              },
            },
          },
        }
      end

      lspconfig[srv].setup(opts)
    end
  end,
}

    -- Telescope
    use "nvim-telescope/telescope.nvim" -- fuzzy finder

    -- Treesitter: Syntax highlight & more
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    }

    -- 3rd Party Syntax Highlight

    -- Autopairs
    use "windwp/nvim-autopairs"

    -- Project-nvim
    use {
        "ahmedkhalf/project.nvim",
        config = function()
        require("project_nvim").setup {
        }
        end
    }

    -- nvim-tree
    use "nvim-tree/nvim-tree.lua"

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

    -- flash / peasy-motion
    use {
      'folke/flash.nvim',
      -- Lazy load when opening files (similar to VeryLazy)
      -- Alternatively, you could use cmd = 'Flash' to load on first command,
      -- or event = 'VeryLazy' if your packer version supports it well.
      --event = {'BufReadPre', 'BufNewFile'},
      config = function()
        -- Call the setup function (passing opts if you had any)
        -- Since your original opts = {}, we pass an empty table.
        require('flash').setup({})
        require('flash').toggle()

        -- Define the key mappings using Neovim's API
        -- Note: packer doesn't have a built-in 'keys' table like lazy.nvim
        -- We use vim.keymap.set(mode, lhs, rhs, opts)

        vim.keymap.set({'n', 'x', 'o'}, ' ', function() require('flash').jump() end, { desc = 'Flash Jump' })
        vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
      end,
    }


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

    -- NeoMake
    use "neomake/neomake"

    -- Automatically setup configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
