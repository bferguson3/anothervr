--Map.lua
local _MAPWIDTH = 20
local _MAPHEIGHT = 20

local lovr = require 'lovr'
local m = lovr.math 
local fs = lovr.filesystem 
local gfx = lovr.graphics 
local Tile = require 'Tile'
local TileGroup = require 'TileGroup'

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
        local o = TileGroup:new(groups[i], {}, {})
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
    for i = 1, #self.tileGroups do 
        for j = 1, #self.tileGroups[i] do 
            local t = self.tileGroups[i][j] 
            local orientation = m.quat(0, 0, 1, 0)
            local scale = m.vec3(1.5) 
            local position = m.vec3(t.x, -2, t.z)
            -- use 'newMat4' to save it for later 
            --t.transform = m.newMat4(position, scale, orientation)
            table.insert(tileGroups[i].transforms, m.newMat4(position, scale, orientation))
        end
    end
    -- TODO: finish this
    -- now for each tile group, make a new 'tiletransformblock' object which contains:
    local new_sblock = gfx.newShaderBlock('uniform', 
        { 
          tileLocs = { 'mat4', #tileGroups[1] }, 
          --tileTexture = { 'sampler2D', 1 } 
        },
        { usage = 'static' }) 
    new_sblock:send('tileLocs', tileGroups[1].transforms)
    -- now, we need to populate the TileGroup's texture based on its type. 
    --new_sblock:send('tileTexture', tileGroups[1].texture)
    
    -- done with tiles. force clean.
    self.tiles = nil 
end

function Map:draw()
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