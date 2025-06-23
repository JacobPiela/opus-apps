HexPatterns = {}


local pattern_table = {}
local miniAngles = {
    E  = "EAST",
    NE = "NORTH_EAST",
    NW = "NORTH_WEST",
    W  = "WEST",
    SW = "SOUTH_WEST",
    SE = "SOUTH_EAST"
}

local f = fs.open("/packages/hex/hexmanager/data/patterns.csv", "r")
assert(f ~= nil)
while true do
    local line = f.readLine()
    if not line then break end
    local pattern = {}
    local patternStrings = string.gmatch(line, "([^,]+),%s*")
    pattern.translation = patternStrings()
    pattern.direction = miniAngles[patternStrings()]
    pattern.pattern = patternStrings()
    if patternStrings() == "1" then
        pattern.is_great = "true"
    else
        pattern.is_great = "false"
    end
    pattern.name = patternStrings()

    table.insert(pattern_table, pattern)
end
f.close()



function HexPatterns.from_translation(name)
    for _,pattern in ipairs(pattern_table) do
        if pattern.translation == name then
            return pattern
        end
    end
    return nil
end

function HexPatterns.from_short_name(name)
    for _,pattern in ipairs(pattern_table) do
        if pattern.name == name then
            return pattern
        end
    end
    return nil
end

function HexPatterns.from_name(name)
    return HexPatterns.from_translation(name) or HexPatterns.from_short_name(name)
end

function HexPatterns.from_angles(angles)
    for _,pattern in ipairs(pattern_table) do
        if pattern.pattern == angles then
            return pattern
        end
    end
    return nil
end

function HexPatterns.is_dynamic(pattern)
    -- The == 'true' is necessary because pattern.is_great is a string and is still true when 'false'
    return pattern.is_great == 'true' or pattern.pattern == ''
end
