local dap = require("dap")
local dapui = require("dapui")

-- DAP UI setup
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  element_mappings = {},
  expand_lines = true,
  force_buffers = true,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
      disconnect = "",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  },
})

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Python
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      local venv = os.getenv('VIRTUAL_ENV')
      if venv then
        return venv .. '/bin/python'
      else
        return 'python'
      end
    end,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Launch Django',
    program = vim.fn.getcwd() .. '/manage.py',
    args = { 'runserver', '--noreload' },
    pythonPath = function()
      local venv = os.getenv('VIRTUAL_ENV')
      if venv then
        return venv .. '/bin/python'
      else
        return 'python'
      end
    end,
  },
}

-- JavaScript/TypeScript (using js-debug-adapter)
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      os.getenv('HOME') .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
      '${port}',
    },
  },
}

dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    cwd = '${workspaceFolder}',
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Debug Jest Tests',
    runtimeExecutable = 'node',
    runtimeArgs = {
      './node_modules/.bin/jest',
      '--runInBand',
    },
    rootPath = '${workspaceFolder}',
    cwd = '${workspaceFolder}',
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
  },
}

dap.configurations.typescript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch TypeScript',
    runtimeExecutable = 'node',
    runtimeArgs = {'-r', 'ts-node/register'},
    args = {'${file}'},
    cwd = '${workspaceFolder}',
    sourceMaps = true,
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
  },
}

-- Go (requires delve)
dap.adapters.go = {
  type = 'executable',
  command = 'dlv',
  args = {'dap', '-l', '127.0.0.1:${port}'},
}

dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug',
    request = 'launch',
    program = '${file}',
  },
  {
    type = 'go',
    name = 'Debug Package',
    request = 'launch',
    program = '${workspaceFolder}',
  },
  {
    type = 'go',
    name = 'Debug test',
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
  {
    type = 'go',
    name = 'Debug test (go.mod)',
    request = 'launch',
    mode = 'test',
    program = './${relativeFileDirname}',
  },
}

-- Rust (requires codelldb)
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.expand('~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb'),
    args = {'--port', '${port}'},
  },
}

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

-- C/C++ (requires codelldb or cppdbg)
dap.configurations.c = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.c

-- PHP (requires php-debug-adapter)
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js'},
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    pathMappings = {
      ['/var/www/html'] = '${workspaceFolder}'
    }
  },
}

-- Set breakpoint symbols
vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DapBreakpointCondition', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='', texthl='DapLogPoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='', numhl=''})

-- Keymappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<F5>', function() dap.continue() end, opts)
keymap('n', '<F10>', function() dap.step_over() end, opts)
keymap('n', '<F11>', function() dap.step_into() end, opts)
keymap('n', '<F12>', function() dap.step_out() end, opts)
keymap('n', '<leader>db', function() dap.toggle_breakpoint() end, opts)
keymap('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
keymap('n', '<leader>dr', function() dap.repl.open() end, opts)
keymap('n', '<leader>dl', function() dap.run_last() end, opts)
keymap('n', '<leader>du', function() dapui.toggle() end, opts)
keymap('n', '<leader>de', function() dapui.eval() end, opts)
keymap({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end, opts)
keymap({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end, opts)
keymap('n', '<leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, opts)
keymap('n', '<leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, opts)