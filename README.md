# Neovim Config

## Keymaps

### General

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | n | Save |
| `<leader>q` | n | Quit |
| `<Esc>` | n | Clear search highlights |
| `<S-h>` / `<S-l>` | n | Prev / Next buffer |
| `<leader>bd` | n | Delete buffer |
| `<C-h/j/k/l>` | n | Window navigation |
| `<C-↑/↓/←/→>` | n | Resize window |
| `<A-j/k>` | n/v | Move line(s) down / up |
| `<` / `>` | v | Indent left / right |

### LSP (buffer-local)

| Key | Description |
|-----|-------------|
| `gd` | Go to Definition |
| `gr` | References |
| `gi` | Implementation |
| `gt` | Type Definition |
| `gD` | Go to Declaration |
| `K` | Hover |
| `<C-k>` | Signature Help |
| `<leader>cr` | Rename |
| `<leader>ca` | Code Action |
| `<leader>cf` | Format |
| `<leader>cd` | Line Diagnostics |
| `[d` / `]d` | Prev / Next diagnostic |

### Find `<leader>f`

| Key | Description |
|-----|-------------|
| `<leader>fe` | File Explorer (snacks) |
| `<leader>ff` | Find Files |
| `<leader>fg` | Grep |
| `<leader>fw` | Grep Word |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent Files |
| `<leader>fh` | Help |
| `<leader>fd` | Diagnostics |
| `<leader>fs` | LSP Symbols |
| `<leader>fS` | LSP Workspace Symbols |
| `<leader>fc` | Command History |
| `<leader>fk` | Keymaps |
| `<leader>fu` | Undo History |
| `<leader>f:` | Commands |
| `<leader>fp` | Snippets |
| `<leader>fy` | Yank History |
| `<leader>ft` | Todo (Trouble) |
| `<leader>fT` | Todo (Snacks) |

### Git `<leader>g`

| Key | Description |
|-----|-------------|
| `<leader>gg` | LazyGit |
| `<leader>gf` | Git Log (file) |
| `<leader>gl` | Git Log |
| `<leader>gb` | Git Blame Line |
| `<leader>gB` | Git Browse |
| `<leader>gn` | Neogit |
| `<leader>gh*` | Gitsigns hunks (see below) |

### Code `<leader>c`

| Key | Description |
|-----|-------------|
| `<leader>cr` | Rename |
| `<leader>ca` | Code Action |
| `<leader>cf` | Format |
| `<leader>cd` | Line Diagnostics |

### Search/Replace `<leader>s`

| Key | Description |
|-----|-------------|
| `<leader>sr` | Search & Replace |
| `<leader>sw` | Search & Replace Word |
| `<leader>sf` | Search & Replace in File |

### Trouble `<leader>x`

| Key | Description |
|-----|-------------|
| `<leader>xx` | Diagnostics |
| `<leader>xX` | Buffer Diagnostics |
| `<leader>xs` | Symbols |
| `<leader>xl` | LSP Definitions / References |
| `<leader>xL` | Location List |
| `<leader>xq` | Quickfix List |

### Test `<leader>T`

| Key | Description |
|-----|-------------|
| `<leader>Tt` | Run Nearest Test |
| `<leader>Tf` | Run File Tests |
| `<leader>Ts` | Toggle Test Summary |
| `<leader>To` | Open Test Output |
| `<leader>TO` | Toggle Output Panel |
| `<leader>TS` | Stop Test |

### Run `<leader>r`

| Key | Description |
|-----|-------------|
| `<leader>ro` | Overseer Toggle |
| `<leader>rr` | Overseer Run |
| `<leader>rb` | Overseer Build |

### Debug `<leader>d`

| Key | Description |
|-----|-------------|
| `<leader>dc` | Continue |
| `<leader>di` | Step Into |
| `<leader>do` | Step Over |
| `<leader>dO` | Step Out |
| `<leader>db` | Toggle Breakpoint |
| `<leader>dB` | Conditional Breakpoint |
| `<leader>dr` | REPL |
| `<leader>dl` | Run Last |
| `<leader>dt` | Terminate |
| `<leader>du` | Toggle UI |
| `<leader>dw` | Add Watch |
| `<leader>dtt` | Debug Test (filetype-aware) |
| `<leader>dtl` | Debug Last Test (Go) |
| `<leader>dtc` | Debug Test Class (Python) |

### Grapple `<leader>h`

| Key | Description |
|-----|-------------|
| `<leader>ha` | Tag file |
| `<leader>hd` | Untag file |
| `<leader>hl` | List tags |
| `<leader>h1-4` | Jump to tag 1-4 |
| `<C-h>` / `<C-l>` | Prev / Next tag |

### AI `<leader>a` (Sidekick)

| Key | Description |
|-----|-------------|
| `<leader>aa` | Toggle CLI |
| `<leader>ac` | Toggle Claude |
| `<leader>as` | Select CLI |
| `<leader>ad` | Detach CLI Session |
| `<leader>at` | Send This |
| `<leader>af` | Send File |
| `<leader>av` | Send Selection |
| `<leader>ap` | Select Prompt |
| `<C-.>` | Sidekick Focus |
| `<Tab>` | Goto/Apply Next Edit Suggestion |

### Buffer `<leader>b`

| Key | Description |
|-----|-------------|
| `<leader>bd` | Delete Buffer |

### UI/Toggle `<leader>u`

| Key | Description |
|-----|-------------|
| `<leader>us` | Toggle Spelling |
| `<leader>uw` | Toggle Wrap |
| `<leader>uL` | Toggle Relative Number |
| `<leader>ud` | Toggle Diagnostics |
| `<leader>ul` | Toggle Line Number |
| `<leader>uh` | Toggle Inlay Hints |
| `<leader>uT` | Toggle Treesitter |
| `<leader>uz` | Zen Mode |
| `<leader>uZ` | Zoom Window |
| `<leader>uD` | Toggle Dim |

### Terminal `<leader>t`

| Key | Description |
|-----|-------------|
| `<leader>tt` | Terminal |

### Notifications `<leader>n`

| Key | Description |
|-----|-------------|
| `<leader>nd` | Dismiss Notifications |
| `<leader>nh` | Notification History |

### Navigation

| Key | Description |
|-----|-------------|
| `s` | Flash Jump |
| `S` | Flash Treesitter |
| `]]` / `[[` | Next / Prev reference (words) |
| `]t` / `[t` | Next / Prev Todo |
| `-` | Oil (parent dir) |
| `<leader>e` | File Explorer (Oil) |
| `<leader>o` | Toggle Outline |

### Editing

| Key | Mode | Description |
|-----|------|-------------|
| `<C-a>` / `<C-x>` | n/v | Increment / Decrement (dial) |
| `g<C-a>` / `g<C-x>` | n/v | Increment / Decrement sequential |
| `p` / `P` | n | Put after / before (yanky) |
| `<C-p>` / `<C-n>` | n | Cycle yank history |

### Surround (nvim-surround)

| Key | Mode | Description |
|-----|------|-------------|
| `ys{motion}{char}` | n | Add surround (e.g. `ysiw"`) |
| `cs{old}{new}` | n | Change surround (e.g. `cs"'`) |
| `ds{char}` | n | Delete surround (e.g. `ds"`) |
| `S{char}` | v | Surround selection |

### Oil (inside oil buffer)

| Key | Description |
|-----|-------------|
| `<CR>` | Open in current window |
| `<C-s>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `t` | Open in new tab |
| `<C-p>` | Preview |
| `-` | Parent directory |
| `g.` | Toggle hidden files |
| `gx` | Open external |
| `?` | Help |
| `q` / `<Esc>` | Close |

---

## LSP Servers

Mason を使わないため、各LSPサーバーは手動インストールが必要。

### 方針

| 管理方法 | 対象 |
|----------|------|
| **mise** | ランタイムに依存するLSP（Go/Node/Python/Rust 経由） |
| **brew** | ランタイムと無関係なスタンドアロンツール |
| **手動** | mise/brew未対応のもの |

---

### mise (ランタイム管理)

```sh
# グローバル設定: ~/.config/mise/config.toml
mise use -g go@latest
mise use -g node@lts
mise use -g python@latest
mise use -g rust@latest
```

プロジェクト単位でバージョンを固定する場合:

```toml
# プロジェクト/.mise.toml
[tools]
node = "20"
go = "1.22"
python = "3.12"
```

ランタイム導入後、各パッケージマネージャでLSPをインストール:

```sh
# Go
go install golang.org/x/tools/gopls@latest
go install github.com/sqls-server/sqls@latest

# Node
npm install -g typescript-language-server typescript
npm install -g vscode-langservers-extracted       # jsonls
npm install -g yaml-language-server               # yamlls
npm install -g dockerfile-language-server-nodejs  # dockerls
npm install -g @tailwindcss/language-server
npm install -g @ansible/ansible-language-server
npm install -g @elm-tooling/elm-language-server
npm install -g @github/copilot-language-server

# Python
pip install pyright

# Rust (rustup)
rustup component add rust-analyzer  # rustaceanvim が自動管理
cargo install tinymist              # Typst
```

---

### brew (スタンドアロン)

ランタイムのバージョンに依存しないツール群。

```sh
brew install lua-language-server
brew install llvm                          # clangd (C/C++)
brew install marksman                      # Markdown
brew install hashicorp/tap/terraform-ls   # Terraform
brew install erlang-ls                     # Erlang
brew install clojure-lsp/brew/clojure-lsp  # Clojure
brew install kotlin-language-server        # Kotlin
brew install taplo                         # TOML
brew install gleam                         # Gleam (gleam lsp を内包)
```

---

### 手動インストール

mise/brew未対応のため、GitHubリリースページから取得。

| 言語 | サーバー | 入手先 |
|------|----------|--------|
| Elixir | elixir-ls | https://github.com/elixir-lsp/elixir-ls/releases |
| Zig | zls | https://github.com/zigtools/zls/releases |

---

### OCaml

```sh
opam install ocaml-lsp-server
```

---

## DAP Adapters

| 言語 | アダプター | インストール |
|------|-----------|-------------|
| Go | delve | `go install github.com/go-delve/delve/cmd/dlv@latest` |
| Python | debugpy | `pip install debugpy` |
| JS/TS | vscode-js-debug | lazy.nvimのbuildステップで自動ビルド |
| C/C++ | codelldb | `brew install codelldb` |
| Rust | codelldb | rustaceanvimが自動管理（codelldb要インストール） |
| Elixir | elixir-ls-debugger | elixir-lsに同梱（手動インストール参照） |
| Kotlin | kotlin-debug-adapter | https://github.com/fwcd/kotlin-debug-adapter/releases |
| Zig | codelldb | C/C++と共用 |
| OCaml | ocamlearlybird | `opam install earlybird` |

## Snippet Sources

[`rafamadriz/friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) — JS/TS/Python/Go/Rust/HTML/CSS/JSON/YAML/SQL/Docker/Bash 等
