local Module = {
    -- Colorscheme
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    opts = {
        styles = {
            transparency = true,
        },
    },
    init = function()
        vim.cmd.colorscheme 'rose-pine-main'
        vim.cmd.hi 'Comment gui=none'
    end,
}

return Module
