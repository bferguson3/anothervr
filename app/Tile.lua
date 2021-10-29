--Tile.lua

local Tile = {}
Tile.type = 0

local Tile_mt = { __index = Tile }

function Tile:new(id)
    local o = {}
    o.type = id or 0

    setmetatable(o, Tile_mt) 
    return o 
end

return Tile 