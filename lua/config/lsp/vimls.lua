-- Vim Language Server configuration
return {
  filetypes = { "vim" },
  format_on_save = false,  -- Disable format on save for VimScript files
  init_options = {
    diagnostic = {
      enable = true,
    },
  },
}