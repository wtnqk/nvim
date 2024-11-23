-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>")
vim.keymap.set("n", "gd<Space>", ":split | lua vim.lsp.buf.definition()<CR>", bufopts)
vim.keymap.set("n", "gd<CR>", ":vsplit | lua vim.lsp.buf.definition()<CR>", bufopts)
