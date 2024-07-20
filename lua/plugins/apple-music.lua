local Module = {
    'p5quared/apple-music.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = true,
    keys = function()
        local plugin = require 'apple-music'
        return {
            { '<leader>mp', plugin.toggle_play, desc = 'Toggle [P]layback' },
            { '<leader>ms', plugin.toggle_shuffle, desc = 'Toggle [S]huffle' },
            { '<leader>mp', plugin.select_playlist_telescope, desc = '[F]ind [P]laylists' },
            { '<leader>ma', plugin.select_album_telescope, desc = '[F]ind [A]lbum' },
            { '<leader>ms', plugin.select_track_telescope, desc = '[F]ind [S]ong' },
            { '<leader>mx', plugin.cleanup_all, desc = 'Cleanup Temp Playlists' },
        }
    end,
}

return Module
