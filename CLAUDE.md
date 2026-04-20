# CLAUDE.md

Guidance for Claude Code (and other AI assistants) working in this repo.

## Overview

Personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), written in Lua. Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim). All personal code lives under `lua/custom/`; plugin specs live one-file-per-plugin under `lua/plugins/`.

Entry point: `init.lua`. Everything is reached from there.

## Repository layout

```
init.lua                        -- entry point; sets leader, loads modules in order
lazy-lock.json                  -- lazy.nvim lockfile (auto-managed, commit it)
Makefile                        -- `make test` runner
stylua.toml                     -- formatting config (4-space, 88 col, single quotes)
doc/kickstart.txt               -- upstream vim help
TODO.md                         -- maintainer scratchpad; not a source of truth
lua/
  custom/                       -- personal modules; each exports a register() fn
    _initialize-lazy.lua        -- bootstraps lazy.nvim
    options.lua                 -- vim.opt.* settings
    keymaps.lua                 -- non-plugin mappings + diagnostic nav
    autocommands.lua            -- yank highlight, Makefile tabs, diagnostic float
    batch-movement.lua          -- legacy <C-u>/<C-d> thirds-of-screen jumper
    batch-movement-2.lua        -- newer version with floating top-padding window
    git-link.lua                -- :GitLink command
    repo_jump/jump.lua          -- parse GitHub blob URLs
    repo_jump/jump_spec.lua     -- tests (Busted)
    instrumentation/read_mappings_spec.lua  -- keymap-reader tests
  kickstart/health.lua          -- :checkhealth kickstart module
  plugins/                      -- one lazy.nvim spec per plugin (colorscheme, lsp,
                                --   telescope, treesitter, completion, dap,
                                --   neotest, harpoon, oil, trouble, mini, ...)
.github/workflows/stylua.yml    -- stylua --check on pull_request_target
```

## Bootstrap order (`init.lua`)

Leader keys **must** be set before plugins load. The required order is:

1. `vim.g.mapleader = ' '`, `vim.g.maplocalleader = ' '`, `vim.g.have_nerd_font = true`
2. `custom.batch-movement` or `custom.batch-movement-2` — selected by the `batch_movement = 'old' | 'new'` toggle at the top of `init.lua`
3. `custom.options`
4. `custom.keymaps`
5. `custom.autocommands`
6. `custom._initialize-lazy` — clones lazy.nvim if needed, calls `lazy.setup` which picks up `lua/plugins/*.lua`
7. `custom.git-link`

If you add a new custom module that produces side effects, wire it in here.

## The `register()` module pattern

Every non-spec file under `lua/custom/` returns a zero-arg function that performs its side effects when called. `init.lua` invokes them as `require('custom.foo')()`.

```lua
local function register()
  -- vim.opt / vim.keymap.set / vim.api.nvim_create_autocmd / ...
end

return register
```

Do not execute side effects at module top level. Keep them inside `register`.

## Plugin spec conventions (`lua/plugins/`)

- One file per plugin, returning a lazy.nvim spec table (or a list of specs).
- Prefer lazy-loading triggers: `event`, `cmd`, `keys`, `ft`.
- Every entry in `keys = { ... }` must include a `desc` so which-key renders it.
- Use `opts = { ... }` when setup is a straight pass-through; use `config = function() ... end` when setup needs logic (registering keymaps after `require`, etc.).
- LSP servers, formatters, linters, and debuggers are installed via mason — add new ones in `lua/plugins/lsp.lua` (`ensure_installed`) rather than expecting the user to install them manually.

## Keymap conventions

Leader and localleader are both `<Space>`. Prefix groups (documented via which-key):

| Prefix         | Area                                      |
| -------------- | ----------------------------------------- |
| `<leader>s*`   | telescope search (files, grep, help, ...) |
| `<leader>c*`   | code actions / LSP symbols                |
| `<leader>d*`   | document symbols / debug (DAP)            |
| `<leader>r*`   | refactoring                               |
| `<leader>w*`   | workspace                                 |
| `<leader>n*`   | harpoon                                   |
| `<leader>x*`   | trouble (diagnostics list)                |
| `<leader>t*`   | tests / toggles                           |

Other standing mappings:

- Window navigation: `<C-h/j/k/l>`
- Terminal exit: `<Esc><Esc>`
- Diagnostic nav: `[d` / `]d`, `<leader>e` (float), `<leader>q` (quickfix)
- Clear search highlight: `<Esc>`

## Testing

- Framework: plenary.nvim's `PlenaryBustedDirectory` (Busted-compatible syntax).
- File naming: `*_spec.lua`, colocated with the module under test (e.g. `repo_jump/jump.lua` + `repo_jump/jump_spec.lua`).
- Run all: `make test`
- Run a subset: `make test TEST_FILE=lua/custom/repo_jump/`
- Under the hood: `nvim --headless -c "PlenaryBustedDirectory $(TEST_FILE)"`
- Globals (`describe`, `it`, `before_each`, `after_each`, `assert`) are already registered in `lua/plugins/lsp.lua` for `lua_ls`, so specs don't need extra LSP setup.

## Formatting

- Tool: **stylua**. Config: `stylua.toml` — 4 spaces, 88 col width, `quote_style = AutoPreferSingle`, `call_parentheses = Always`, `sort_requires` enabled.
- CI: `.github/workflows/stylua.yml` runs `stylua --check` on PRs. All Lua must pass or the PR is blocked.
- Editor integration: conform.nvim auto-formats `*.lua` on save with stylua (see `lua/plugins/conform.lua`).

## Adding a plugin — quick recipe

1. Create `lua/plugins/<name>.lua` returning a lazy spec.
2. Restart Neovim (or `:Lazy sync`); lazy.nvim updates `lazy-lock.json` — **commit the lockfile**.
3. Run stylua (save the file with conform on, or `stylua lua/plugins/<name>.lua`) before pushing.
4. If the plugin provides an LSP server/tool, add it to `ensure_installed` in `lua/plugins/lsp.lua` instead of documenting a manual install.

## Custom commands & features worth knowing

- `:GitLink` — range-aware; copies a GitHub blob URL (with `#Lx` or `#Lx-Ly`) for the current file/selection to the system clipboard. Source: `lua/custom/git-link.lua`.
- `:checkhealth kickstart` — verifies git, make, unzip, rg, and Neovim ≥ 0.9.4. Source: `lua/kickstart/health.lua`.
- `<leader>tp` — toggles the floating top-padding window from `batch-movement-2.lua`.
- `batch_movement` toggle at the top of `init.lua` — switches between the two `<C-u>`/`<C-d>` implementations.
- `repo_jump/jump.lua` exposes `explode_link(url)` and `dev_directory()` (reads `$PROJECTS_DIR`) — used by future "jump to repo from URL" tooling.

## What not to do

- Don't run side effects at module top level. Wrap them in a `register()` function.
- Don't hand-edit `lazy-lock.json`; let lazy.nvim regenerate it.
- Don't introduce tab indentation in Lua files — stylua enforces spaces.
- Don't add keymaps without a `desc` field (breaks which-key hints).
- Don't skip stylua — the `stylua.yml` workflow will fail the PR.
- Don't bypass the bootstrap order in `init.lua` (leader must precede plugin setup).
