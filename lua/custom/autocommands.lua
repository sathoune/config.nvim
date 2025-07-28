local function force_makefile_tabs()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'make',
        callback = function()
            vim.bo.expandtab = false -- use tab characters, not spaces
            vim.bo.shiftwidth = 8 -- shift size for >>, <<, etc.
            vim.bo.tabstop = 8 -- tab character width
            vim.bo.softtabstop = 0 -- disables space-like behavior
        end,
    })
end

local function highlight_yanked_text()
    -- Highlight when yanking (copying) text
    --  Try it with `yap` in normal mode
    --  See `:help vim.highlight.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup(
            'kickstart-highlight-yank',
            { clear = true }
        ),
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

local function display_diagnostics_automatically()
    vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
            vim.diagnostic.open_float(nil, { focus = false })
        end,
    })
end

local function register()
    -- [[ Basic Autocommands ]]
    --  See `:help lua-guide-autocommands`

    display_diagnostics_automatically()
    highlight_yanked_text()
    force_makefile_tabs()
end

return register
