vim.lsp.config("elixirls", {
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex" },
  root_markers = { "mix.exs", ".git" },
})
vim.lsp.enable("elixirls")
return {}
