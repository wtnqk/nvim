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

    -- Navigation keymaps are defined globally in mappings.lua using Snacks picker
    -- Lspsaga keymaps
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "LSP hover (Lspsaga)" })
    map("n", "<C-k>", "<cmd>Lspsaga signature_help<CR>", { desc = "Signature help (Lspsaga)" })
    map("n", "<space>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename (Lspsaga)" })
    map("n", "<space>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action (Lspsaga)" })
    map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition (Lspsaga)" })
    map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition (Lspsaga)" })
    map("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder (Lspsaga)" })
    map("n", "go", "<cmd>Lspsaga outline<CR>", { desc = "Outline (Lspsaga)" })
    map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic (Lspsaga)" })
    map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic (Lspsaga)" })
    map("n", "<space>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line diagnostics (Lspsaga)" })
    map("n", "<space>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer diagnostics (Lspsaga)" })
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

-- Native LSP hover handler configuration (disabled - using lspsaga instead)
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

-- NOTE: vim.lsp.enable() causes duplicate servers with N/A root_dir
-- We use FileType autocmd to start servers with proper root_dir instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local bufnr = args.buf
    local fname = vim.api.nvim_buf_get_name(bufnr)

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

        -- vim.lsp.start will automatically reuse existing clients with the same config
        vim.lsp.start(vim.tbl_extend("force", config, {
          root_dir = root_dir,
          name = server,
        }), {
          bufnr = bufnr,
          reuse_client = function(client, conf)
            -- Reuse client if it has the same name and root_dir
            return client.name == conf.name and client.config.root_dir == conf.root_dir
          end,
        })
        -- Only process one server per buffer
        break
      end
    end
  end,
  desc = "Auto-start LSP servers (workaround for missing root_dir)",
})
