-- nvim-treesitter configuration
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    -- Current parsers
    "python", "cpp", "lua", "vim", "json", "toml",
    -- Add parsers for LSP servers
    "bash",      -- for bashls
    "yaml",      -- for yamlls
    "php",       -- for intelephense
    "vue",       -- for volar
    "typescript",-- for volar
    "javascript",-- for volar
    "rust",      -- for rust_analyzer
    -- Additional useful parsers
    "markdown",
    "markdown_inline",
    "html",
    "css",
  },
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "help" }, -- list of language that will be disabled
  },
}
