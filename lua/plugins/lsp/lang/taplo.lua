vim.lsp.config("taplo", {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { "Cargo.toml", ".git" },
})
vim.lsp.enable("taplo")
return {}
