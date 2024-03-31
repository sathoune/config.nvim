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

        vim.keymap.set(
            'n',
            '<leader>db',
            '<cmd> DapToggleBreakpoint <CR>',
            { desc = '[D]ap Toggle [B]reakpoint' }
        )

        local dap = require 'dap'
        local dapui = require 'dapui'
        dapui.setup()

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        require('dap-go').setup()
        require('dap-python').setup()
    end,
}

return Module
