vim.lsp.config("ansiblels", {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", "site.yml", "playbook.yml", ".git" },
})
vim.lsp.enable("ansiblels")
return {}
