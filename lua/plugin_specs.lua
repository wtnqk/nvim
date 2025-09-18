local utils = require("utils")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine (using blink.cmp instead of nvim-cmp)
  {
    'saghen/blink.cmp',
    lazy = false,
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',

    config = function()
      require("config.blink-cmp")
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
      require("config.lsp")
    end,
  },
  {
    "dnlhc/glance.nvim",
    config = function()
      require("config.glance")
    end,
    event = "VeryLazy",
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        ui = {
          code_action = "💡",
          enable = true,
          border = "rounded",
        },
        lightbulb = {
          enable = false,  -- Disable since we use nvim-lightbulb
        },
        symbol_in_winbar = {
          enable = false,  -- Disable since we use dropbar.nvim
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    branch = "master",
    config = function()
      require("config.treesitter-textobjects")
    end,
  },
  { "machakann/vim-swap",          event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  {
    "vlime/vlime",
    enabled = function()
      return utils.executable("sbcl")
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
    ft = { "lisp" },
  },

  -- Super fast buffer jump
  {
    "smoka7/hop.nvim",
    keys = { "f" },
    config = function()
      require("config.nvim_hop")
    end,
  },

  -- Fast fuzzy file finder with typo-resistant search
  {
    "dmtrKovalenko/fff.nvim",
    build = 'cargo build --release',
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {                -- (optional)
      debug = {
        enabled = true,     -- we expect your collaboration at least during the beta
        show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "ff", -- try it if you didn't it is a banger keybinding for a picker
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      }
    }
  },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
    },
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("config.fzf-lua")
    end,
    event = "VeryLazy",
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    main = "render-markdown",
    opts = {},
    ft = { "markdown" },
  },
  -- A list of colorscheme plugin you may want to try. Find what suits you.
  { "navarasu/onedark.nvim",       lazy = true },
  { "sainnhe/edge",                lazy = true },
  { "sainnhe/sonokai",             lazy = true },
  { "sainnhe/gruvbox-material",    lazy = true },
  { "sainnhe/everforest",          lazy = true },
  { "EdenEast/nightfox.nvim",      lazy = true },
  { "catppuccin/nvim",             name = "catppuccin", lazy = true },
  { "olimorris/onedarkpro.nvim",   lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  {
    "rockyzhang24/arctic.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    name = "arctic",
    branch = "v2",
  },
  { "rebelot/kanagawa.nvim",        lazy = true },
  { "miikanissi/modus-themes.nvim", priority = 1000 },
  { "wtfox/jellybeans.nvim",        priority = 1000 },
  { "projekt0n/github-nvim-theme",  name = "github-theme" },
  { "e-ink-colorscheme/e-ink.nvim", priority = 1000 },
  { "ficcdaf/ashen.nvim",           priority = 1000 },
  { "savq/melange-nvim",            priority = 1000 },
  { "Skardyy/makurai-nvim",         priority = 1000 },
  { "vague2k/vague.nvim",           priority = 1000 },
  { "webhooked/kanso.nvim",         priority = 1000 },
  { "zootedb0t/citruszest.nvim",    priority = 1000 },

  -- plugins to provide nerdfont icons
  {
    "nvim-mini/mini.icons",
    version = false,
    config = function()
      -- this is the compatibility fix for plugins that only support nvim-web-devicons
      require("mini.icons").mock_nvim_web_devicons()
      require("mini.icons").tweak_lsp_kind()
    end,
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "BufRead",
    cond = firenvim_not_active,
    config = function()
      require("config.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  -- MIGRATED TO SNACKS: dashboard
  -- {
  --   "nvimdev/dashboard-nvim",
  --   cond = firenvim_not_active,
  --   config = function()
  --     require("config.dashboard-nvim")
  --   end,
  -- },

  -- MIGRATED TO SNACKS: indent
  -- {
  --   "nvim-mini/mini.indentscope",
  --   version = false,
  --   config = function()
  --     local mini_indent = require("mini.indentscope")
  --     mini_indent.setup {
  --       draw = {
  --         animation = mini_indent.gen_animation.none(),
  --       },
  --       symbol = "▏",
  --     }
  --   end,
  -- },
  -- MIGRATED TO SNACKS: statuscolumn
  -- {
  --   "luukvbaal/statuscol.nvim",
  --   opts = {},
  --   config = function()
  --     require("config.nvim-statuscol")
  --   end,
  -- },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("config.nvim_ufo")
    end,
  },
  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "BufReadPost" },

  -- notification plugin
  -- MIGRATED TO SNACKS: notifier
  -- {
  --   "rcarriga/nvim-notify",
  --   event = "VeryLazy",
  --   config = function()
  --     require("config.nvim-notify")
  --   end,
  -- },

  { "nvim-lua/plenary.nvim",    lazy = true },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we maybe in a server which disables GUI.
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    enabled = function()
      return vim.g.is_win or vim.g.is_mac
    end,
    config = true,      -- default settings
    submodules = false, -- not needed, submodules are required only for tests
  },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  {
    "liuchengxu/vista.vim",
    enabled = function()
      return utils.executable("ctags")
    end,
    cmd = "Vista",
  },

  -- Snippet engine and snippet template
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Automatic insertion and deletion of a pair of characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment plugin
  {
    "tpope/vim-commentary",
    keys = {
      { "gc", mode = "n" },
      { "gc", mode = "v" },
    },
  },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Show undo history visually
  { "simnalamburt/vim-mundo",    cmd = { "MundoToggle", "MundoShow" } },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    cmd = "YankyRingHistory",
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch",          cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat",          event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  {
    "lyokha/vim-xkbswitch",
    enabled = function()
      return vim.g.is_mac and utils.executable("xkbswitch")
    end,
    event = { "InsertEnter" },
  },

  {
    "Neur1n/neuims",
    enabled = function()
      return vim.g.is_win
    end,
    event = { "InsertEnter" },
  },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      -- Only one of these is needed.
      "ibhagwan/fzf-lua",       -- optional
    },
    event = "User InGitRepo",
  },

  -- Better git log display
  { "rbong/vim-flog",                   cmd = { "Flog" } },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("config.git-conflict")
    end,
  },
  -- MIGRATED TO SNACKS: gitbrowse
  -- {
  --   "ruifm/gitlinker.nvim",
  --   event = "User InGitRepo",
  --   config = function()
  --     require("config.git-linker")
  --   end,
  -- },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
    event = "BufRead",
    version = "*",
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("config.bqf")
    end,
  },


  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular",                ft = { "markdown" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      return vim.g.is_win or vim.g.is_mac
    end,
    build = "cd app && npm install && git restore .",
    ft = { "markdown" },
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      return vim.g.is_mac
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim",   keys = { "ga" },   cmd = { "UnicodeSearch" } },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim",     event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Only use these plugin on Windows and Mac and when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      return utils.executable("latex")
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      return utils.executable("tmux")
    end,
    ft = { "tmux" },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup",     event = "BufRead" },
  { "tpope/vim-scriptease",     cmd = { "Scriptnames", "Messages", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true,                                   cmd = { "AsyncRun" } },
  { "cespare/vim-toml",         ft = { "toml" },                               branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      return vim.g.is_win or vim.g.is_mac
    end,
    -- it seems that we can only call the firenvim function directly.
    -- Using vim.fn or vim.cmd to call this function will fail.
    build = function()
      local firenvim_path = plugin_dir .. "/firenvim"
      vim.opt.runtimepath:append(firenvim_path)
      vim.cmd("runtime! firenvim.vim")

      -- macOS will reset the PATH when firenvim starts a nvim process, causing the PATH variable to change unexpectedly.
      -- Here we are trying to get the correct PATH and use it for firenvim.
      -- See also https://github.com/glacambre/firenvim/blob/master/TROUBLESHOOTING.md#make-sure-firenvims-path-is-the-same-as-neovims
      local path_env = vim.env.PATH
      local prologue = string.format('export PATH="%s"', path_env)
      -- local prologue = "echo"
      local cmd_str = string.format(":call firenvim#install(0, '%s')", prologue)
      vim.cmd(cmd_str)
    end,
  },
  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      return vim.g.is_win or vim.g.is_linux
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- Session management plugin
  { "tpope/vim-obsession",   cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      return vim.g.is_linux
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },
  {
    "folke/flash.nvim",
    lazy = true,  -- Only loaded when needed by Snacks picker
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "folke/flash.nvim" },
    ---@type snacks.Config
    opts = {
      -- Core features
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      -- Picker configuration with flash integration
      picker = {
        win = {
          input = {
            keys = {
              ["<a-s>"] = { "flash", mode = { "n", "i" } },
              ["s"] = { "flash" },
            },
          },
        },
        actions = {
          flash = function(picker)
            require("flash").jump({
              pattern = "^",
              label = { after = { 0, 0 } },
              search = {
                mode = "search",
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
        },
      },

      -- UI replacements
      dashboard = {
        enabled = true,
        sections = {
          { section = "header",  padding = 1 },
          { section = "keys",    padding = 1 },
          { section = "startup", padding = 1 },
        },
        preset = {
          header = [[
 ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
 ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
 ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
 ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
 ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
 ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
          keys = {
            { icon = "󰈞", desc = "Find File", key = "f", action = ":lua Snacks.picker.files()" },
            { icon = "󰈢", desc = "Recent Files", key = "r", action = ":lua Snacks.picker.recent()" },
            { icon = "󰈬", desc = "Grep", key = "g", action = ":FzfLua live_grep" },
            { icon = "", desc = "Config", key = "c", action = ":tabnew $MYVIMRC | tcd %:p:h" },
            { icon = "", desc = "New File", key = "n", action = ":enew" },
            { icon = "󰗼", desc = "Quit", key = "q", action = ":qa" },
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 1500,
        style = "compact",
      },
      input = {
        enabled = true,
        win = {
          relative = "cursor",
          backdrop = true,
        },
      },
      picker = {
        enabled = true,
        win = {
          list = {
            keys = {
              -- Disable gg in picker list to avoid conflict with <leader>gg for LazyGit
              ["gg"] = false,
            },
          },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false,
          git_hl = false,
        },
      },
      indent = {
        enabled = true,
        char = "▏",
        animate = {
          enabled = false,
        },
      },

      -- File management
      explorer = {
        enabled = true,
        win = {
          width = 30,
          position = "left",
        },
      },
      bufdelete = { enabled = true },
      rename = { enabled = true },

      -- Git features
      gitbrowse = {
        enabled = true,
        -- Support for Azure DevOps
        url_patterns = {
          ["dev.azure.com"] = {
            branch = "/branchCompare?baseVersion=GB{branch}&targetVersion=GBmaster&_a=commits",
            file =
            "?path=/{file}&version=GB{branch}&line={line_start}&lineEnd={line_end}&lineStartColumn=1&lineEndColumn=120",
            commit = "/commit/{commit}",
          },
        },
      },
      lazygit = {
        enabled = true,
        -- Optional: Configure window size
        win = {
          width = 0.9,
          height = 0.9,
        },
      },

      -- Navigation and editing
      scope = { enabled = true },
      words = { enabled = true },
      scroll = { enabled = true },

      -- Terminal (disabled - using toggleterm instead)
      terminal = { enabled = false },

      -- Productivity
      scratch = { enabled = true },
      zen = { enabled = true },
      dim = { enabled = true },

      -- Development tools
      debug = { enabled = true },
      profiler = { enabled = true },

      -- Toggle keymaps
      toggle = { enabled = true },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      -- Replace vim.notify with Snacks notifier
      vim.notify = snacks.notifier.notify
      -- Keymaps are defined in lua/mappings.lua
    end,
  },
  -- show and trim trailing whitespaces
  { "jdhao/whitespace.nvim", event = "VeryLazy" },

  -- file explorer
  -- MIGRATED TO SNACKS: explorer
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   keys = { "<space>s" },
  --   config = function()
  --     require("config.nvim-tree")
  --   end,
  -- },

  {
    "j-hui/fidget.nvim",
    event = "BufRead",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    cmd = { "CopilotChat" },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup {}
    end,
  },
  {
    "smjonas/live-command.nvim",
    -- live-command supports semantic versioning via Git tags
    -- tag = "2.*",
    event = "VeryLazy",
    config = function()
      require("config.live-command")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("config.toggleterm")
    end,
    keys = {
      { "<C-\\>", desc = "Terminal (float)" },
      { "<C-/>", desc = "Toggle terminal" },
      { "<C-_>", desc = "Toggle terminal" },
      { "<leader>tn", desc = "New terminal" },
      { "<leader>tl", desc = "List terminals" },
    },
  },
  {
    -- show hint for code actions, the user can also implement code actions themselves,
    -- see discussion here: https://github.com/neovim/neovim/issues/14869
    "kosayoda/nvim-lightbulb",
    config = function()
      require("config.lightbulb")
    end,
    event = "LspAttach",
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },

  -- FFF.nvim - Fast fuzzy file finder
  {
    'dmtrKovalenko/fff.nvim',
    build = 'cargo build --release',
    lazy = false,
    config = function()
      require("config.fff")
    end,
  },
}

---@diagnostic disable-next-line: missing-fields
require("lazy").setup {
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
}
