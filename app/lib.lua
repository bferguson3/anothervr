
local lovr = require 'lovr'

-- taken from LuaUsers
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function include(fileName)
    local m = lovr.filesystem.load(fileName)
    m()
end

