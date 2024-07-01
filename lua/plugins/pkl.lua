local Module = {
    'apple/pkl-neovim',
    lazy = true,
    event = {
        'BufReadPre *.pkl',
        'BufReadPre *.pcf',
        'BufReadPre PklProject',
    },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    build = function()
        vim.cmd 'TSInstall! pkl'
    end,
}

return Module
