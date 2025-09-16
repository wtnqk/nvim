-- bashls configuration
return {
  name = "bashls",
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_dir = function(filename)
    return vim.fs.root(filename, { ".git" })
  end,
  format_on_save = false,  -- Disable format on save for Bash files
}