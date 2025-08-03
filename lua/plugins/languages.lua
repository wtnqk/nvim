return {
  -- SchemaStore support for JSON and YAML
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  -- PHP and Blade support
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },

  {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
    opts = {
      close_tag_on_complete = true,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "php",
        "phpdoc",
        "blade",
      })
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
        },
        filetype = "blade",
      }
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })
    end,
  },

  -- Markdown support
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<Leader>cp",
        ft = "markdown",
        function()
          local is_running = vim.b.mkdp_preview_on or false
          if is_running then
            vim.cmd("MarkdownPreviewStop")
          else
            vim.cmd("MarkdownPreview")
          end
        end,
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },

  -- Git support (enhanced)
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<Leader>gv", "<Cmd>DiffviewOpen<CR>", desc = "Open Diff View" },
      { "<Leader>gV", "<Cmd>DiffviewClose<CR>", desc = "Close Diff View" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          winbar_info = true,
        },
        file_history = {
          winbar_info = true,
        },
      },
    },
  },

  -- Use lazygit instead of neogit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (Current File)" },
      { "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
      { "<leader>gF", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit Filter (Current File)" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<Leader>gh", group = "hunks" },
        { "<Leader>gv", group = "diffview" },
      },
    },
  },

  -- SQL support
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
      { "<Leader>D", "<Cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = {
      sources = {
        compat = { "dadbod" },
      },
    },
  },

  -- TOML support (Cargo.toml)
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
          max_results = 8,
          min_chars = 3,
        },
      },
      lsp = {
        enabled = true,
        on_attach = function(client, bufnr)
          -- Crates.nvim specific keymaps can be added here
        end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "Saecki/crates.nvim" },
    opts = {
      sources = {
        compat = { "crates" },
      },
    },
  },

  -- Format/Lint setup is now handled in formatting.lua
  -- The formatting.lua file contains full formatting and linting configuration

  -- Git commit message support
  {
    "rhysd/committia.vim",
    event = "BufRead COMMIT_EDITMSG",
    init = function()
      vim.g.committia_min_window_width = 100
      vim.g.committia_edit_window_width = 72
    end,
  },

  -- Git conflict resolution
  {
    "akinsho/git-conflict.nvim",
    event = "LazyFile",
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
    },
  },

  -- Git blame
  {
    "FabijanZulj/blame.nvim",
    cmd = { "BlameToggle" },
    keys = {
      { "<Leader>gb", "<Cmd>BlameToggle<CR>", desc = "Toggle Git Blame" },
    },
    opts = {
      date_format = "%Y-%m-%d",
      merge_consecutive = true,
      max_summary_width = 30,
      mappings = {
        commit_info = "i",
        stack_push = "<TAB>",
        stack_pop = "<BS>",
        show_commit = "<CR>",
        close = "q",
      },
    },
  },

  -- DOT language support
  {
    "wannesm/wmgraphviz.vim",
    ft = { "dot", "gv" },
  },

  -- JSON manipulation
  {
    "gennaro-tedesco/nvim-jqx",
    ft = "json",
    cmd = { "JqxList", "JqxQuery" },
  },
}