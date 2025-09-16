-- FFF.nvim configuration
-- Fast fuzzy file finder with Rust backend

require('fff').setup({
  prompt = '🔍 ',
  title = 'FFF Files',
  max_results = 100,
  max_threads = 4,
  lazy_sync = true, -- Start syncing only when the picker is open

  layout = {
    height = 0.8,
    width = 0.8,
    prompt_position = 'bottom',
    preview_position = 'right',
    preview_size = 0.5,
  },

  preview = {
    enabled = true,
    max_size = 10 * 1024 * 1024, -- 10MB
    chunk_size = 8192,
    binary_file_threshold = 1024,
    line_numbers = true,
    wrap_lines = false,
    show_file_info = true,
    filetypes = {
      svg = { wrap_lines = true },
      markdown = { wrap_lines = true },
      text = { wrap_lines = true },
    },
  },

  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    select_split = '<C-s>',
    select_vsplit = '<C-v>',
    select_tab = '<C-t>',
    move_up = { '<Up>', '<C-p>', '<C-k>' },
    move_down = { '<Down>', '<C-n>', '<C-j>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_debug = '<F2>',
  },

  hl = {
    border = 'FloatBorder',
    normal = 'Normal',
    cursor = 'CursorLine',
    matched = 'IncSearch',
    title = 'Title',
    prompt = 'Question',
    active_file = 'Visual',
    frecency = 'Number',
    debug = 'Comment',
  },

  frecency = {
    enabled = true,
    db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
  },

  debug = {
    enabled = false,
    show_scores = false,
  },

  logging = {
    enabled = true,
    log_file = vim.fn.stdpath('log') .. '/fff.log',
    log_level = 'info',
  },
})