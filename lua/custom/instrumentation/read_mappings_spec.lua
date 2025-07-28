local function list_keymaps()
    local modes = {
        'n',
        'v',
        'V',
        '\x16', -- <C-V> / V-block
        'i',
        'c',
        't', -- terminal
        'R', -- replace
    }
    local result_table = {}
    for _, mode in ipairs(modes) do
        local mode_keymaps = vim.api.nvim_get_keymap(mode)
        result_table[mode] = mode_keymaps
    end
    return result_table
end

describe('List the keymaps', function()
    it('Gathers them all for me', function()
        local keymaps = list_keymaps()
        print(vim.inspect(keymaps))
    end)
end)
