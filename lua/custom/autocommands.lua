local function register()
    -- [[ Basic Autocommands ]]
    --  See `:help lua-guide-autocommands`

    vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
            vim.diagnostic.open_float(nil, { focus = false })
        end,
    })

    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

return register
