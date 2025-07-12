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
        line_start = tonumber(line),
        line_end = tonumber(line),
    }
end

describe('Exploding links', function()
    local example_links = {
        base_case = {
            url = 'https://github.com/python-poetry/poetry/blob/main/src/poetry/factory.py#L122',
            expected_target = {
                repo = 'poetry',
                branch = 'main',
                file = 'src/poetry/factory.py',
                line_start = 122,
                line_end = 122,
            },
        },
        base_case_2 = {
            url = 'https://github.com/neovim/neovim/blob/master/src/nvim/buffer.c#L129',
            expected_target = {
                repo = 'neovim',
                branch = 'master',
                file = 'src/nvim/buffer.c',
                line_start = 129,
                line_end = 129,
            },
        },
        multiline = {
            url = 'https://github.com/charmbracelet/bubbletea/blob/main/tea.go#L45-L57',
            expected_target = {
                repo = 'bubbletea',
                branch = 'main',
                file = 'tea.go',
                line_start = 45,
                line_end = 57,
            },
        },
    }

    it('Extracts path elements', function()
        for _, case in pairs(example_links) do
            local results = explode_link(case.url)
            assert.same(case.expected_target, results)
        end
    end)
end)
