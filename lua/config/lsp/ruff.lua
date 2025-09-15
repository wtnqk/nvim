return {
  filetypes = { "python" },
  cmd = { "ruff", "server" },
  format_on_save = true,  -- Enable format on save for Python files
  init_options = {
    -- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
    settings = {
      organizeImports = true,
    },
  },
}
