local Module = {
    -- Colorscheme
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    opts = {
        styles = {
            -- Inherit background colour from terminal
            transparency = true,
        },
        palette = {
            main = {},
        },
    },
    init = function()
        vim.cmd.colorscheme 'rose-pine-main'
        vim.cmd.hi 'Comment gui=none'
    end,
}

return Module
