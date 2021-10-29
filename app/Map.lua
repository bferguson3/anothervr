--Map.lua
--local _MAPWIDTH = 20
--local _MAPHEIGHT = 20

local lovr = require 'lovr'
local globals = require 'globals'
local fs = lovr.filesystem 
local Tile = require 'Tile'

local Map = {}
Map.tiles = {}
--for i=1,(_MAPWIDTH * _MAPHEIGHT) do
--    table.insert(Map.tiles, Tile:new())
--end
local map_mt = { __index = Map }


function Map:init()
    for y=1,20 do 
        for i=1,20 do -- -10 to 10
            self.tiles[ ((y-1)*20) + i ].x = (-11 + i) * 2
            self.tiles[ ((y-1)*20) + i ].y = -1
            self.tiles[ ((y-1)*20) + i ].z = (-11 + y) * 2 
            self.tiles[ ((y-1)*20) + i].model = lovr.graphics.newModel('models/cube.obj')
        end
    end
    --table.insert(globals.drawables, self)
end

function Map:draw()
    for i=1,#self.tiles do 
        lovr.graphics.setColor(0.5, 1, 1, 1)
        self.tiles[i]:draw()
    end 
end


function Map:new(filename)
    local o = {}
    o.tiles = {}
    --for i=1,(_MAPWIDTH * _MAPHEIGHT) do
    --    table.insert(o.tiles, Tile:new())
    --end

    local mapstring = fs.read(filename)
    for c in mapstring:gmatch('%d+') do 
        table.insert(o.tiles, Tile:new(c))
    end
    
    setmetatable(o, map_mt) 
    return o 
end 

return Map 