-- Volar (Vue) Language Server configuration
return {
  filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
  cmd = { "vue-language-server", "--stdio" },
  format_on_save = false,  -- Disable format on save for Vue files by default
  init_options = {
    typescript = {
      -- Path to TypeScript lib, will be automatically detected if not set
      tsdk = "",
    },
    vue = {
      hybridMode = false,
    },
  },
  settings = {
    -- Volar settings
  },
}