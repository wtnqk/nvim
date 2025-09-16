-- ruff configuration
return {
  name = "ruff",
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_dir = function(filename)
    return vim.fs.root(filename, { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" })
  end,
  format_on_save = true,  -- Enable format on save for Python files
  init_options = {
    -- the settings can be found here: https://docs.astral.sh/ruff/editors/settings/
    settings = {
      organizeImports = true,
    },
  },
}
