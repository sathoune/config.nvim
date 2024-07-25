local lines_in_viewport = vim.api.nvim_win_get_height(0) - 1
local third_of_the_screen = math.ceil(lines_in_viewport / 3)

local function jump_down()
    local current_line = vim.fn.line '.'
    local lines_in_the_buffer = vim.fn.line '$'
    local distance = lines_in_the_buffer - current_line

    local first_line_in_viewport = vim.fn.line 'w0'
    local last_line_in_viewport = vim.fn.line 'w$'
    local visible_lines = last_line_in_viewport - first_line_in_viewport

    local cursor_at_the_last_line = distance == 0
    if cursor_at_the_last_line and visible_lines > lines_in_viewport / 2 then
        -- "virtual" move
        vim.api.nvim_input(third_of_the_screen .. '<C-e>')
    else
        vim.api.nvim_input(third_of_the_screen .. 'j')
    end
end

local function jump_up()
    local first_line_in_viewport = vim.fn.line 'w0'
    local last_line_in_viewport = vim.fn.line 'w$'
    local visible_lines = last_line_in_viewport - first_line_in_viewport

    local extra_lines = lines_in_viewport - visible_lines
    if extra_lines < lines_in_viewport / 2 then
        vim.api.nvim_input(third_of_the_screen .. 'k')
    else
        -- "virtual" move
        vim.api.nvim_input(third_of_the_screen .. '<C-y>')
    end
end

local function register()
    -- Minimal number of screen lines to keep above and below the cursor.
    vim.opt.scrolloff = third_of_the_screen
    vim.keymap.set('n', '<C-u>', jump_up, { noremap = true })
    vim.keymap.set('n', '<C-d>', jump_down, { noremap = true })
end

return register
