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



    -- Automatically setup configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
