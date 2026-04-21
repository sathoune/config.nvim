return {
    {
        src = 'https://github.com/nvim-tree/nvim-web-devicons',
    },
    {
        src = 'https://github.com/stevearc/oil.nvim',
        setup = function()
            require('oil').setup({
                column = { 'icon' },
                keymaps = {
                    ['<C-h>'] = false,
                    ['<M-h>'] = 'actions.select_split',
                },
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
        end,
    },
}
