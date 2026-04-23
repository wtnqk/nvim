vim.lsp.config("copilot", {
  cmd = { "copilot-language-server", "--stdio" },
  filetypes = { "*" },
  root_markers = { ".git" },
  init_options = { editorInfo = { name = "Neovim", version = vim.version().build } },
})

vim.lsp.enable("copilot")

return {}
