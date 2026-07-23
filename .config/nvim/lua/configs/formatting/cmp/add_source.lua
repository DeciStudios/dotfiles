local cmp = require('cmp')

local function does_source_exist(sourceName)
    local config = cmp.get_config()
    for i, source in ipairs(config.sources) do
        if source.name == sourceName then
            return true, i
        end
    end
    return false, -1
end

local function add_source(source)
    local config = cmp.get_config()
    local exists, index = does_source_exist(source.name)
    if exists then
        for k, v in pairs(source) do
            config.sources[index][k] = v
        end
    else
        table.insert(config.sources, source)
    end
    cmp.setup(config)
end

return add_source
