local Module = {
    -- Autoformat
    'stevearc/conform.nvim',
    opts = {
        notify_on_error = false,
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters_by_ft = {
            lua = { 'stylua' },
            -- Conform can also run multiple formatters sequentially
            python = { 'isort', 'black', 'ruff', 'mypy' },
            go = {
                'goimports',
                'gofmt',
            },
            markdown = { 'prettier' },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            javascript = { { 'prettierd', 'prettier' } },
            json = { 'prettier' },
            html = { 'prettier' },
        },
    },
}

return Module
