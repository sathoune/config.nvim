local Module = {
  -- Colorscheme
  'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup {
      styles = {
        transparency = true,
      },
    }

    vim.cmd.colorscheme 'rose-pine-main'
    vim.cmd.hi 'Comment gui=none'
  end,
}

return Module
