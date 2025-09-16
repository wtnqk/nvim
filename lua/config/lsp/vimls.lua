-- vimls configuration
return {
  name = "vimls",
  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  root_dir = function(filename)
    return vim.fs.root(filename, { ".git", ".vim" })
  end,
  format_on_save = false,  -- Disable format on save for VimScript files
  init_options = {
    diagnostic = {
      enable = true,
    },
  },
}