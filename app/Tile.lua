--Tile.lua
local go = require 'GameObject'

local Tile = go:new()
Tile.type = 0
local Tile_mt = { __index = Tile }

function Tile:new(id)
    local o = go:new()
    o.type = tonumber(id) or 0

    setmetatable(o, Tile_mt) 
    return o 
end

return Tile 