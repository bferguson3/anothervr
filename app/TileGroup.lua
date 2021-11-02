--TileGroup.lua
local lovr = require 'lovr'
local gfx = lovr.graphics 

local TileGroup = {}
TileGroup.type = 0
TileGroup.tiles = {}
TileGroup.transforms = {}
TileGroup.texture = nil 

local TileGroup_mt = { __index = TileGroup }

function TileGroup:new(id, tiles, transforms) --
    local o = {}
    o.type = tonumber(id) or 0
    o.tiles = tiles or {}
    o.transforms = transforms or {}

    -- Get filename of texture based on 'id' and load it in
    local fn = 'models/tex_'
    if (o.type < 10) then
        fn = fn .. '0'
    end
    fn = fn .. id .. '.png'
    o.texture = gfx.newTexture(fn, { mipmaps = false })
    
    setmetatable(o, TileGroup_mt) 
    return o 
end

return TileGroup