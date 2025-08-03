return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            Util.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = Util.config.icons.diagnostics.Error,
                warn = Util.config.icons.diagnostics.Warn,
                info = Util.config.icons.diagnostics.Info,
                hint = Util.config.icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { Util.lualine.pretty_path() },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = { fg = Util.ui.color("Statement") },
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = { fg = Util.ui.color("Constant") },
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = { fg = Util.ui.color("Debug") },
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = Util.ui.color("Special") },
            },
            {
              "diff",
              symbols = {
                added = Util.config.icons.git.added,
                modified = Util.config.icons.git.modified,
                removed = Util.config.icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }

      if Util.plugin.is_loaded("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "lsp_document_symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols.get,
          cond = symbols.has,
        })
      end

      return opts
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          silent = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      { "<Leader>sn", "", desc = "Noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<Leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<Leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<Leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<Leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<Leader>snt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
      {
        "<C-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<C-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  { "MunifTanjim/nui.nvim", lazy = true },

  {
    "Bekaboo/deadcolumn.nvim",
    event = "UIEnter",
    init = function()
      if vim.fn.argc(-1) > 0 then
        require("deadcolumn")
      end
    end,
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<Leader>ut")
      return { mode = "cursor", max_lines = 3 }
    end,
  },


  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = function()
      Snacks.toggle({
        name = "Incline",
        get = function()
          return require("incline").is_enabled()
        end,
        set = function(state)
          if state then
            require("incline").enable()
          else
            require("incline").disable()
          end
        end,
      }):map("<Leader>ui")

      return {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        ignore = {
          buftypes = { "help", "nofile", "nowrite", "quickfix", "terminal", "prompt" },
        },
        hide = {
          cursorline = "focused_win",
        },
        render = function(props)
          local devicons = require("nvim-web-devicons")

          local function shorten_path_styled(path, opts)
            opts = opts or {}
            local head_style = opts.head_style or {}
            local tail_style = opts.tail_style or {}
            local _, head, tail = Util.path.format_path(
              path,
              vim.tbl_extend("force", opts, {
                return_segments = true,
                last_separator = true,
              })
            )
            return {
              head and vim.list_extend(head_style, { head }) or "",
              vim.list_extend(tail_style, { tail }),
            }
          end

          local colors = {
            fg = Util.ui.color("Normal"),
            fg_nc = Util.ui.dim(Util.ui.color("Normal"), 0.75),
            bg = Util.ui.color("Normal", true),
            red = Util.ui.color("Error"),
          }

          local function get_icon(buf)
            local bufname = Util.path.buf_get_name(buf)
            local extension = vim.fn.fnamemodify(bufname, ":e")
            local icon, icon_color
            icon, icon_color = devicons.get_icon_color(bufname, extension, { default = true })
            return {
              icon = icon,
              fg = icon_color,
            }
          end

          local function get_file_path(buf, focused, fg, fg_nc)
            local bufname = Util.path.buf_get_name(buf)
            local fname = shorten_path_styled(bufname, {
              short_len = 3,
              tail_count = 2,
              max_segments = 3,
              replace_home = true,
              ellipsis = true,
              no_name = true,
              head_style = { guifg = fg_nc },
              tail_style = { guifg = focused and fg or fg_nc },
            })
            return fname
          end

          local file_path = get_file_path(props.buf, props.focused, colors.fg, colors.fg_nc)
          local icon = get_icon(props.buf)
          local modified = vim.bo[props.buf].modified

          return {
            {
              {
                " ",
              },
              {
                icon.icon,
                " ",
                guifg = props.focused and icon.fg or colors.fg_nc,
              },
              {
                " ",
              },
              {
                file_path,
                gui = modified and "bold,italic" or nil,
              },
              { modified and " [+]" or "", guifg = colors.red },
              {
                " ",
              },
              guibg = colors.bg,
            },
          }
        end,
      }
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    },
    keys = {
      {
        "<Leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<Leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
    },
  },

  -- Bufferline for tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
      { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
      { "[B", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
      { "]B", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(require("bufferline"), "setup", opts)
          end)
        end,
      })
    end,
  },

  -- Neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<Leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<Leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<Leader>e", "<Leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<Leader>E", "<Leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<Leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<Leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
  },

  -- Session persistence
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<Leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<Leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<Leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<Leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}