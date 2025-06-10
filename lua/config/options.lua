-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_blink_main = true
-- カーソル行を強調
vim.api.nvim_win_set_option(0, "cursorline", true)
-- 標識のためのスペースを最左列に設ける
vim.api.nvim_win_set_option(0, "signcolumn", "yes:1")
-- テキストの折り返しを無効化
vim.api.nvim_win_set_option(0, "wrap", false)
-- 非表示文字の可視化
vim.api.nvim_win_set_option(0, "list", true)
-- 指定したカラム列を強調
-- vim.api.nvim_win_set_option(0, 'colorcolumn', '100')

-- 相対行番号を無効化
vim.o.relativenumber = false
-- PHPのLSPをIntelephenseに設定
vim.g.lazyvim_php_lsp = "intelephense"

-- フォーマットを自動適用しない
vim.g.format_on_save = false
vim.g.lazyvim_picker = "snacks"
