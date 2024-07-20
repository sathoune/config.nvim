local Module = {
    'p5quared/apple-music.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = true,
    keys = function()
        local plugin = require 'apple-music'
        local my_keys = {
            {
                '<leader>amp',
                plugin.toggle_play,
                desc = 'Toggle [P]layback',
            },
            {
                '<leader>ams',
                plugin.toggle_shuffle,
                desc = 'Toggle [S]huffle',
            },
            {
                '<leader>fp',
                plugin.select_playlist_telescope,
                desc = '[F]ind [P]laylists',
            },
            {
                '<leader>fa',
                plugin.select_album_telescope,
                desc = '[F]ind [A]lbum',
            },
            {
                '<leader>fs',
                plugin.select_track_telescope,
                desc = '[F]ind [S]ong',
            },
            {
                '<leader>amx',
                plugin.cleanup_all,
                desc = 'Cleanup Temp Playlists',
            },
        }
        return my_keys
    end,
}

return Module
