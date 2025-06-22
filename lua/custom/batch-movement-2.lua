local lines_in_viewport = vim.api.nvim_win_get_height(0) - 1
local third_of_the_screen = math.ceil(lines_in_viewport / 3)
local padding_win = nil
local padding_buf = nil

local function clear_window_ui(win, buf)
    vim.api.nvim_win_set_option(win, 'number', false)
    vim.api.nvim_win_set_option(win, 'relativenumber', false)
    vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(win, 'cursorline', false)
    vim.api.nvim_win_set_option(win, 'foldcolumn', '0')
    vim.api.nvim_win_set_option(win, 'wrap', false)

    -- Hide end-of-buffer tildes
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'padding') -- optional
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

    -- To hide the ~ symbols (works in newer Neovim versions)
    vim.api.nvim_buf_set_option(buf, 'fillchars', 'eob: ')
end

local function add_top_padding()
    if padding_win and vim.api.nvim_win_is_valid(padding_win) then
        return -- Already added
    end

    -- Save the current window
    local main_win = vim.api.nvim_get_current_win()

    -- Create a new empty buffer
    padding_buf = vim.api.nvim_create_buf(false, true)

    -- Open a vertical split at the top with height 5
    local command = 'topleft ' .. third_of_the_screen .. 'split'
    vim.cmd(command)
    padding_win = vim.api.nvim_get_current_win()

    vim.api.nvim_win_set_buf(padding_win, padding_buf)
    vim.api.nvim_buf_set_lines(padding_buf, 0, -1, false, {})

    -- Make the padding window unmodifiable and fixed height
    vim.api.nvim_buf_set_option(padding_buf, 'modifiable', false)
    vim.api.nvim_win_set_option(padding_win, 'winfixheight', true)

    clear_window_ui(padding_win, padding_buf)

    -- Go back to the main window
    vim.api.nvim_set_current_win(main_win)
end

local function remove_top_padding()
    if padding_win and vim.api.nvim_win_is_valid(padding_win) then
        vim.api.nvim_win_close(padding_win, true)
    end
    padding_buf = nil
    padding_win = nil
end

local function jump_down()
    local current_line = vim.fn.line '.'
    local lines_in_the_buffer = vim.fn.line '$'
    local distance = lines_in_the_buffer - current_line

    local first_line_in_viewport = vim.fn.line 'w0'
    local last_line_in_viewport = vim.fn.line 'w$'
    local visible_lines = last_line_in_viewport - first_line_in_viewport

    local cursor_at_the_last_line = distance == 0

    if current_line == 1 then
        remove_top_padding()
    end

    if cursor_at_the_last_line and visible_lines > lines_in_viewport / 2 then
        vim.api.nvim_input(third_of_the_screen .. '<C-e>')
    else
        vim.api.nvim_input(third_of_the_screen .. 'j')
    end
end

local function jump_up()
    local current_line = vim.fn.line '.'
    local first_line_in_viewport = vim.fn.line 'w0'
    local last_line_in_viewport = vim.fn.line 'w$'
    local visible_lines = last_line_in_viewport - first_line_in_viewport

    local extra_lines = lines_in_viewport - visible_lines

    if current_line == 1 then
        add_top_padding()
    elseif extra_lines < lines_in_viewport / 2 then
        vim.api.nvim_input(third_of_the_screen .. 'k')
    else
        vim.api.nvim_input(third_of_the_screen .. '<C-y>')
    end
end

local function register()
    vim.opt.scrolloff = third_of_the_screen
    vim.keymap.set('n', '<C-u>', jump_up, { noremap = true })
    vim.keymap.set('n', '<C-d>', jump_down, { noremap = true })

    -- Add top padding immediately
    -- add_top_padding()

    -- Optional: toggle key to remove/add padding manually
    vim.keymap.set('n', '<Leader>tp', function()
        if padding_win and vim.api.nvim_win_is_valid(padding_win) then
            remove_top_padding()
        else
            add_top_padding()
        end
    end, { noremap = true, desc = 'Toggle Top Padding' })
end

return register
