local Module = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require 'harpoon'
        harpoon:setup()

        vim.keymap.set('n', '<leader>a', function()
            harpoon:list():add()
        end)
        vim.keymap.set('n', '<C-a>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, {
            noremap = true,
            desc = 'harpoon menu',
        })

        -- Quick picks
        vim.keymap.set('n', '<leader>nh', function()
            harpoon:list():select(1)
        end, { desc = 'harpoon 1.' })
        vim.keymap.set('n', '<leader>nt', function()
            harpoon:list():select(2)
        end, { desc = 'harpoon 2.' })
        vim.keymap.set('n', '<leader>nn', function()
            harpoon:list():select(3)
        end, { desc = 'harpoon 3.' })
        vim.keymap.set('n', '<leader>ns', function()
            harpoon:list():select(4)
        end, { desc = 'harpoon 4.' })

        vim.keymap.set('n', '<leader>n<C-n>', function()
            harpoon:list():next()
        end, { desc = 'harpoon next' })
        vim.keymap.set('n', '<leader>n<C-p>', function()
            harpoon:list():prev()
        end, { desc = 'harpoon prev' })
    end,
}

return Module
