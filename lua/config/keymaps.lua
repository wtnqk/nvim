local map = vim.keymap.set

-- Make Util available globally
_G.Util = require("util")

-- Better up/down navigation with wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize windows with Ctrl + arrow keys
map("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Better search navigation
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous Search Result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" })

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Buffer management
map("n", "<Leader>bn", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<Leader>bp", "<Cmd>bNext<CR>", { desc = "Previous Buffer" })
map("n", "<Leader>bN", "<Cmd>enew<CR>", { desc = "New Empty Buffer" })
map("n", "<Leader>bs", "<Cmd>w<CR>", { desc = "Save Buffer" })
map("n", "<Leader>bd", "<Cmd>bdelete<CR>", { desc = "Delete Buffer" })
map("n", "<Leader>bD", "<Cmd>bd<CR>", { desc = "Delete Buffer and Window" })

-- Add empty lines above/below
map("n", "[ ", "v:lua.Util.keymaps.put_empty_line(v:true)", { expr = true, desc = "Add Empty Line Above" })
map("n", "] ", "v:lua.Util.keymaps.put_empty_line(v:false)", { expr = true, desc = "Add Empty Line Below" })

-- Quickfix navigation
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Diagnostic navigation
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Previous Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Previous Warning" })

-- File path yanking
map("n", "<Leader>fy", Util.keymaps.yank_relative_path, { desc = "Yank Relative Path" })
map("n", "<Leader>fY", Util.keymaps.yank_full_path, { desc = "Yank Full Path" })

-- Clear search highlighting
map({ "i", "n" }, "<Esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Escape and Clear Hlsearch" })
map(
  "n",
  "<Leader>ur",
  "<Cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Comment shortcuts
map("n", "gco", "o<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add Comment Below" })
map("n", "gcO", "O<Esc>Vcx<Esc><Cmd>normal gcc<CR>fxa<BS>", { desc = "Add Comment Above" })

-- Lazy
map("n", "<Leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })

-- Quit all
map("n", "<Leader>qq", "<Cmd>qa<CR>", { desc = "Quit All" })

-- Format
map({ "n", "v" }, "<Leader>cf", function()
  Util.format.run({ force = true })
end, { desc = "Format" })

-- Line diagnostics
map("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- Window management
map("n", "<Leader>wc", "<C-w>c", { desc = "Close a Window" })
map("n", "<Leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
map("n", "<Leader>|", "<C-w>v", { desc = "Split Window Right", remap = true })
map("n", "<Leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })

-- Tab management
map("n", "<Leader><Tab><Tab>", "<Cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<Leader><Tab>[", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
map("n", "<Leader><Tab>]", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
map("n", "<Leader><Tab>c", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<Leader><Tab>f", "<Cmd>tabfirst<CR>", { desc = "First Tab" })
map("n", "<Leader><Tab>l", "<Cmd>tablast<CR>", { desc = "Last Tab" })
map("n", "<Leader><Tab>o", "<Cmd>tabonly<CR>", { desc = "Close Other Tabs" })
map("n", "<Leader><Tab>q", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<Leader><Tab>d", "<Cmd>tabclose<CR>", { desc = "Close Tab" })

-- Terminal shortcuts (basic implementation)
map("n", "<Leader>fT", "<Cmd>terminal<CR>", { desc = "Terminal (cwd)" })
map("n", "<Leader>ft", function()
  vim.cmd("terminal")
  vim.cmd("cd " .. Util.root())
end, { desc = "Terminal (root)" })
map("n", "<C-/>", function()
  vim.cmd("terminal")
  vim.cmd("cd " .. Util.root())
end, { desc = "Terminal (root)" })
map("n", "<C-_>", function()
  vim.cmd("terminal")
  vim.cmd("cd " .. Util.root())
end, { desc = "which_key_ignore" })
map("t", "<C-/>", "<Cmd>close<CR>", { desc = "Hide Terminal" })
map("t", "<C-_>", "<Cmd>close<CR>", { desc = "which_key_ignore" })

-- Toggle options (basic implementation without Snacks)
map("n", "<Leader>us", function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify("Spell: " .. (vim.opt.spell:get() and "on" or "off"))
end, { desc = "Toggle Spelling" })
map("n", "<Leader>uw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  vim.notify("Wrap: " .. (vim.opt.wrap:get() and "on" or "off"))
end, { desc = "Toggle Wrap" })
map("n", "<Leader>uL", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
  vim.notify("Relative Number: " .. (vim.opt.relativenumber:get() and "on" or "off"))
end, { desc = "Toggle Relative Number" })
map("n", "<Leader>ul", function()
  vim.opt.number = not vim.opt.number:get()
  vim.notify("Line Numbers: " .. (vim.opt.number:get() and "on" or "off"))
end, { desc = "Toggle Line Numbers" })
map("n", "<Leader>ud", function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    vim.notify("Diagnostics: on")
  else
    vim.diagnostic.disable()
    vim.notify("Diagnostics: off")
  end
end, { desc = "Toggle Diagnostics" })
map("n", "<Leader>uc", function()
  local conceallevel = vim.opt.conceallevel:get()
  vim.opt.conceallevel = conceallevel == 0 and 2 or 0
  vim.notify("Conceal Level: " .. vim.opt.conceallevel:get())
end, { desc = "Toggle Conceal Level" })

-- Format toggle
map("n", "<Leader>uf", function()
  Util.format.toggle()
end, { desc = "Toggle Auto Format (Global)" })
map("n", "<Leader>uF", function()
  Util.format.toggle(true)
end, { desc = "Toggle Auto Format (Buffer)" })

-- Inlay hints toggle (if available)
if vim.lsp.inlay_hint then
  map("n", "<Leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.notify("Inlay Hints: " .. (vim.lsp.inlay_hint.is_enabled() and "on" or "off"))
  end, { desc = "Toggle Inlay Hints" })
end

-- Snippet navigation (for Neovim 0.11+)
if vim.fn.has("nvim-0.11") == 1 then
  map("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<Cmd>lua vim.snippet.jump(1)<CR>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  map({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<Cmd>lua vim.snippet.jump(-1)<CR>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end