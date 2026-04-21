return {
    {
        src = 'https://github.com/nvim-lua/plenary.nvim',
    },
    {
        src = 'https://github.com/ThePrimeagen/harpoon',
        version = 'harpoon2',
        setup = function()
            local harpoon = require('harpoon')
            harpoon:setup()

            vim.keymap.set('n', '<leader>a', function()
                harpoon:list():add()
            end)
            vim.keymap.set('n', '<C-a>', function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { noremap = true, desc = 'harpoon menu' })

            for i, key in ipairs({ 'h', 't', 'n', 's' }) do
                vim.keymap.set('n', '<leader>n' .. key, function()
                    harpoon:list():select(i)
                end, { desc = 'harpoon ' .. i .. '.' })
            end

            vim.keymap.set('n', '<leader>n<C-n>', function()
                harpoon:list():next()
            end, { desc = 'harpoon next' })
            vim.keymap.set('n', '<leader>n<C-p>', function()
                harpoon:list():prev()
            end, { desc = 'harpoon prev' })
        end,
    },
}
