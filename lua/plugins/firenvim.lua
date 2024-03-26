local Module = {
  global_overrides = function()
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
  end,

  config_overrides = function()
    if vim.g.started_by_firenvim then
      vim.opt.number = false
      vim.opt.relativenumber = false
    end
  end,

  lazy_config = {
    'glacambre/firenvim',
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn['firenvim#install'](0)
    end,
  },
}

return Module
