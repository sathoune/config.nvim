-- LSP servers we want enabled (and installed via mason).
local lsp_servers = {
    'ruff',
    'basedpyright',
    'gopls',
    'ts_ls',
    'lua_ls',
}

-- Formatters and linters (not LSPs) installed via mason-tool-installer.
local extra_tools = {
    'mypy',
    'stylua',
    'prettier',
}

local function install_tools()
    require('mason').setup()
    local ensure_installed = {}
    vim.list_extend(ensure_installed, lsp_servers)
    vim.list_extend(ensure_installed, extra_tools)
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
end

local function setup_lsp_attach_keymaps()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
            local map = function(keys, func, desc)
                vim.keymap.set(
                    'n',
                    keys,
                    func,
                    { buffer = event.buf, desc = 'LSP: ' .. desc }
                )
            end

            map(
                'gd',
                require('telescope.builtin').lsp_definitions,
                '[G]oto [D]efinition'
            )
            map(
                'gr',
                require('telescope.builtin').lsp_references,
                '[G]oto [R]eferences'
            )
            map(
                'gI',
                require('telescope.builtin').lsp_implementations,
                '[G]oto [I]mplementation'
            )
            map(
                '<leader>D',
                require('telescope.builtin').lsp_type_definitions,
                'Type [D]efinition'
            )
            map(
                '<leader>ds',
                require('telescope.builtin').lsp_document_symbols,
                '[D]ocument [S]ymbols'
            )
            map(
                '<leader>ws',
                require('telescope.builtin').lsp_dynamic_workspace_symbols,
                '[W]orkspace [S]ymbols'
            )
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            map('K', vim.lsp.buf.hover, 'Hover Documentation')
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end,
    })
end

return {
    { src = 'https://github.com/williamboman/mason.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    {
        src = 'https://github.com/j-hui/fidget.nvim',
        setup = function()
            require('fidget').setup({})
        end,
    },
    {
        -- nvim-lspconfig ships default server configs (cmd, root_markers,
        -- filetypes) via after/lsp/*.lua, which Neovim 0.11+ auto-loads.
        -- vim.lsp.config() overlays our overrides on top.
        src = 'https://github.com/neovim/nvim-lspconfig',
        setup = function()
            setup_lsp_attach_keymaps()
            install_tools()

            -- Broadcast nvim-cmp's extra capabilities (snippet support, etc.)
            -- to every server via the '*' default config.
            local capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities()
            )
            vim.lsp.config('*', { capabilities = capabilities })

            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                -- vim globals
                                'vim',
                                -- Busted globals
                                'describe',
                                'it',
                                'before_each',
                                'after_each',
                                'assert',
                            },
                        },
                        runtime = { version = 'LuaJIT' },
                        completion = { callSnippet = 'Replace' },
                        -- Neovim stdpath libraries come from lazydev.nvim.
                    },
                },
            })

            vim.lsp.enable(lsp_servers)
        end,
    },
}
