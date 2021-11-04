--Map.lua
local _MAPWIDTH = 20
local _MAPHEIGHT = 20

local lovr = require 'lovr'
local m = lovr.math 
local fs = lovr.filesystem 
local gfx = lovr.graphics 
local Tile = require 'Tile'
local TileGroup = require 'TileGroup'
local globals = require 'globals'

local Map = {}
Map.tiles = {}
Map.tileGroups = {
    [1] = { type = 0, tiles = {} }
}
--for i=1,(_MAPWIDTH * _MAPHEIGHT) do
--    table.insert(Map.tiles, Tile:new())
--end
local map_mt = { __index = Map }

function Map:populate_tile_transforms()
    for i = 1, #self.tileGroups do 
        for j = 1, #self.tileGroups[i] do 
            local t = self.tileGroups[i][j] 
            local orientation = m.quat(0, 0, 1, 0)
            local scale = m.vec3(1.5) 
            local position = m.vec3(t.x * 3, -2, t.z * 3)
            -- use 'newMat4' to save it for later 
            --t.transform = m.newMat4(position, scale, orientation)
            table.insert(self.tileGroups[i].transforms, m.newMat4(position, scale, orientation))
        end
    end
end

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
    -- populate transforms arrays
    self:populate_tile_transforms()
    -- remaining: create my own shader
    self.tileTransformBlock = gfx.newShaderBlock('uniform', 
        { tileLocs = { 'mat4', 20*20 } }, --#self.tileGroups[1].transforms } },
        { usage = 'dynamic' }) 
    self.myShader = gfx.newShader(
        self.tileTransformBlock:getShaderCode('TileTransforms') .. 
        fs.read('shaders/tileVertex.vs'), 
        fs.read('shaders/tileFragment.fs'));
    self.blockmodel = gfx.newModel('models/block_02.obj')
    --self.myShader:send('tileTexture', gfx.newTexture('models/tex_02.png'))
        
    -- done with tiles. force clean.
    self.tiles = nil 

    table.insert(globals.drawables, self)
end

function Map:draw()
    gfx.setShader(self.myShader)
    for i=1,#self.tileGroups do 
        self.myShader:send('tileTexture', self.tileGroups[i].texture)
        self.tileTransformBlock:send('tileLocs', self.tileGroups[i].transforms)
        self.myShader:sendBlock('TileTransforms', self.tileTransformBlock)
        self.blockmodel:draw(m.mat4(), #self.tileGroups[i].transforms)
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