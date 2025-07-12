local function explode_link(url)
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
local function dev_directory()
    return os.getenv 'PROJECTS_DIR'
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

    it('Reads env vars', function()
        local expected_path = '~/projects/'

        local read_value = dev_directory()
        assert.equal(expected_path, read_value)
    end)
end)
