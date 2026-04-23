vim.lsp.config("terraformls", {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".terraform.lock.hcl", ".git" },
})
vim.lsp.enable("terraformls")
return {}
