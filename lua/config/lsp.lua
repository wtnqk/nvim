local utils = require("utils")

-- Auto-install LSP servers and formatters with Mason
local ensure_installed = {
  "lua-language-server",
  "stylua", -- Lua formatter
  "bash-language-server",
  "yaml-language-server",
  "vim-language-server",
  "ruff",
  "intelephense",
  "volar",
}

-- Ensure servers are installed
vim.defer_fn(function()
  local registry = require("mason-registry")
  for _, server in ipairs(ensure_installed) do
    local ok, pkg = pcall(registry.get_package, server)
    if ok then
      if not pkg:is_installed() then
        vim.notify("Installing " .. server, vim.log.levels.INFO)
        pkg:install()
      end
    end
  end
end, 100)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    -- vim.print(client.name, client.server_capabilities)

    if not client then
      return
    end

    local bufnr = event_context.buf

    -- Enable LSP-based auto-completion for Neovim 0.11+
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true, -- Enable auto-completion
    })

    -- Mappings.
    local map = function(mode, l, r, opts)
      opts = opts or {}
      opts.silent = true
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "gd", function()
      vim.lsp.buf.definition {
        on_list = function(options)
          -- custom logic to avoid showing multiple definition when you use this style of code:
          -- `local M.my_fn_name = function() ... end`.
          -- See also post here: https://www.reddit.com/r/neovim/comments/19cvgtp/any_way_to_remove_redundant_definition_in_lua_file/

          -- vim.print(options.items)
          local unique_defs = {}
          local def_loc_hash = {}

          -- each item in options.items contain the location info for a definition provided by LSP server
          for _, def_location in pairs(options.items) do
            -- use filename and line number to uniquelly indentify a definition,
            -- we do not expect/want multiple definition in single line!
            local hash_key = def_location.filename .. def_location.lnum

            if not def_loc_hash[hash_key] then
              def_loc_hash[hash_key] = true
              table.insert(unique_defs, def_location)
            end
          end

          options.items = unique_defs

          -- set the location list
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.fn.setloclist(0, {}, " ", options)

          -- open the location list when we have more than 1 definitions found,
          -- otherwise, jump directly to the definition
          if #options.items > 1 then
            vim.cmd.lopen()
          else
            vim.cmd([[silent! lfirst]])
          end
        end,
      }
    end, { desc = "go to definition" })
    map("n", "<C-]>", vim.lsp.buf.definition)
    map("n", "K", function()
      vim.lsp.buf.hover {
        border = "single",
        max_height = 20,
        max_width = 130,
        close_events = { "CursorMoved", "BufLeave", "WinLeave", "LSPDetach" },
      }
    end)
    map("n", "<C-k>", vim.lsp.buf.signature_help)
    map("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
    map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map({ "n", "v" }, "<space>f", function()
      vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
    end, { desc = "Format code" })
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<space>wl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, { desc = "list workspace folder" })

    -- Set some key bindings conditional on server capabilities
    -- Ruff is now the only Python LSP server

    -- Uncomment code below to enable inlay hint from language server, some LSP server supports inlay hint,
    -- but disable this feature by default, so you may need to enable inlay hint in the LSP server config.
    -- vim.lsp.inlay_hint.enable(true, {buffer=bufnr})

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
      local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = gid,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd("CursorMoved", {
        group = gid,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end

    -- Get server config to check format_on_save setting
    local server_config = vim.lsp.config[client.name] or {}
    local format_on_save = server_config.format_on_save == true

    -- Format on save if the server supports it and is enabled in server config
    if client.server_capabilities.documentFormattingProvider and format_on_save then
      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave_" .. client.name, { clear = false })
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            timeout_ms = 2000,
            filter = function(lsp_client)
              -- Only use this specific LSP server for formatting
              return lsp_client.name == client.name
            end
          })
        end,
        desc = "Format on save with " .. client.name,
      })
    end
  end,
  nested = true,
  desc = "Configure buffer keymap and behavior based on LSP",
})

-- Enable lsp servers when they are available

local capabilities = require("config.lsp.utils").get_default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 500,
  },
})

-- Add Mason's bin directory to PATH for LSP servers
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- LSP servers to enable
local servers = {
  "ruff",
  "lua_ls",
  "vimls",
  "bashls",
  "yamlls",
  "intelephense",
  "volar",
}

-- Configure individual LSP servers using Neovim 0.11 API
-- Load server-specific configurations from lua/config/lsp directory
for _, server_name in ipairs(servers) do
  local ok, server_config = pcall(require, "config.lsp." .. server_name)
  if ok then
    -- Store the format_on_save setting before registering
    vim.lsp.config(server_name, server_config)
  else
    vim.lsp.config(server_name, {})
  end
end

-- Enable all configured servers
vim.lsp.enable(servers)

-- Auto-start LSP servers for matching filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    -- Get filetype and buffer
    local ft = vim.bo[args.buf].filetype
    local bufnr = args.buf

    -- Check if any LSP clients are already attached
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients > 0 then
      return
    end

    -- Start appropriate LSP servers based on filetype
    for _, server in ipairs(servers) do
      local config = vim.lsp.config[server]
      if config and config.filetypes then
        if vim.tbl_contains(config.filetypes, ft) then
          vim.lsp.start(config, {
            bufnr = bufnr,
            name = server,
          })
        end
      end
    end
  end,
  desc = "Auto-start LSP servers for matching filetypes",
})
