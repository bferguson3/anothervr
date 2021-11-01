--Map.lua
local _MAPWIDTH = 20
local _MAPHEIGHT = 20

local lovr = require 'lovr'
local fs = lovr.filesystem 
local Tile = require 'Tile'

local Map = {}
Map.tiles = {}
Map.tileGroups = {
    [1] = { type = 0, tiles = {} }
}
--for i=1,(_MAPWIDTH * _MAPHEIGHT) do
--    table.insert(Map.tiles, Tile:new())
--end
local map_mt = { __index = Map }


function Map:init()
    local groups = {}
    -- Check for all group types
    for i=1,#self.tiles do 
        if(list_contains(groups, self.tiles[i].type) == false) then 
            table.insert(groups, self.tiles[i].type)
        end
    end
    local tileGroups = {}
    -- make groups 
    for i=1,#groups do 
        local o = {}
        o.type = groups[i] 
        o.tiles = {}
        table.insert(tileGroups, o)
    end
    -- make tile groups 
    for i=1,#self.tiles do 
        for n=1,#tileGroups do 
            if tileGroups[n].type == self.tiles[i].type then 
                table.insert(tileGroups[n], self.tiles[i]) 
                n = #tileGroups 
            end
        end
    end
    self.tileGroups = tileGroups
    -- debug:
    --for i=1,#self.tileGroups do 
    --    for j=1,#self.tileGroups[i] do 
    --        lovr.filesystem.append('log5.txt', i .. ' ' .. j .. ' ' 
    --            .. self.tileGroups[i].type .. '(' .. self.tileGroups[i][j].type 
    --            .. ')  x: ' .. self.tileGroups[i][j].x .. '  z: ' .. self.tileGroups[i][j].z .. '\n')
    --    end
    --end
    -- done with tiles. force clean.
    self.tiles = nil 
end

function Map:draw()
    for i=1,#self.tiles do 
        --lovr.graphics.setColor(0.5, 1, 1, 1)
        self.tiles[i]:draw()
    end 
end


function Map:new(filename)
    local o = {}
    o.tiles = {}
    o.tileGroups = {}
    -- Start at 1, 1
    local myx = 1
    local myz = 1
    local mapstring = fs.read(filename)
    for c in mapstring:gmatch('%d+') do 
        local t = Tile:new(c, myx, myz)
        table.insert(o.tiles, t)
        myx = myx + 1
        if (myx > _MAPWIDTH) then 
            myx = 1
            myz = myz + 1
        end
    end

    setmetatable(o, map_mt) 
    return o 
end 

return Map 