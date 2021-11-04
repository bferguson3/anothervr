-- Another Ether

-- Every file that needs access to the global variables file
--  simply needs to require 'globals'. the 'drawables' array
--  is included here.
local globals = require 'globals'

local lovr = require 'lovr' 
-- Abbreviations
local fs = lovr.filesystem
local gfx = lovr.graphics
local m = lovr.math 
-- My personal library:
local _m = lovr.filesystem.load('lib.lua'); _m()

-- Include the class files
--local go = require 'GameObject'
local Player = require 'Player'
local p 

local Map = require 'Map'
local map1 

-- Consts
local WHITE = { 1.0, 1.0, 1.0, 1.0 }
local DARKGREY = {0.33, 0.33, 0.33, 1.0}
local FRAMERATE = 72

local defaultVertex, defaultFragment, defaultShader
local tileShader --, blockmodel
local floor_transform_block, wall_transform_block, ceiling_transform_block
--local tile_floor_loc, tile_wall_loc, tile_ceiling_loc
-- Currently the skybox renders at the same color as ambience.
local ambientLight = DARKGREY 

-- FPS/CPU% counter variables
local fUpdateDelta = 0.0
local iTotalFrames = 0
local frameCounter = 0.0
local fRenderDelta = 0.0


local function initialize_shaders()
    -- set up shaders
    defaultVertex = fs.read('shaders/defaultVertex.vs')
    defaultFragment = fs.read('shaders/defaultFragment.fs')
    defaultShader = gfx.newShader(defaultVertex, defaultFragment, {})
    globals.shaders.default = defaultShader 
    -- Set default shader values
    defaultShader:send('liteColor', {1.0, 1.0, 1.0, 1.0})
    defaultShader:send('ambience', ambientLight)
    defaultShader:send('specularStrength', 0.5)
    defaultShader:send('metallic', 32.0)
    
-- START DELETEME CODE ----
    -- Make a list of all tile transforms:
    --tile_floor_loc = {}
    --tile_wall_loc = {}
    --tile_ceiling_loc = {}
    --for y=1,20 do 
    --    for x = 1,20 do 
    --        local position = m.vec3((x - 11)*3, 2, (y - 11)*3)
    --        local pos2 = m.vec3((x - 11)*3, -2, (y - 11)*3)
    --        local pos3 = m.vec3((x - 11)*3, 6, (y - 11)*3)
    --        local orientation = m.quat(0, 0, 1, 0)
    --        local scale = m.vec3(1.5) 
    --         -- note 'newMat4' instead of 'mat4' to store it for later.
    --         tile_floor_loc[((y-1)*20) + x] = m.newMat4(pos2, scale, orientation)
    --         tile_wall_loc[((y-1)*20) + x] = m.newMat4(position, scale, orientation)
    --         tile_ceiling_loc[((y-1)*20) + x] = m.newMat4(pos3, scale, orientation)
    --     end
    -- end
    
    -- -- Make a shader block for the transforms and push the array:
     floor_transform_block = gfx.newShaderBlock('uniform', 
         { tileLocs = { 'mat4', 20*20 } }, 
         { usage = 'static' })
     --floor_transform_block:send('tileLocs', tile_floor_loc)
    
    -- wall_transform_block = gfx.newShaderBlock('uniform', 
    --     { tileLocs = { 'mat4', 20*20 } }, 
    --     { usage = 'static' })
    -- wall_transform_block:send('tileLocs', tile_wall_loc)
    
    -- ceiling_transform_block = gfx.newShaderBlock('uniform', 
    --     { tileLocs = { 'mat4', 20*20 } }, 
    --     { usage = 'static' })
    -- ceiling_transform_block:send('tileLocs', tile_ceiling_loc)

-- END DELETEME CODE 


    -- Make a new shader with a defined block space, and push the block to shader
    tileShader = gfx.newShader(
        floor_transform_block:getShaderCode('TileTransforms') .. 
        fs.read('shaders/tileVertex.vs'), 
        fs.read('shaders/tileFragment.fs'));
    globals.shaders.tile = tileShader 
--
end

function lovr.load(args)

    gfx.setDefaultFilter('nearest', gfx.getLimits().anisotropy)
    initialize_shaders()

    gfx.setCullingEnabled(true)
    gfx.setBlendMode(nil)
    lovr.headset.setClipDistance(0.1, 50)

    --Try out our GameObject class!
    p = Player:new(0, 0, -3, 'models/female_warrior_1.obj')
    p:init() -- <- actually loads the model to drawables array

    map1 = Map:new('maps/map1_0.csv')
    map1:init() -- < loads map and override to drawables

    -- load the cube model 
    --blockmodel = gfx.newModel('models/block_02.obj')
    
end

function lovr.update(dT)
    -- framerate nonsense
    frameCounter = frameCounter + 1
    fUpdateDelta = lovr.timer.getTime()
    
    -- Light position updates
    defaultShader:send('lightPos', { 0.0, 2.0, -3.0 })

    -- Adjust head position (for specular)
    if lovr.headset then 
        local hx, hy, hz = lovr.headset.getPosition()
        defaultShader:send('viewPos', { hx, hy, hz } )
    end
    --fs.append('log.txt', 'T[' .. lovr.timer.getTime() .. ']: ' .. 'HEE' .. '\n')
end

function lovr.draw()
    -- goto NO_SKYBOX 
    -- skybox
    gfx.setColor(DARKGREY)
    gfx.box('fill', 0, 0, 0, 50, 50, 50, 0, 0, 1, 0)
    gfx.setColor(WHITE)
    ::NO_SKYBOX::
    
    gfx.push()
    for i=1,#globals.drawables do 
        globals.drawables[i]:draw() -- global class constructor draw override
    end
    gfx.pop() -- return to default transform (headset@origin)
    
    -- ui needs special default/unlist shader
    gfx.setShader() 
    gfx.setColor(WHITE)
    --gfx.print('hello world', 0, 2, -3, .5)
    gfx.print('map1 is ' .. #map1.tiles .. 'tiles large!', 0, 2, -3, .5)
    gfx.print("size of drawables: " .. #globals.drawables, 0, 0, -3, 0.4)
    gfx.print('GPU FPS: ' .. lovr.timer.getFPS(), 0, 0.5, -3, 0.2)

    iTotalFrames = iTotalFrames + 1
end

function lovr.quit()
	-- QUITME
end
