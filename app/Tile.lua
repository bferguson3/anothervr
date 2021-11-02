--Tile.lua
local go = require 'GameObject'

local Tile = go:new()
Tile.type = 0
Tile.x = 0
Tile.z = 0
--Tile.transform = nil 
local Tile_mt = { __index = Tile }

function Tile:new(id, x, z) --, transform)
    local o = go:new()
    o.type = tonumber(id) or 0
    o.x = x or 0
    o.z = z or 0
    --o.transform = transform or nil 

    setmetatable(o, Tile_mt) 
    return o 
end

return Tile 