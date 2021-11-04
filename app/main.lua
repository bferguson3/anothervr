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

    local tileTransformBlock_tmp = gfx.newShaderBlock('uniform', 
        { tileLocs = { 'mat4', 20*20 } }, 
        { usage = 'dynamic' }) 
    local ts = gfx.newShader(
        tileTransformBlock_tmp:getShaderCode('TileTransforms') .. 
        fs.read('shaders/tileVertex.vs'), 
        fs.read('shaders/tileFragment.fs')
    );
    globals.shaders.tile = ts;
end

local LOCALMODE = false

function lovr.load(args)
    if #args > 0 then 
        if args[1] == 'mirror' then 
            LOCALMODE = true
        end 
    end
    print (LOCALMODE)
    
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
    gfx.print("size of drawables: " .. #globals.drawables, 0, 0, -3, 0.4)
    gfx.print('GPU FPS: ' .. lovr.timer.getFPS(), 0, 0.5, -3, 0.2)

    iTotalFrames = iTotalFrames + 1
end

function lovr.quit()
	-- QUITME
end
