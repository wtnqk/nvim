vim.lsp.config("sqls", {
  cmd = { "sqls" },
  filetypes = { "sql", "mysql" },
  root_markers = { ".git" },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})
vim.lsp.enable("sqls")
return {}
