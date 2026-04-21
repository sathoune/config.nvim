return {
    -- Pin to the classic API branch; `main` reworked the setup surface and
    -- no longer exposes `nvim-treesitter.configs`.
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'master',
    build = function(ev)
        -- `:TSUpdate` is defined by the plugin itself, so it exists by the
        -- time PackChanged fires.
        pcall(vim.cmd, 'TSUpdate')
    end,
    setup = function()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'bash',
                'c',
                'html',
                'lua',
                'markdown',
                'vim',
                'vimdoc',
                'python',
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end,
}
