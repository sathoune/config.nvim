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
    local example_links = {
        {
            url = 'https://github.com/python-poetry/poetry/blob/main/src/poetry/factory.py#L122',
            expected_target = {
                repo = 'poetry',
                branch = 'main',
                file = 'src/poetry/factory.py',
                line = 122,
            },
            {

                url = 'https://github.com/neovim/neovim/blob/master/src/nvim/buffer.c#L129',
                expected_target = {
                    repo = 'neovim',
                    branch = 'master',
                    file = 'src/nvim/buffer.c',
                    line = 129,
                },
            },
            {
                url = 'https://github.com/charmbracelet/bubbletea/blob/main/tea.go#L45',
                expected_target = {
                    repo = 'bubbletea',
                    branch = 'main',
                    file = 'tea.go',
                    line = 45,
                },
            },
        },
    }
    it('Extracts path elements', function()
        for _, case in ipairs(example_links) do
            local results = explode_link(case.url)
            assert.same(case.expected_target, results)
        end
    end)
end)
