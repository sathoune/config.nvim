local function get_git_root()
    local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
    if not handle then
        return nil
    end
    local result = handle:read('*a'):gsub('%s+$', '')
    handle:close()
    return result ~= '' and result or nil
end

local function get_git_remote_url()
    local handle = io.popen 'git remote get-url origin 2>/dev/null'
    if not handle then
        return nil
    end
    local url = handle:read('*a'):gsub('%s+$', '')
    handle:close()

    -- Convert SSH -> HTTPS if needed
    if url:match '^git@' then
        url = url:gsub('git@([^:]+):', 'https://%1/')
    end
    -- Remove .git suffix if present
    url = url:gsub('%.git$', '')
    return url
end

local function get_git_branch()
    local handle = io.popen 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
    if not handle then
        return nil
    end
    local branch = handle:read('*a'):gsub('%s+$', '')
    handle:close()
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
