local Module = {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        vim.keymap.set('x', '<leader>re', function()
            require('refactoring').refactor 'Extract Function'
        end, { desc = 'Extract function' })
        vim.keymap.set('x', '<leader>rf', function()
            require('refactoring').refactor 'Extract Function To File'
        end, { desc = 'Extract Function To a File' })
        -- Extract function supports only visual mode
        vim.keymap.set('x', '<leader>rv', function()
            require('refactoring').refactor 'Extract Variable'
        end, { desc = 'Extract Variable' })
        -- Extract variable supports only visual mode
        vim.keymap.set('n', '<leader>rI', function()
            require('refactoring').refactor 'Inline Function'
        end, { desc = 'Inline Function' })
        -- Inline func supports only normal
        vim.keymap.set({ 'n', 'x' }, '<leader>ri', function()
            require('refactoring').refactor 'Inline Variable'
        end, { desc = 'Inline Variable' })
        -- Inline var supports both normal and visual mode

        vim.keymap.set('n', '<leader>rb', function()
            require('refactoring').refactor 'Extract Block'
        end, { desc = 'Extract Block' })
        vim.keymap.set('n', '<leader>rbf', function()
            require('refactoring').refactor 'Extract Block To File'
        end, { desc = 'Extract Block To File' })
        -- Extract block supports only normal mode
    end,
}

return Module
