local Module = {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    config = function()
        local harpoon = require 'harpoon'
        harpoon:setup()

        vim.keymap.set('n', '<leader>a', function()
            harpoon:list():add()
        end)
        vim.keymap.set('n', '<C-e>', function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        -- Quick picks
        vim.keymap.set('n', '<C-h>', function()
            harpoon:list():select(1)
        end)
        vim.keymap.set('n', '<C-t>', function()
            harpoon:list():select(2)
        end)
        vim.keymap.set('n', '<C-n>', function()
            harpoon:list():select(3)
        end)
        vim.keymap.set('n', '<C-s>', function()
            harpoon:list():select(4)
        end)

        vim.keymap.set('n', '<C-S-P>', function()
            harpoon:list():prev()
        end)
        vim.keymap.set('n', '<C-S-N>', function()
            harpoon:list():next()
        end)

        -- Configure Telescope UI
        local telescope_conf = require('telescope.config').values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require('telescope.pickers')
                .new({}, {
                    prompt_title = 'Harpoon',
                    finder = require('telescope.finders').new_table {
                        results = file_paths,
                    },
                    previewers = telescope_conf.file_previewer {},
                    sorter = telescope_conf.generic_sorter {},
                })
                :find()
        end

        vim.keymap.set('n', '<C-e>', function()
            toggle_telescope(harpoon:list())
        end)
    end,
}

return Module
