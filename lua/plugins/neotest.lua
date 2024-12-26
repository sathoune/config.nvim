local Module = {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-python',
    },
    config = function()
        local neotest = require 'neotest'
        neotest.setup {
            adapters = {
                require 'neotest-python',
            },
        }

        vim.keymap.set(
            'n',
            '<leader>tr',
            neotest.run.run,
            { desc = 'run nearest function as a test' }
        )
        vim.keymap.set('n', '<leader>to', neotest.summary.open, { desc = 'toggle summary' })
    end,
}

return Module
