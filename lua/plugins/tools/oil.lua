return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "refractalize/oil-git-status.nvim",
      "JezerM/oil-lsp-diagnostics.nvim",
      {
        "malewicz1337/oil-git.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = {
          show_file_highlights = true,
          show_directory_highlights = false,
          show_ignored_files = true,
        },
      }
    },
    opts = {
      default_file_explorer = false,
      columns = { "icon", "size" },
      delete_to_trash = true,
      use_default_keymaps = false,
      keymaps = {
        ["?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
        ["gx"] = "actions.open_external",
        ["<Esc>"] = "actions.close",
        ["q"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return vim.tbl_contains({ ".DS_Store" }, name)
        end,
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions.type == "move" then
            Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "OilEnter",
        callback = vim.schedule_wrap(function(args)
          local oil = require("oil")
          if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            oil.open_preview()
          end
        end),
      })
    end,
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "File Explorer (parent)" },
      {
        "-",
        function()
          local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          if vim.v.shell_error ~= 0 then root = vim.fn.getcwd() end
          require("oil").open(root)
        end,
        desc = "Oil (project root)",
      },
    },
  },
}
