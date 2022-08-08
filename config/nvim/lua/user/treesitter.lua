local configs = require("nvim-treesitter.configs")
configs.setup {
  ensure_installed = { "bash", "c", "c_sharp", "cmake", "comment", "cpp", "css", "devicetree", "dockerfile", "dot", "go", "haskell", "help", "html", "http", "java", "javascript", "json", "latex", "lua", "make", "markdown", "markdown_inline", "ninja", "python", "regex", "rust", "sql", "toml", "typescript", "vim", "yaml" },
  sync_install = false, 
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopair = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,

  },
  indent = { enable = true, disable = { "yaml" } },
}
