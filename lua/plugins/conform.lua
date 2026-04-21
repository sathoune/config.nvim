return {
    src = 'https://github.com/stevearc/conform.nvim',
    setup = function()
        require('conform').setup({
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                python = { 'isort', 'black', 'ruff', 'mypy' },
                go = { 'goimports', 'gofmt' },
                markdown = { 'prettier' },
                javascript = { { 'prettierd', 'prettier' } },
                json = { 'prettier' },
                html = { 'prettier' },
            },
        })
    end,
}
