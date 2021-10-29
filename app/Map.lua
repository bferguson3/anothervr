--Map.lua
local _MAPWIDTH = 20
local _MAPHEIGHT = 20

local lovr = require 'lovr'
local fs = lovr.filesystem 

local Tile = require 'Tile'

local Map = {}
Map.tiles = {}
--for i=1,(_MAPWIDTH * _MAPHEIGHT) do 
--    table.insert(Map.tiles, Tile:new())
--end
local map_mt = { __index = Map }

function Map:new(filename)
    local o = {}
    o.tiles = {}
    --for i=1,(_MAPWIDTH * _MAPHEIGHT) do 
    --    table.insert(o.tiles, Tile:new())
    --end 

    mapstring = fs.read(filename)
    for c in mapstring:gmatch('%d+') do 
        table.insert(o.tiles, Tile:new(c))
    end
    
    setmetatable(o, map_mt) 
    return o 
end 

return Map 