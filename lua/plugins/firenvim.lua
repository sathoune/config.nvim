return {
    src = 'https://github.com/glacambre/firenvim',
    version = 'v0.2.16',
    build = function()
        -- Autoload isn't on rtp in headless/build context; pcall silences
        -- E117. The install side effect is browser-only anyway.
        pcall(vim.fn['firenvim#install'], 0)
    end,
    setup = function()
        vim.g.firenvim_config = {
            globalSettings = { alt = 'all' },
            localSettings = {
                ['.*'] = {
                    cmdline = 'neovim',
                    content = 'text',
                    priority = 0,
                    selector = 'textarea',
                    takeover = 'never',
                },
            },
        }

        if vim.g.started_by_firenvim then
            vim.api.nvim_create_autocmd({ 'UIEnter' }, {
                callback = function()
                    vim.opt.laststatus = 0
                    vim.opt.relativenumber = false

                    local i_prefer_more_lines_than = 5
                    local desired_lines_number = 6
                    local current_lines = vim.opt.lines['_value']
                    if i_prefer_more_lines_than >= current_lines then
                        vim.opt.lines = desired_lines_number
                    end
                end,
            })
        end
    end,
}
