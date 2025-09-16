require("blink.cmp").setup {
  keymap = {
    preset = "none", -- Use custom keymaps
    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" }, -- Enter to confirm selection
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "cancel", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-y>"] = { "accept", "fallback" }, -- Alternative accept key
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' }, -- Recipe 1: Add border
    },
    menu = {
      auto_show = true,   -- Show menu automatically
      border = 'rounded', -- Recipe 1: Add border to menu
      draw = {
        treesitter = { "lsp" },
      },
      -- Recipe 4: Adjust menu direction for multi-line completions
      direction_priority = function()
        local ctx = require('blink.cmp').get_context()
        local item = require('blink.cmp').get_selected_item()
        if ctx == nil or item == nil then return { 's', 'n' } end

        local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
        local is_multi_line = item_text:find('\n') ~= nil

        -- after showing the menu upwards, we want to maintain that direction
        -- until we re-open the menu, so store the context id in a global variable
        if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
          vim.g.blink_cmp_upwards_ctx_id = ctx.id
          return { 'n', 's' } -- north (up) first
        end
        return { 's', 'n' }   -- south (down) first
      end,
    },
    ghost_text = {
      enabled = true, -- Enable ghost text inline preview
    },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  -- Cmdline configuration
  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline' },
    sources = { 'buffer', 'cmdline' }, -- Correct format: array of strings
  },

  -- Rust fuzzy matcher for typo resistance and significantly better performance
  fuzzy = {
    prebuilt_binaries = {
      download = true,
    },
  },

  signature = {
    enabled = true,
    window = { border = 'rounded' }, -- Recipe 1: Add border to signature
  },
}
