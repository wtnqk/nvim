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
  "rust_analyzer",
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

    -- Disable built-in LSP completion since we're using blink.cmp
    -- vim.lsp.completion.enable(true, client.id, bufnr, {
    --   autotrigger = true, -- Enable auto-completion
    -- })

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
    -- K is now handled by hover.nvim for enhanced hover functionality
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

-- Disabled native LSP hover handler - using hover.nvim instead
-- local borders = require("config.borders")
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover,
--   {
--     border = borders.get("bold"),  -- Use bold border style
--     focusable = true,
--     max_width = 130,
--     max_height = 20,
--   }
-- )

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
  "rust_analyzer",
}

-- Configure individual LSP servers using Neovim 0.11 API
for _, server_name in ipairs(servers) do
  -- Load our custom configuration
  local ok, server_config = pcall(require, "config.lsp." .. server_name)
  if ok then
    -- Use vim.lsp.config() function to set configuration
    vim.lsp.config(server_name, server_config)
  else
    -- Provide minimal config if no custom config exists
    vim.lsp.config(server_name, {
      cmd = { server_name },
      filetypes = {},
    })
  end
end

-- Enable all configured servers
-- This should auto-start them when a matching filetype is opened
vim.lsp.enable(servers)

-- WORKAROUND: vim.lsp.enable() doesn't auto-start without proper root_dir setup
-- We need to manually start servers until all configs have root_dir properly defined
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local bufnr = args.buf
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Skip if already has clients
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients > 0 then
      return
    end

    -- Try each configured server
    for _, server in ipairs(servers) do
      local config = vim.lsp.config[server]
      if config and config.filetypes and vim.tbl_contains(config.filetypes, ft) then
        -- Determine root_dir
        local root_dir = nil
        if type(config.root_dir) == "function" then
          root_dir = config.root_dir(fname)
        elseif config.root_markers then
          root_dir = vim.fs.root(fname, config.root_markers)
        else
          -- Default to current directory if no root_dir or root_markers
          root_dir = vim.fn.getcwd()
        end

        -- Start server with the determined root_dir
        vim.lsp.start(vim.tbl_extend("force", config, {
          root_dir = root_dir,
        }), {
          bufnr = bufnr,
          name = server,
        })
        -- Only start one server per buffer
        break
      end
    end
  end,
  desc = "Auto-start LSP servers (workaround for missing root_dir)",
})
