local M = {}

function M.explode_link(url)
    local base_pattern = 'https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.-)#L(%d+)'
    local range_pattern = base_pattern .. '-L(%d+)'

    local user, repo, branch, path, line_start, line_end = url:match(range_pattern)

    if not user then
        -- Fallback to single-line form
        user, repo, branch, path, line_start = url:match(base_pattern)
        line_end = line_start
    end

    if not (user and repo and branch and path and line_start) then
        error('Failed to parse GitHub URL: ' .. url)
    end

    return {
        repo = repo,
        branch = branch,
        file = path,
        line_start = tonumber(line_start),
        line_end = tonumber(line_end),
    }
end

function M.dev_directory()
    return os.getenv 'PROJECTS_DIR'
end

return M
