-- ~/.config/nvim/lua/plugins/php_overrides.lua (または既存のconform.lua/lint.lua)

return {
  -- conform.nvim の設定を上書き
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- php_cs_fixer を無効化し、intelephense をフォーマッターとして残す
        php = { "intelephense" },
        -- もしPHPで一切フォーマットをかけたくない場合は、以下のように空のテーブルにする
        -- php = {},
      },
    },
  },

  -- nvim-lint の設定を上書き
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- phpcs を無効化し、PHPのリンターを一切使わない
        php = {},
        -- もし別のPHPリンター（例: psalm, phanなど）を使いたい場合はここに追加
        -- php = { "your_preferred_php_linter" },
      },
    },
  },
}
