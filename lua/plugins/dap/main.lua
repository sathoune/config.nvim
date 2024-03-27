local Module = {
  mappings = function()
    require('plugins.dap.dap').mappings()
    require('plugins.dap.python').mappings()
  end,

  lazy_config = {
    require('plugins.dap.dap').lazy_config,
    require('plugins.dap.python').lazy_config,
    require('plugins.dap.ui').lazy_config,
  },
}

return Module
