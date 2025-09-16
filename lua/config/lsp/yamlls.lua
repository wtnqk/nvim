-- yamlls configuration
return {
  name = "yamlls",
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_dir = function(filename)
    return vim.fs.root(filename, { ".git" })
  end,
  format_on_save = false,  -- Disable format on save for YAML files
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}