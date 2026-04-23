vim.lsp.config("erlangls", {
  cmd = { "erlang_ls" },
  filetypes = { "erlang" },
  root_markers = { "rebar.config", "erlang.mk", ".git" },
})
vim.lsp.enable("erlangls")
return {}
