local Module = {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
        { '-', '<CMD>Oil<CR>', { desc = 'Open parent directory ' } },
    },
    opts = {
        column = { 'icon' },
        keymaps = {
            ['<C-h>'] = false,
            ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
            show_hidden = true,
        },
    },
}

return Module
