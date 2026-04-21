return {
    src = 'https://github.com/echasnovski/mini.nvim',
    setup = function()
        -- Better Around/Inside textobjects.
        --  va)   - [V]isually select [A]round [)]paren
        --  yinq  - [Y]ank [I]nside [N]ext [']quote
        --  ci'   - [C]hange [I]nside [']quote
        require('mini.ai').setup({ n_lines = 500 })

        -- Add/delete/replace surroundings.
        --  saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        --  sd'   - [S]urround [D]elete [']quotes
        --  sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()
        require('mini.diff').setup()
        require('mini.jump').setup()
        require('mini.splitjoin').setup()

        local statusline = require('mini.statusline')
        statusline.setup({ use_icons = vim.g.have_nerd_font })
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return '%2l:%-2v'
        end
    end,
}
