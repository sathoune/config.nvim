return {
    { src = 'https://github.com/antoinemadec/FixCursorHold.nvim' },
    { src = 'https://github.com/nvim-neotest/neotest-python' },
    {
        src = 'https://github.com/nvim-neotest/neotest',
        setup = function()
            local neotest = require('neotest')
            neotest.setup({
                adapters = {
                    require('neotest-python'),
                },
            })

            vim.keymap.set(
                'n',
                '<leader>tr',
                neotest.run.run,
                { desc = 'run nearest function as a test' }
            )
            vim.keymap.set(
                'n',
                '<leader>tt',
                neotest.summary.toggle,
                { desc = 'toggle summary' }
            )
        end,
    },
}
