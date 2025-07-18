local function exec_command(command)
    local handle = io.popen(command)

    if not handle then
        local message = 'Result empty of command: ' .. command
        error(message)
    end

    local result = handle:read('*a'):gsub('%s+$', '')
    handle:close()
    return result
end

local function get_git_root()
    local command = 'git rev-parse --show-toplevel 2>/dev/null'
    local git_root = exec_command(command)

    if git_root == '' then
        error 'Absolute path empty. Likely not a git repo.'
    end

    return git_root
end

local function get_git_remote_url()
    local command = 'git remote get-url origin 2>/dev/null'
    local remote_url = exec_command(command)

    local starts_with_git = '^git@'
    local starts_with_ssh = '^ssh://git@'
    if remote_url:match(starts_with_git) then
        local find_hostname = 'git@([^:]+):'
        local paste_match = 'https://%1/'
        remote_url = remote_url:gsub(find_hostname, paste_match)
    elseif remote_url:match(starts_with_ssh) then
        remote_url = remote_url:gsub(starts_with_ssh, 'https://')
    end

    local git_suffix = '%.git$'
    remote_url = remote_url:gsub(git_suffix, '')
    return remote_url
end

local function get_git_branch()
    local command = 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
    local branch = exec_command(command)
    return branch
end

local function get_relative_file_path()
    local full_path = vim.fn.expand '%:p'
    local root = get_git_root()

    local root_path_length = #root + 1
    local skip_slash_in_path = 1

    return full_path:sub(root_path_length + skip_slash_in_path)
end

local function generate_git_url(range_start, range_end)
    local file = get_relative_file_path()
    local branch = get_git_branch()
    local remote = get_git_remote_url()
    if not (file and branch and remote) then
        vim.notify('Not a git repo or missing info', vim.log.levels.ERROR)
        return
    end

    -- If called without a range (normal mode), use current line
    local start_line = range_start or vim.fn.line '.'
    local end_line = range_end or start_line

    local line_fragment = '#L' .. start_line

    if start_line ~= end_line then
        line_fragment = line_fragment .. '-L' .. end_line
    end

    local url = remote .. '/blob/' .. branch .. '/' .. file .. line_fragment

    vim.fn.setreg('+', url) -- copy to system clipboard
    print('Copied URL: ' .. url)
end

local function pass_selection(func)
    local function wrapper(opts)
        func(opts.line1, opts.line2)
    end
    return wrapper
end

local function register()
    vim.api.nvim_create_user_command('GitLink', pass_selection(generate_git_url), { range = true })
end

return register
