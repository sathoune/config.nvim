-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

local batch_movement = 'old'
if batch_movement == 'new' then
    require 'custom.batch-movement-2'()
else
    require 'custom.batch-movement'()
end
require 'custom.options'()
require 'custom.keymaps'()
require 'custom.autocommands'()

require 'custom._initialize-lazy'()
require 'custom.git-link'()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
