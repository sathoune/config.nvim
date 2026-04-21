-- Plugin loader backed by Neovim's built-in `vim.pack` (0.12+).
--
-- Each file under `lua/plugins/` returns either a single spec or a list of
-- specs. A spec has the shape:
--
--   {
--     src = 'https://github.com/user/repo',  -- required
--     name    = 'optional-override',         -- defaults to repo basename
--     version = 'branch|tag|sha',            -- or vim.version.range(...)
--     setup   = function() ... end,          -- runs after all plugins load
--     build   = function(ev) ... end,        -- runs on install/update
--   }
--
-- The loader:
--  1. Discovers every `lua/plugins/*.lua` in this config.
--  2. Flattens and de-duplicates by `src`.
--  3. Registers a `PackChanged` autocmd to dispatch `build` hooks.
--  4. Calls `vim.pack.add(...)` once with the flattened list.
--  5. Invokes every `setup` in discovery order.

local function resolved_name(spec)
    if spec.name then
        return spec.name
    end
    local tail = spec.src:match('.*/([^/]+)$') or spec.src
    return (tail:gsub('%.git$', ''))
end

local function collect_specs()
    local specs = {}
    local seen_src = {}
    local config_root = vim.fs.normalize(vim.fn.stdpath('config')) .. '/lua/plugins/'

    local files = vim.api.nvim_get_runtime_file('lua/plugins/*.lua', true)
    table.sort(files)

    for _, file in ipairs(files) do
        local norm = vim.fs.normalize(file)
        -- Only pick up files owned by this config.
        if vim.startswith(norm, config_root) then
            local module = file:match('lua/(.*)%.lua$'):gsub('/', '.')
            local ok, mod = pcall(require, module)
            if not ok then
                vim.notify(
                    string.format('plugins: failed to load %s: %s', module, mod),
                    vim.log.levels.ERROR
                )
            else
                local items = mod.src and { mod } or mod
                for _, item in ipairs(items) do
                    if item.src and not seen_src[item.src] then
                        seen_src[item.src] = true
                        table.insert(specs, item)
                    end
                end
            end
        end
    end
    return specs
end

local function register()
    local specs = collect_specs()

    -- Index build hooks by resolved plugin name so PackChanged can dispatch.
    local hooks = {}
    for _, spec in ipairs(specs) do
        if spec.build then
            hooks[resolved_name(spec)] = spec.build
        end
    end

    -- Register BEFORE vim.pack.add() so install events fire into our hooks.
    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local kind = ev.data.kind
            if kind ~= 'install' and kind ~= 'update' then
                return
            end
            local build = hooks[ev.data.spec.name]
            if build then
                build(ev.data)
            end
        end,
    })

    local add_list = {}
    for _, spec in ipairs(specs) do
        local item = { src = spec.src }
        if spec.name then
            item.name = spec.name
        end
        if spec.version then
            item.version = spec.version
        end
        table.insert(add_list, item)
    end

    vim.pack.add(add_list, { load = true, confirm = false })

    for _, spec in ipairs(specs) do
        if spec.setup then
            local ok, err = pcall(spec.setup)
            if not ok then
                vim.notify(
                    string.format(
                        'plugins: setup for %s failed: %s',
                        resolved_name(spec),
                        err
                    ),
                    vim.log.levels.ERROR
                )
            end
        end
    end
end

return register
