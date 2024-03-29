local Module = {

  lazy_config = {
    -- Colorscheme
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine-main'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
}

return Module
