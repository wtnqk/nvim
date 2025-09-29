-- intelephense configuration
-- ライセンスキーをファイルから読み込む
local licence_key = nil
local licence_file = vim.fn.expand("~/.config/intelephense/license.txt")
if vim.fn.filereadable(licence_file) == 1 then
  -- ファイルの内容を読み込む（パスではなく内容）
  licence_key = vim.fn.trim(vim.fn.readfile(licence_file)[1])
end

return {
  name = "intelephense",
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { 'composer.json', '.git' },
  format_on_save = true,
  init_options = {
    licenceKey = licence_key, -- ファイルパスではなく、キーの内容
    storagePath = vim.fn.stdpath("cache") .. "/intelephense",
  },
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
      format = {
        enable = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Force enable formatting capabilities
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
}
