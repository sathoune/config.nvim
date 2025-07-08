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

    -- Convert SSH -> HTTPS if needed
    if remote_url:match '^git@' then
        remote_url = remote_url:gsub('git@([^:]+):', 'https://%1/')
    end
    -- Remove .git suffix if present
    remote_url = remote_url:gsub('%.git$', '')
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
    if not root then
        return nil
    end
    return full_path:sub(#root + 2)
end

local function generate_git_url()
    local file = get_relative_file_path()
    local branch = get_git_branch()
    local remote = get_git_remote_url()
    if not (file and branch and remote) then
        vim.notify('Not a git repo or missing info', vim.log.levels.ERROR)
        return
    end

    local line = vim.fn.line '.'
    local url = string.format('%s/blob/%s/%s#L%d', remote, branch, file, line)

    vim.fn.setreg('+', url) -- copy to system clipboard
    print('Copied URL: ' .. url)
end

local function register()
    vim.api.nvim_create_user_command('GitLink', generate_git_url, {})
end

return register
