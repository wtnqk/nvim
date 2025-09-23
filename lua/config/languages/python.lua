local M = {}

M.treesitter = {
  "python",
}

M.lsp = {
  servers = {
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            typeCheckingMode = "basic",
          },
        },
      },
    },
    ruff_lsp = {
      init_options = {
        settings = {
          args = {},
        },
      },
    },
  },
}

M.dap = function(dap)
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
    {
      type = 'python',
      request = 'launch',
      name = 'Launch Flask',
      module = 'flask',
      env = {
        FLASK_APP = 'app.py',
        FLASK_ENV = 'development',
      },
      args = { 'run', '--no-debugger', '--no-reload' },
      jinja = true,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch FastAPI',
      module = 'uvicorn',
      args = { 'main:app', '--reload' },
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
end

M.mason_packages = {
  "pyright",
  "ruff-lsp",
  "debugpy",
  "black",
  "isort",
  "mypy",
}

return M