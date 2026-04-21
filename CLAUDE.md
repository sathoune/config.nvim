# CLAUDE.md

Guidance for Claude Code (and other AI assistants) working in this repo.

## Overview

Personal Neovim configuration forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), written in Lua. Requires Neovim **0.12+** (uses `vim.pack`, `vim.lsp.config`, `vim.lsp.enable`). Plugins are managed by the built-in `vim.pack` package manager via a thin loader at `lua/custom/plugins.lua`; binary tools (LSP servers, formatters, linters, debug adapters) are installed through mason. All personal code lives under `lua/custom/`; plugin specs live one-file-per-plugin under `lua/plugins/`.

Entry point: `init.lua`. Everything is reached from there.

**Keep this file up to date.** When you change bootstrap order, the module pattern, keymap prefixes, the test/format workflow, or add/remove a custom command, update the relevant section in the same commit. Don't record individual file names or plugin lists here — they drift too fast.

## Repository layout

```
init.lua            -- entry point; sets leader, loads modules in order
lua/custom/         -- personal modules; each exports a register() fn
lua/custom/*/       -- grouped features (repo_jump, instrumentation, ...)
lua/plugins/        -- one vim.pack spec per plugin
lua/kickstart/      -- upstream kickstart helpers (:checkhealth, ...)
doc/                -- vim help files
.github/workflows/  -- CI (stylua format check)
```

Use `Glob`/`ls` to discover current file names — don't rely on a hand-maintained file list here.

## Bootstrap order (`init.lua`)

Leader keys **must** be set before plugins load. The required order is:

1. `vim.g.mapleader = ' '`, `vim.g.maplocalleader = ' '`, `vim.g.have_nerd_font = true`
2. `custom.batch-movement` or `custom.batch-movement-2` — selected by the `batch_movement = 'old' | 'new'` toggle at the top of `init.lua`
3. `custom.options`
4. `custom.keymaps`
5. `custom.autocommands`
6. `custom.plugins` — discovers every `lua/plugins/*.lua`, flattens/dedupes, registers a `PackChanged` autocmd for build hooks, calls `vim.pack.add(...)` once, then runs every spec's `setup()`
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

Each file returns either a single spec table or a list of them. The loader in `lua/custom/plugins.lua` understands this shape:

```lua
{
  src     = 'https://github.com/user/repo',  -- required
  name    = 'optional-override',             -- defaults to repo basename
  version = 'branch|tag|sha',                -- or vim.version.range(...)
  setup   = function() ... end,              -- runs after vim.pack.add returns
  build   = function(ev) ... end,            -- fires on PackChanged install/update
}
```

- One file per plugin (or per tightly coupled bundle — e.g. dap, telescope, completion).
- Put post-install work in `build(ev)` — `ev.path` points at the plugin checkout. Build hooks dispatch through the `PackChanged` autocmd registered by the loader.
- Every keymap must include a `desc` field so which-key renders it. Register keymaps inside `setup` (not at module top level — see [What not to do](#what-not-to-do)).
- LSP servers, formatters, linters, and debuggers are installed via mason — add new ones to `ensure_installed` in `lua/plugins/lsp.lua` rather than expecting the user to install them manually.
- Pin churn-prone plugins with `version` (e.g. `nvim-treesitter` is pinned to `master` because the `main` branch dropped the classic `nvim-treesitter.configs` API).

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

- Framework: plenary.nvim's `PlenaryBustedFile` (Busted-compatible syntax).
- File naming: `*_spec.lua`, colocated with the module under test (e.g. `repo_jump/jump.lua` + `repo_jump/jump_spec.lua`).
- Run all: `make test`
- Run a subset: `make test TEST_FILE=lua/custom/repo_jump/`
- Under the hood: the `Makefile` finds every `*_spec.lua` under `TEST_FILE` and runs each in its own headless nvim invocation. `PlenaryBustedDirectory` crashes on Neovim 0.12 (plenary's multi-file `on_exit` handler calls `unpack` on large job results); per-file invocation keeps plenary on the single-path code path that streams output line-by-line.
- Globals (`describe`, `it`, `before_each`, `after_each`, `assert`) are already registered in `lua/plugins/lsp.lua` for `lua_ls`, so specs don't need extra LSP setup.

## Formatting

- Tool: **stylua**. Config: `stylua.toml` — 4 spaces, 88 col width, `quote_style = AutoPreferSingle`, `call_parentheses = Always`, `sort_requires` enabled.
- CI: `.github/workflows/stylua.yml` runs `stylua --check` on PRs. All Lua must pass or the PR is blocked.
- Editor integration: conform.nvim auto-formats `*.lua` on save with stylua (see `lua/plugins/conform.lua`).

## Adding a plugin — quick recipe

1. Create `lua/plugins/<name>.lua` returning a `{ src = 'https://github.com/...', setup = function() ... end }` spec (see [Plugin spec conventions](#plugin-spec-conventions-luaplugins)).
2. Restart Neovim. `vim.pack` clones the repo, runs any `build` hook, and writes `nvim-pack-lock.json` at the config root — **commit the lockfile**. Use `:h vim.pack` for the underlying API; `vim.pack.update()` refreshes pinned versions.
3. Run stylua (save with conform, or `stylua lua/plugins/<name>.lua`) before pushing.
4. If the plugin provides an LSP server/tool, add it to `ensure_installed` in `lua/plugins/lsp.lua` instead of documenting a manual install.

## Custom commands & features worth knowing

- `:GitLink` — range-aware; copies a GitHub blob URL (with `#Lx` or `#Lx-Ly`) for the current file/selection to the system clipboard. Source: `lua/custom/git-link.lua`.
- `:checkhealth kickstart` — verifies git, make, unzip, rg, and Neovim ≥ 0.9.4. Source: `lua/kickstart/health.lua`.
- `<leader>tp` — toggles the floating top-padding window from `batch-movement-2.lua`.
- `batch_movement` toggle at the top of `init.lua` — switches between the two `<C-u>`/`<C-d>` implementations.
- `repo_jump/jump.lua` exposes `explode_link(url)` and `dev_directory()` (reads `$PROJECTS_DIR`) — used by future "jump to repo from URL" tooling.

## What not to do

- Don't run side effects at module top level. Wrap them in a `register()` function (for `lua/custom/`) or `setup` (for `lua/plugins/`).
- Don't hand-edit `nvim-pack-lock.json`; let `vim.pack` regenerate it.
- Don't introduce tab indentation in Lua files — stylua enforces spaces.
- Don't add keymaps without a `desc` field (breaks which-key hints).
- Don't skip stylua — the `stylua.yml` workflow will fail the PR.
- Don't bypass the bootstrap order in `init.lua` (leader must precede plugin setup).
- Don't reintroduce `lazy.nvim`, `mason-lspconfig`, or `neodev` — all three were removed (replaced by `vim.pack`, native `vim.lsp.config` / `vim.lsp.enable`, and `lazydev.nvim` respectively). Check `:h vim.pack` and `:h vim.lsp.enable` before proposing alternatives.
