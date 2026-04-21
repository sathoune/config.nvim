return {
    src = 'https://github.com/apple/pkl-neovim',
    build = function()
        pcall(vim.cmd, 'TSInstall! pkl')
    end,
}
