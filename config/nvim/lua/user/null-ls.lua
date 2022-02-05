local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
--local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  sources = {
    diagnostics.flake8,       -- Python
    diagnostics.ansiblelint,  -- Ansible playbook
    diagnostics.eslint_d,     -- Javescript
    diagnostics.jsonlint,     -- Json
    diagnostics.yamllint,     -- Yaml
    diagnostics.hadolint,     -- Dockerfile
    diagnostics.luacheck,     -- Lua
    diagnostics.markdownlint, -- Markdownlint via markdownlint-cli
    --diagnostics.shellcheck,   -- Bash, etc
    diagnostics.vint,         -- Vim-vint
    code_actions.gitsigns,    -- For Gitsigns (nvim plugin)
    code_actions.eslint_d,    -- Javescript
    --code_actions.shellcheck,  -- Bash, etc
  },
}
