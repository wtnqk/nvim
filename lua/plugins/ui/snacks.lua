return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dim = { enabled = true },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = {
        enabled = true,
        config = {
          os = {
            edit = 'nvr --remote "{{filename}}"',
          }
        }
      },
      notifier = { enabled = true, timeout = 3000 },
      explorer = { enabled = true, replace_netrw = false },
      picker = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      toggle = { enabled = true },
      words = { enabled = true },
      zen = { enabled = true },
      scratch = {
        enabled = true,
        win = {
          keys = {
            change_ft = {
              "<C-f>",
              function(self)
                local ft = vim.fn.input("Filetype: ")
                if ft ~= "" then
                  self:close()
                  Snacks.scratch({ ft = ft })
                end
              end,
              desc = "Change Filetype",
            },
          },
        },
      },
      image = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys",         gap = 1,   padding = 1 },
          { section = "recent_files", limit = 5, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      -- Explorer
      {
        "<leader>fe",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      -- Find (ff/fg/fw は fff.nvim に委譲)
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>fS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fu",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      {
        "<leader>f:",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>fp",
        function()
          local ft = vim.bo.filetype
          local items = {}
          for _, dir in ipairs(vim.api.nvim_list_runtime_paths()) do
            local pkg_file = dir .. "/package.json"
            if vim.fn.filereadable(pkg_file) == 1 then
              local ok, pkg = pcall(function()
                return vim.fn.json_decode(table.concat(vim.fn.readfile(pkg_file), "\n"))
              end)
              if ok and type(pkg) == "table" and pkg.contributes and pkg.contributes.snippets then
                for _, s in ipairs(pkg.contributes.snippets) do
                  local langs = type(s.language) == "string" and { s.language } or (s.language or {})
                  if #langs == 0 or vim.tbl_contains(langs, ft) then
                    local path = dir .. "/" .. (s.path or ""):gsub("^%./", "")
                    if vim.fn.filereadable(path) == 1 then
                      local ok2, snips = pcall(function()
                        return vim.fn.json_decode(table.concat(vim.fn.readfile(path), "\n"))
                      end)
                      if ok2 and type(snips) == "table" then
                        for name, snip in pairs(snips) do
                          local prefix = type(snip.prefix) == "table" and snip.prefix[1]
                              or (snip.prefix or name)
                          local body = type(snip.body) == "table"
                              and table.concat(snip.body, "\n")
                              or (snip.body or "")
                          table.insert(items, {
                            text = string.format(
                              "%-28s %s",
                              prefix,
                              snip.description or name
                            ),
                            body = body,
                            preview = { text = body, ft = ft },
                          })
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          table.sort(items, function(a, b)
            return a.text < b.text
          end)
          Snacks.picker.pick({
            title = "Snippets [" .. ft .. "]",
            items = items,
            format = "text",
            preview = function(ctx)
              ctx.preview:set_lines(vim.split(ctx.item.preview.text, "\n"))
              vim.bo[ctx.preview.buf].filetype = ctx.item.preview.ft
            end,
            confirm = function(picker, item)
              picker:close()
              vim.schedule(function()
                vim.snippet.expand(item.body)
              end)
            end,
          })
        end,
        desc = "Snippets",
      },
      -- LSP (picker で fuzzy 検索)
      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = "Go to Definition",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        desc = "References",
        nowait = true,
      },
      {
        "gi",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = "Implementation",
      },
      {
        "gt",
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = "Type Definition",
      },
      -- Git
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "LazyGit",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Git Log (file)",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      -- Scratch
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Scratch Buffer",
      },
      {
        "<leader>>",
        function()
          Snacks.scratch.select()
        end,
        desc = "Scratch Select",
      },
      -- Terminal
      {
        "<leader>tt",
        function()
          Snacks.terminal(
            nil,
            { count = 1, win = { position = "float", border = "double", width = 0.8, height = 0.8, backdrop = 60, zindex = 50 } }
          )
        end,
        desc = "Terminal (Float)",
      },
      {
        "<leader>ts",
        function()
          Snacks.terminal(nil, { count = 2, win = { position = "bottom", height = 0.3 } })
        end,
        desc = "Terminal (Split)",
      },
      {
        "<leader>tT",
        function()
          vim.cmd("terminal")
        end,
        desc = "Terminal (Buffer)",
      },
      -- Notifications
      {
        "<leader>nd",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss Notifications",
      },
      {
        "<leader>nh",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      -- Words
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
      },
      -- UI
      {
        "<leader>uz",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode",
      },
      {
        "<leader>uZ",
        function()
          Snacks.zen.zoom()
        end,
        desc = "Zoom Window",
      },
      {
        "<leader>uD",
        function()
          Snacks.dim()
        end,
        desc = "Toggle Dim",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>uT")
        end,
      })
    end,
  },
}
