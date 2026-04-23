vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "build.zig", "build.zig.zon", ".git" },
})
vim.lsp.enable("zls")
return {}
