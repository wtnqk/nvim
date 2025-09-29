-- LSP設定ファイルで
return {
  name = "vuels",
  cmd = { "vls" },
  filetypes = { "vue" },
  init_options = {
    config = {
      vetur = {
        completion = {
          autoImport = true,
          tagCasing = "kebab"
        },
        validation = {
          template = true,
          style = true,
          script = true
        }
      }
    }
  },
  capabilities = {
    -- タイムアウト時間を延長
    workspace = {
      configuration = true,
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  -- タイムアウト設定
  flags = {
    debounce_text_changes = 150,
  },
}
