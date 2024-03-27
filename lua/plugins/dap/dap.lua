local Module = {
  mappings = function()
    vim.keymap.set('n', '<leader>db', '<cmd> DapToggleBreakpoint <CR>', { desc = '[D]ap Toggle [B]reakpoint' })
  end,

  lazy_config = {
    'mfussenegger/nvim-dap',
    configurations = {

      python = {

        type = 'python',
        request = 'launch',
        name = 'Launch file',
      },
    },
  },
}

return Module
