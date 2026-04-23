vim.lsp.config("sqls", {
  cmd = { "sqls" },
  filetypes = { "sql", "mysql" },
  root_markers = { ".git" },
})
vim.lsp.enable("sqls")
return {}
