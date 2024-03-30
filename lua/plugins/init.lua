local Module = {
  require('plugins.colorscheme').lazy_config,
  require('plugins.firenvim').lazy_config,
  require('plugins.dap.main').lazy_config,
  require('plugins.telescope').lazy_config,
  require('plugins.lsp').lazy_config,
  require('plugins.completion').lazy_config,
}

return Module
