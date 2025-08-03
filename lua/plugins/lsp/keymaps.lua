local M = {}

M._keys = nil

function M.get()
  if M._keys then
    return M._keys
  end
  M._keys = {
    {
      "<Leader>cl",
      function()
        Snacks.picker.lsp_config()
      end,
      desc = "Lsp Info",
    },
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
    { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "<Leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    {
      "<Leader>cA",
      function()
        vim.lsp.buf.code_action({
          context = {
            only = {
              "source",
            },
            diagnostics = {},
          },
        })
      end,
      desc = "Source Action",
      has = "codeAction",
    },
    { "<Leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
    { "<Leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
    { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    {
      "<Leader>cR",
      Snacks.rename.rename_file,
      desc = "Rename File",
      mode = { "n" },
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    },
    {
      "]]",
      function()
        Util.lsp.words.jump(vim.v.count1)
      end,
      has = "documentHighlight",
      desc = "Next Reference",
      cond = function()
        return Util.lsp.words.enabled
      end,
    },
    {
      "[[",
      function()
        Util.lsp.words.jump(-vim.v.count1)
      end,
      has = "documentHighlight",
      desc = "Previous Reference",
      cond = function()
        return Util.lsp.words.enabled
      end,
    },
  }
  if Util.plugin.has("inc-rename.nvim") then
    M._keys[#M._keys + 1] = {
      "<Leader>cr",
      function()
        local inc_rename = require("inc_rename")
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    }
  else
    M._keys[#M._keys + 1] = { "<Leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
  end
  return M._keys
end

function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = Util.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

function M.resolve(buffer)
  local LazyKeys = require("lazy.core.handler.keys")
  if not LazyKeys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, M.get())
  local opts = Util.plugin.opts("nvim-lspconfig")
  local clients = Util.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return LazyKeys.resolve(spec)
end

function M.on_attach(_, buffer)
  local LazyKeys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = LazyKeys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M