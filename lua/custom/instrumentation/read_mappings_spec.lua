local function list_keymaps(function_that_fetches_keymaps)
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
        result_table[mode] = function_that_fetches_keymaps(mode)
    end

    return result_table
end

local function my_keymap_getter_factory(keymap)
    local function keymap_getter(mode)
        return keymap[mode]
    end
    return keymap_getter
end

describe('List the keymaps', function()
    it('Gathers keymaps with nvim api', function()
        local nvim_function_for_keymaps = vim.api.nvim_get_keymap
        local keymaps = list_keymaps(nvim_function_for_keymaps)
        print(vim.inspect(keymaps))
    end)

    it('Gathers keymaps with my own function', function()
        local custom_keymap = {
            n = { { lhs = 'd', rhs = 'abc' } },
            i = { { lhs = 'e', rhs = 'cde' } },
        }
        local keymap_getter = my_keymap_getter_factory(custom_keymap)
        local found_keymaps = list_keymaps(keymap_getter)

        assert.same(custom_keymap, found_keymaps)
    end)
end)
