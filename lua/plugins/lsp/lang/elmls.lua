vim.lsp.config("elmls", {
  cmd = { "elm-language-server" },
  filetypes = { "elm" },
  root_markers = { "elm.json", ".git" },
})

vim.lsp.enable("elmls")

return {}
