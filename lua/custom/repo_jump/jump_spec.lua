local function explode_link(url)
    local user, repo, branch, path, line =
        url:match 'https://github.com/([^/]+)/([^/]+)/blob/([^/]+)/(.-)#L(%d+)'

    if not (user and repo and branch and path and line) then
        error('Failed to parse GitHub URL: ' .. url)
    end

    return {
        repo = repo,
        branch = branch,
        file = path,
        line = tonumber(line),
    }
end

describe('Exploding links', function()
    it('Extracts path elements', function()
        local example_url =
            'https://github.com/neovim/neovim/blob/master/src/nvim/buffer.c#L129'
        local expected_target = {
            repo = 'neovim',
            branch = 'master',
            file = 'src/nvim/buffer.c',
            line = 129,
        }

        local results = explode_link(example_url)
        assert.same(expected_target, results)
    end)
end)
