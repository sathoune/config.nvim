return {
    { src = 'https://github.com/nvim-neotest/nvim-nio' },
    { src = 'https://github.com/rcarriga/nvim-dap-ui' },
    { src = 'https://github.com/leoluz/nvim-dap-go' },
    { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim' },
    {
        src = 'https://github.com/mfussenegger/nvim-dap-python',
        setup = function()
            vim.keymap.set('n', '<leader>dpr', function()
                require('dap-python').test_method()
            end, { desc = '[D]ap [P]ython [R]un' })
        end,
    },
    {
        src = 'https://github.com/mfussenegger/nvim-dap',
        setup = function()
            require('mason-nvim-dap').setup({
                automatic_setup = true,
                handlers = {},
                ensure_installed = { 'delve' },
            })

            local dap = require('dap')
            local dapui = require('dapui')
            vim.keymap.set(
                'n',
                '<leader>db',
                '<cmd> DapToggleBreakpoint <CR>',
                { desc = '[D]ap Toggle [B]reakpoint' }
            )
            vim.keymap.set(
                'n',
                '<leader>dn',
                '<cmd> DapContinue <CR>',
                { desc = '[D]ap Co[N]tinue' }
            )
            vim.keymap.set(
                'n',
                '<leader>dr',
                '<cmd> DapRestartFrame <CR>',
                { desc = '[D]ap [R]estart' }
            )
            vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Toggle DAP' })

            dapui.setup()
            dap.listeners.after.event_initialized['dapui_config'] = dapui.open

            vim.keymap.set('n', '<leader>dq', dapui.close, { desc = '[D]ap [Q]uit' })
            require('dap-go').setup()
            local dap_python = require('dap-python')
            dap_python.test_runner = 'pytest'
            dap_python.setup()
        end,
    },
}
