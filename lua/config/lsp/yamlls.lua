-- YAML Language Server configuration
return {
  filetypes = { "yaml", "yml" },
  format_on_save = false,  -- Disable format on save for YAML files
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
}