# LSP Setup Guide

This configuration uses Neovim 0.11+ native LSP API with Mason for server management.

## Architecture

- **Mason.nvim**: Manages LSP server installation
- **Native LSP API**: Uses `vim.lsp.config()` and `vim.lsp.enable()` (Neovim 0.11+)
- **No nvim-lspconfig dependency**: Pure Neovim native implementation

## Directory Structure

```
lua/config/
├── lsp.lua              # Main LSP configuration
└── lsp/
    ├── utils.lua        # LSP utilities (capabilities)
    ├── bashls.lua       # Bash LSP config
    ├── intelephense.lua # PHP LSP config
    ├── lua_ls.lua       # Lua LSP config
    ├── pyright.lua      # Python LSP config
    ├── ruff.lua         # Python linter config
    ├── vimls.lua        # Vim LSP config
    └── yamlls.lua       # YAML LSP config
```

## Adding a New LSP Server

### 1. Install via Mason

Open Mason UI and install the server:
```vim
:Mason
```

### 2. Update Configuration

Edit `lua/config/lsp.lua`:

```lua
-- Add to ensure_installed list (for auto-installation)
local ensure_installed = {
  -- existing servers...
  "new-server-name",  -- Mason package name
}

-- Add to servers list (for enabling)
local servers = {
  -- existing servers...
  "new_lsp_name",  -- LSP server name
}
```

### 3. Add Custom Configuration (Optional)

Create `lua/config/lsp/new_lsp_name.lua`:

```lua
return {
  cmd = { "command", "args" },  -- Optional: custom command
  filetypes = { "ext" },         -- Optional: file types
  root_markers = { ".git" },     -- Optional: root markers
  init_options = {               -- Server initialization options
    -- server specific options
  },
  settings = {                   -- Server runtime settings
    -- server specific settings
  },
}
```

## LSP Features

### Auto-completion

Native LSP completion is enabled automatically:
- Triggers on typing
- Works alongside nvim-cmp
- No additional plugins required

### Key Mappings

Available in LSP-attached buffers:

| Mapping | Description |
|---------|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Show hover documentation |
| `gi` | Go to implementation |
| `gr` | Find references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |

## Troubleshooting

### Server Not Found

If you see "Server 'xxx' not found! Use :Mason to install it":
1. Open Mason: `:Mason`
2. Find and install the server
3. Restart Neovim

### Custom Server Paths

Mason installs servers to `~/.local/share/nvim/mason/bin/`
This path is automatically added to PATH in the LSP configuration.

### License Keys

Some servers (like Intelephense) require license keys:
1. Purchase a license from the vendor
2. Add to the server config file:
```lua
-- lua/config/lsp/intelephense.lua
return {
  init_options = {
    licenseKey = "YOUR_LICENSE_KEY_HERE",
  },
}
```

## Server-Specific Notes

### Intelephense (PHP)
- Free version has limited features
- Premium license enables advanced diagnostics and refactoring
- License available at https://intelephense.com/

### lua_ls
- Automatically configured for Neovim development
- `vim` global is recognized

### pyright & ruff
- Use together for complete Python support
- pyright: Type checking and IntelliSense
- ruff: Fast linting and formatting