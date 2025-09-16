local keymap = vim.keymap
local uv = vim.uv

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Turn the word under cursor to upper case
keymap.set("i", "<c-u>", "<Esc>viwUea")

-- Turn the current word into title case
keymap.set("i", "<c-t>", "<Esc>b~lea")

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap.set("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Quit all opened buffers
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Buffer delete is now handled by Snacks.nvim (see below)

-- Insert a blank line below or above current line (do not move the cursor),
-- see https://stackoverflow.com/a/16136133
keymap.set("n", "<space>o", "printf('m`%so<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line below",
})

keymap.set("n", "<space>O", "printf('m`%sO<ESC>``', v:count1)", {
  expr = true,
  desc = "insert line above",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier (removed H/L to avoid conflict with Shift+h/l)
-- keymap.set({ "n", "x" }, "H", "^")
-- keymap.set({ "n", "x" }, "L", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Edit and reload nvim config file quickly
keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
  silent = true,
  desc = "open init.lua",
})

keymap.set("n", "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Always use very magic mode for searching
-- keymap.set("n", "/", [[/\v]])

-- Search in selected region
-- xnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Remove trailing whitespace characters
keymap.set("n", "<leader><space>", "<cmd>StripTrailingWhitespace<cr>", { desc = "remove trailing space" })

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Toggle cursor column
keymap.set("n", "<leader>cl", "<cmd>call utils#ToggleCursorCol()<cr>", { desc = "toggle cursor column" })

-- Move current line up and down
keymap.set("n", "<A-k>", '<cmd>call utils#SwitchLine(line("."), "up")<cr>', { desc = "move line up" })
keymap.set("n", "<A-j>", '<cmd>call utils#SwitchLine(line("."), "down")<cr>', { desc = "move line down" })

-- Move current visual-line selection up and down
keymap.set("x", "<A-k>", '<cmd>call utils#MoveSelection("up")<cr>', { desc = "move selection up" })

keymap.set("x", "<A-j>", '<cmd>call utils#MoveSelection("down")<cr>', { desc = "move selection down" })

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Go to a certain buffer
keymap.set("n", "gb", '<cmd>call buf_utils#GoToBuffer(v:count, "forward")<cr>', {
  desc = "go to buffer (forward)",
})
keymap.set("n", "gB", '<cmd>call buf_utils#GoToBuffer(v:count, "backward")<cr>', {
  desc = "go to buffer (backward)",
})

-- Buffer navigation with Shift+h/l
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Switch windows
keymap.set("n", "<left>", "<c-w>h")
keymap.set("n", "<Right>", "<C-W>l")
keymap.set("n", "<Up>", "<C-W>k")
keymap.set("n", "<Down>", "<C-W>j")

-- Window navigation with Ctrl+h/j/k/l
keymap.set("n", "<C-h>", "<C-W>h", { desc = "Go to left window" })
keymap.set("n", "<C-l>", "<C-W>l", { desc = "Go to right window" })
keymap.set("n", "<C-k>", "<C-W>k", { desc = "Go to upper window" })
keymap.set("n", "<C-j>", "<C-W>j", { desc = "Go to lower window" })

-- Text objects for URL
keymap.set({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<cr>", { desc = "URL text object" })

-- Text objects for entire buffer
keymap.set({ "x", "o" }, "iB", ":<C-U>call text_obj#Buffer()<cr>", { desc = "buffer text object" })

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

keymap.set("n", "<leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()
  if timer == nil then
    return
  end

  timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      vim.cmd([[
      set cursorcolumn!
      set cursorline!
    ]])

      if cnt == blink_times then
        timer:close()
      end

      cnt = cnt + 1
    end)
  )
end, { desc = "show cursor" })

keymap.set("n", "q", function()
  vim.print("q is remapped to Q in Normal mode!")
end)
keymap.set("n", "Q", "q", {
  desc = "Record macro",
})

keymap.set("n", "<Esc>", function()
  vim.cmd("fclose!")
end, {
  desc = "close floating win",
})

-- Snacks.nvim keymaps (following README.org conventions)
-- Defer Snacks keymaps until after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local snacks_ok, snacks = pcall(require, "snacks")
    if not snacks_ok then
      vim.notify("Snacks not available for keymaps", vim.log.levels.WARN)
      return
    end

    -- Core Features (from README.org Section 17)
    keymap.set("n", "<leader>.", function()
      snacks.scratch()
    end, { desc = "Toggle scratch buffer" })
    keymap.set("n", "<leader>S", function()
      snacks.scratch.select()
    end, { desc = "Select scratch buffer" })
    keymap.set("n", "<leader>n", function()
      snacks.notifier.show_history()
    end, { desc = "Show notification history" })
    keymap.set("n", "<leader>un", function()
      snacks.notifier.hide()
    end, { desc = "Dismiss all notifications" })

    -- File/Buffer Pickers (README.org Section 17)
    keymap.set("n", "<leader>,", function()
      snacks.picker.buffers()
    end, { desc = "Buffers" })
    keymap.set("n", "<leader>/", function()
      snacks.picker.grep()
    end, { desc = "Grep (root)" })
    keymap.set("n", "<leader>:", function()
      snacks.picker.command_history()
    end, { desc = "Command history" })

    -- Use FFF.nvim for file finding (faster and smarter)
    keymap.set("n", "<leader><Space>", "<cmd>FFFFind<cr>", { desc = "Find files (FFF)" })
    keymap.set("n", "ff", "<cmd>FFFFind<cr>", { desc = "Find files (FFF)" })
    keymap.set("n", "<leader>ff", function()
      vim.cmd("FFFFind " .. vim.fn.fnamemodify(vim.fn.finddir(".git", ";"), ":h"))
    end, { desc = "Find files in git root (FFF)" })

    keymap.set("n", "<leader>fb", function()
      snacks.picker.buffers()
    end, { desc = "Buffers" })

    keymap.set("n", "<leader>fr", function()
      snacks.picker.recent()
    end, { desc = "Recent files" })

    -- Git Pickers & LazyGit (README.org Git section)
    keymap.set("n", "<leader>gc", function()
      snacks.picker.git_commits()
    end, { desc = "Git commits" })
    keymap.set("n", "<leader>gs", function()
      snacks.picker.git_status()
    end, { desc = "Git status" })
    -- LazyGit
    keymap.set("n", "<leader>gg", function()
      snacks.lazygit()
    end, { desc = "LazyGit" })
    keymap.set("n", "<leader>gG", function()
      snacks.lazygit.log_file()
    end, { desc = "LazyGit (file)" })
    keymap.set("n", "<leader>gf", function()
      snacks.lazygit.log()
    end, { desc = "LazyGit filter" })
    keymap.set({ "n", "v" }, "<leader>gb", function()
      snacks.gitbrowse()
    end, { desc = "Git browse" })

    -- Search pickers (README.org Search section)
    keymap.set("n", "<leader>sb", function()
      snacks.picker.lines()
    end, { desc = "Buffer lines" })
    keymap.set("n", "<leader>sg", function()
      snacks.picker.grep()
    end, { desc = "Grep (root)" })
    keymap.set("n", "<leader>sG", function()
      snacks.picker.grep { cwd = vim.fn.expand("%:p:h") }
    end, { desc = "Grep (cwd)" })
    keymap.set("n", "<leader>sw", function()
      snacks.picker.grep { search = vim.fn.expand("<cword>") }
    end, { desc = "Word (root)" })
    keymap.set("n", "<leader>sh", function()
      snacks.picker.help()
    end, { desc = "Help pages" })
    keymap.set("n", "<leader>sk", function()
      snacks.picker.keymaps()
    end, { desc = "Keymaps" })
    keymap.set("n", "<leader>ss", function()
      snacks.picker.lsp_symbols()
    end, { desc = "LSP document symbols" })
    keymap.set("n", "<leader>sS", function()
      snacks.picker.lsp_workspace_symbols()
    end, { desc = "LSP workspace symbols" })

    -- LSP pickers are now defined in a separate autocmd to handle hover windows

    -- LSP info commands
    keymap.set("n", "<leader>li", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      if #clients == 0 then
        vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
        return
      end
      local info = string.format("LSP Clients for buffer %d:\n", bufnr)
      for _, client in ipairs(clients) do
        info = info .. string.format("• %s (id: %d)\n", client.name, client.id)
        info = info .. string.format("  Root: %s\n", client.config.root_dir or "N/A")
      end
      vim.notify(info, vim.log.levels.INFO)
    end, { desc = "LSP Info" })

    keymap.set("n", "<leader>ll", function()
      vim.cmd("tabnew " .. vim.lsp.get_log_path())
    end, { desc = "LSP Log" })
    keymap.set("n", "<leader>lr", function()
      vim.lsp.stop_client(vim.lsp.get_clients())
      vim.cmd("edit")
      vim.notify("LSP servers restarted", vim.log.levels.INFO)
    end, { desc = "LSP Restart" })
    keymap.set("n", "<leader>lh", "<cmd>checkhealth lsp<cr>", { desc = "LSP Health" })

    -- Diagnostic navigation keymaps
    keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
    keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
    -- Diagnostic hover is handled by hover.nvim with K/S-K

    keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Add diagnostics to location list" })

    -- Explorer (README.org Explorer/Files section)
    keymap.set("n", "<leader>e", function()
      snacks.explorer()  -- This already acts as toggle
    end, { desc = "Explorer neo-tree (cwd)" })
    keymap.set("n", "<leader>E", function()
      snacks.explorer.open()
    end, { desc = "Explorer neo-tree (root)" })
    keymap.set("n", "<leader>be", function()
      snacks.picker.buffers()
    end, { desc = "Buffer explorer" })
    keymap.set("n", "<leader>ge", function()
      snacks.picker.git_status()
    end, { desc = "Git explorer" })

    -- Buffer management (README.org Buffer Management section)
    keymap.set("n", "<leader>bd", function()
      snacks.bufdelete()
    end, { desc = "Delete buffer" })
    keymap.set("n", "<leader>bD", function()
      snacks.bufdelete.delete { force = true }
    end, { desc = "Delete buffer and window" })
    keymap.set("n", "<leader>bo", function()
      snacks.bufdelete.other()
    end, { desc = "Delete other buffers" })
    -- Keep existing shortcuts for compatibility
    keymap.set("n", [[\d]], function()
      snacks.bufdelete()
    end, { desc = "Delete buffer" })
    keymap.set("n", [[\D]], function()
      snacks.bufdelete.other()
    end, { desc = "Delete other buffers" })

    -- Rename (README.org Code/LSP section)
    keymap.set("n", "<leader>cR", function()
      snacks.rename.rename_file()
    end, { desc = "Rename file" })

    -- Terminal (README.org Terminal section)
    -- Floating terminal (just toggle, uses count for multiple terminals)
    keymap.set({ "n", "t" }, "<C-\\>", function()
      snacks.terminal.toggle(vim.o.shell, { win = { position = "float" } })
    end, { desc = "Terminal (float)" })

    -- Normal terminal in split (can create new with leader-tn)
    keymap.set({ "n", "t" }, "<C-/>", function()
      snacks.terminal.toggle()
    end, { desc = "Toggle terminal" })
    keymap.set({ "n", "t" }, "<C-_>", function()
      snacks.terminal.toggle()
    end, { desc = "which_key_ignore" })

    -- Create new terminal in split
    keymap.set("n", "<leader>tn", function()
      snacks.terminal.open()
    end, { desc = "New terminal (split)" })

    -- Terminal list
    keymap.set("n", "<leader>tl", function()
      local terminals = snacks.terminal.list()
      if #terminals == 0 then
        vim.notify("No active terminals", vim.log.levels.INFO)
      else
        local info = "Active Terminals:\n"
        for i, term in ipairs(terminals) do
          info = info .. string.format("%d. Terminal %d\n", i, term.id or i)
        end
        vim.notify(info, vim.log.levels.INFO)
      end
    end, { desc = "List terminals" })

    -- Zen mode
    keymap.set("n", "<leader>z", function()
      snacks.zen()
    end, { desc = "Toggle Zen Mode" })
    keymap.set("n", "<leader>Z", function()
      snacks.zen.zoom()
    end, { desc = "Toggle Zoom" })
  end,
})

-- Hover.nvim keymaps (separate autocmd to prevent failure cascade)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local hover_ok, hover = pcall(require, "hover")
    if hover_ok then
      -- K to open hover or enter if already open
      keymap.set("n", "K", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local hover_win = vim.b[bufnr].hover_preview
        if hover_win and vim.api.nvim_win_is_valid(hover_win) then
          -- Hover is already open, enter it
          hover.enter()
        else
          -- Hover is not open, open it
          hover.open()
        end
      end, { desc = "hover.nvim (open/enter)" })

      -- Tab/S-Tab for hover source switching
      keymap.set("n", "<Tab>", function()
        hover.switch("next")
      end, { desc = "Next hover source" })
      keymap.set("n", "<S-Tab>", function()
        hover.switch("previous")
      end, { desc = "Previous hover source" })
    end
  end,
})

-- Override gd, gr, gI globally to handle hover windows
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local snacks_ok, snacks = pcall(require, "snacks")
    if not snacks_ok then
      return
    end

    -- Override the global LSP navigation keymaps to handle hover windows
    keymap.set("n", "gd", function()
      local winid = vim.api.nvim_get_current_win()
      local win_config = vim.api.nvim_win_get_config(winid)

      -- If we're in a floating window (hover), close it first
      if win_config.relative ~= "" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.schedule(function()
          snacks.picker.lsp_definitions()
        end)
      else
        snacks.picker.lsp_definitions()
      end
    end, { desc = "LSP definitions" })

    keymap.set("n", "gr", function()
      local winid = vim.api.nvim_get_current_win()
      local win_config = vim.api.nvim_win_get_config(winid)

      if win_config.relative ~= "" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.schedule(function()
          snacks.picker.lsp_references()
        end)
      else
        snacks.picker.lsp_references()
      end
    end, { desc = "LSP references" })

    keymap.set("n", "gI", function()
      local winid = vim.api.nvim_get_current_win()
      local win_config = vim.api.nvim_win_get_config(winid)

      if win_config.relative ~= "" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.schedule(function()
          snacks.picker.lsp_implementations()
        end)
      else
        snacks.picker.lsp_implementations()
      end
    end, { desc = "LSP implementations" })

    keymap.set("n", "gy", function()
      local winid = vim.api.nvim_get_current_win()
      local win_config = vim.api.nvim_win_get_config(winid)

      if win_config.relative ~= "" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        vim.schedule(function()
          snacks.picker.lsp_type_definitions()
        end)
      else
        snacks.picker.lsp_type_definitions()
      end
    end, { desc = "LSP type definitions" })
  end,
})
