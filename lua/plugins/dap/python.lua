local Module = {
  mappings = function()
    vim.keymap.set('n', '<leader>dpr', function()
      require('dap-python').test_method()
    end, { desc = '[D]ap [P]ython [R]un' })
  end,

  lazy_config = {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('dap-python').setup()
    end,
  },
}

return Module
