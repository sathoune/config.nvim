local Module = {
    { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
    },
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    {
        'folke/neodev.nvim',
        opts = {},
        config = function()
            require('neodev').setup {
                library = { plugins = { 'nvim-dap-ui' }, types = true },
            }
        end,
    },
    { 'numToStr/Comment.nvim', opts = {} },
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },
    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            -- Document existing key chains
            require('which-key').add {
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
            }
        end,
    },
    { -- Highlight todo, notes, etc in comments
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },
}

return Module
