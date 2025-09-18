local toggleterm = require("toggleterm")

toggleterm.setup({
  -- Size settings
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = nil, -- We'll set custom mappings below
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "horizontal", -- 'vertical' | 'horizontal' | 'tab' | 'float'
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = "curved",
    width = function()
      return math.floor(vim.o.columns * 0.9)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.9)
    end,
    winblend = 3,
  },
  winbar = {
    enabled = false,
  },
})

-- Terminal keymaps
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- Set keymaps on terminal open
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

-- Custom terminals
local Terminal = require('toggleterm.terminal').Terminal

-- Floating terminal
local float_term = Terminal:new({
  direction = "float",
  count = 99, -- Use a different count to keep it separate
})

-- Keybindings (matching current setup)
-- C-\ for floating terminal
vim.keymap.set({ "n", "t" }, "<C-\\>", function()
  float_term:toggle()
end, { desc = "Terminal (float)" })

-- C-/ for normal terminal (horizontal split by default)
vim.keymap.set({ "n", "t" }, "<C-/>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle terminal" })
-- Also map C-_ which is what some terminals send for C-/
vim.keymap.set({ "n", "t" }, "<C-_>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "which_key_ignore" })

-- New terminal
vim.keymap.set("n", "<leader>tn", function()
  local count = vim.v.count > 0 and vim.v.count or 1
  vim.cmd(count .. "ToggleTerm")
end, { desc = "New terminal (split)" })

-- List terminals
vim.keymap.set("n", "<leader>tl", function()
  local terms = require("toggleterm.terminal").get_all()
  if #terms == 0 then
    vim.notify("No active terminals", vim.log.levels.INFO)
  else
    local info = "Active Terminals:\n"
    for _, term in ipairs(terms) do
      local status = term:is_open() and "open" or "hidden"
      info = info .. string.format("%d. Terminal %d (%s) - %s\n",
        term.id, term.id, term.direction, status)
    end
    vim.notify(info, vim.log.levels.INFO)
  end
end, { desc = "List terminals" })

-- LazyGit terminal (optional)
local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- Function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- Function to run on closing the terminal
  on_close = function()
    vim.cmd("startinsert!")
  end,
})

-- LazyGit toggle (optional - can be removed if using Snacks lazygit)
vim.keymap.set("n", "<leader>gg", function()
  lazygit:toggle()
end, { desc = "LazyGit" })