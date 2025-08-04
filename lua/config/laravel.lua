local M = {}

local function goto_lc()
  local l = vim.api.nvim_get_current_line()
  local c, m = l:match("'([%w\\]+)@(%w+)'")

  if not c then
    return
  end

  local path = "app/Http/Controllers/" .. c:gsub("\\", "/") .. ".php"

  if vim.fn.filereadable(path) == 1 then
    vim.cmd("edit +/function\\ " .. m .. " " .. path)
    vim.cmd("normal! zz")
  else
    local cn = c:match("([%w]+)$")
    vim.g.laravel_method = m
    vim.cmd("Rg class " .. cn)
  end
end

local function find_r()
  local cf = vim.fn.expand("%:t:r")
  local m = vim.fn.expand("<cword>")

  if cf == "" or m == "" then
    vim.notify("Could not determine controller or method name", vim.log.levels.WARN)
    return
  end

  local p = cf .. "@" .. m
  local c = 'rg --line-number --no-heading "' .. p .. '" routes/'
  local rs = vim.fn.systemlist(c)

  local fr = {}
  for _, r in ipairs(rs) do
    if r:match(p .. "'") or r:match(p .. '"') then
      table.insert(fr, r)
    end
  end

  if #fr == 0 then
    vim.notify("No routes found for " .. p, vim.log.levels.INFO)
    return
  elseif #fr == 1 then
    local rt = fr[1]
    local f, l = rt:match("([^:]+):(%d+):")

    if f and l then
      vim.cmd("edit +" .. l .. " " .. f)
      vim.cmd("normal! zz")
    else
      vim.notify("Could not parse result", vim.log.levels.ERROR)
    end
  else
    -- 複数の結果がある場合はquickfixリストに表示
    local qf_l = {}
    for _, r in ipairs(fr) do
      local f, l, text = r:match("([^:]+):(%d+):(.+)")
      if f then
        table.insert(qf_l, {
          filename = f,
          lnum = tonumber(l),
          text = vim.trim(text or ""),
        })
      end
    end
    vim.fn.setqflist(qf_l)
    vim.cmd("copen")
    vim.notify("Multiple routes found. Select from quickfix list.", vim.log.levels.INFO)
  end
end

local function goto_lv()
  local l = vim.api.nvim_get_current_line()

  local ps = {
    "view%s*%(%s*['\"]([%w%.%-_/]+)['\"]",
    "View::make%s*%(%s*['\"]([%w%.%-_/]+)['\"]",
    "@extends%s*%(%s*['\"]([%w%.%-_/]+)['\"]",
    "@include%s*%(%s*['\"]([%w%.%-_/]+)['\"]",
  }

  local view = nil
  for _, p in ipairs(ps) do
    view = l:match(p)
    if view then
      break
    end
  end

  if view then
    view = view:gsub("^/", "")
    local v_path = "resources/views/" .. view:gsub("%.", "/") .. ".blade.php"

    if vim.fn.filereadable(v_path) == 1 then
      vim.cmd("edit " .. v_path)
    else
      local alt_path = "resources/views/" .. view:gsub("%.", "/") .. ".php"
      if vim.fn.filereadable(alt_path) == 1 then
        vim.cmd("edit " .. alt_path)
      else
        vim.notify("View not found: " .. v_path, vim.log.levels.WARN)
      end
    end
  else
    vim.notify("No view reference found in this line", vim.log.levels.INFO)
  end
end

local function setup_auto_jump()
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.php",
    callback = function()
      if vim.g.laravel_method then
        vim.defer_fn(function()
          if vim.g.laravel_method then
            vim.fn.search("function " .. vim.g.laravel_method, "w")
            vim.cmd("normal! zz")
            vim.g.laravel_method = nil
          end
        end, 50)
      end
    end,
  })
end

function M.setup()
  vim.keymap.set("n", "ld", function()
    local l = vim.api.nvim_get_current_line()

    if l:match("'[%w\\]+@%w+'") then
      goto_lc()
    else
      vim.lsp.buf.definition()
    end
  end, { desc = "Go to definition" })

  vim.keymap.set("n", "lr", find_r, { desc = "Find route for this controller method" })

  vim.keymap.set("n", "lv", goto_lv, { desc = "Go to Laravel view" })

  setup_auto_jump()
end

return M
