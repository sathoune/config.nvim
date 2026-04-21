return {
    {
        src = 'https://github.com/lukas-reineke/indent-blankline.nvim',
        setup = function()
            require('ibl').setup({})
        end,
    },
    { src = 'https://github.com/tpope/vim-sleuth' },
    {
        src = 'https://github.com/folke/lazydev.nvim',
        setup = function()
            require('lazydev').setup({
                library = {
                    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                    'nvim-dap-ui',
                },
            })
        end,
    },
    {
        src = 'https://github.com/numToStr/Comment.nvim',
        setup = function()
            require('Comment').setup({})
        end,
    },
    {
        src = 'https://github.com/lewis6991/gitsigns.nvim',
        setup = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
            })
        end,
    },
    {
        src = 'https://github.com/folke/which-key.nvim',
        setup = function()
            local which_key = require('which-key')
            which_key.setup()
            which_key.add({
                { '<leader>c', group = '[C]ode' },
                { '<leader>c_', hidden = true },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>d_', hidden = true },
                { '<leader>r', group = '[R]ename' },
                { '<leader>r_', hidden = true },
                { '<leader>s', group = '[S]earch' },
                { '<leader>s_', hidden = true },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>w_', hidden = true },
                { '<leader>n', group = 'Harpoo[n]' },
                { '<leader>n_', hidden = true },
            })
        end,
    },
    {
        src = 'https://github.com/folke/todo-comments.nvim',
        setup = function()
            require('todo-comments').setup({ signs = false })
        end,
    },
    {
        src = 'https://github.com/windwp/nvim-autopairs',
        setup = function()
            require('nvim-autopairs').setup({})
        end,
    },
}
