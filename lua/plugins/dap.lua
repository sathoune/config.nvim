local dap_ui_config = {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'nvim-neotest/nvim-nio' },
}

local python = {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    config = function()
        vim.keymap.set('n', '<leader>dpr', function()
            require('dap-python').test_method()
        end, { desc = '[D]ap [P]ython [R]un' })
    end,
}

local Module = {
    'mfussenegger/nvim-dap',
    dependencies = {
        dap_ui_config,
        python,
        'leoluz/nvim-dap-go',
        'jay-babu/mason-nvim-dap.nvim',
    },
    configurations = {
        python = {
            type = 'python',
            request = 'launch',
            name = 'Launch file',
        },
    },
    config = function()
        require('mason-nvim-dap').setup {
            automatic_setup = true,
            handlers = {},
            ensure_installed = { 'delve' },
        }

        local dap = require 'dap'
        local dapui = require 'dapui'
        vim.keymap.set(
            'n',
            '<leader>db',
            '<cmd> DapToggleBreakpoint <CR>',
            { desc = '[D]ap Toggle [B]reakpoint' }
        )
        vim.keymap.set('n', '<leader>dn', '<cmd> DapContinue <CR>', { desc = '[D]ap Co[N]tinue' })
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
        require('dap-python').setup()
    end,
}

return Module
