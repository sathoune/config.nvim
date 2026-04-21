return {
    src = 'https://github.com/rose-pine/neovim',
    name = 'rose-pine',
    setup = function()
        require('rose-pine').setup({
            styles = {
                transparency = true,
            },
        })
        vim.cmd.colorscheme('rose-pine-main')
        vim.cmd.hi('Comment gui=none')
    end,
}
