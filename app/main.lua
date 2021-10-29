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

local defaultVertex, defaultFragment, defaultShader
local blockShader, blockmodel
-- Currently the skybox renders at the same color as ambience.
local ambientLight = { 0.3, 0.3, 0.3, 1.0 }

-- FPS/CPU% counter variables
local fUpdateDelta = 0.0
local iTotalFrames = 0
local frameCounter = 0.0
local fRenderDelta = 0.0
-- Consts
local WHITE = { 1.0, 1.0, 1.0, 1.0 }
local FRAMERATE = 72

function lovr.load(args)

    -- set up shader
    defaultVertex = fs.read('shaders/defaultVertex.vs')
    defaultFragment = fs.read('shaders/defaultFragment.fs')
    defaultShader = gfx.newShader(defaultVertex, defaultFragment, {})
    
    -- Set default shader values
    defaultShader:send('liteColor', {1.0, 1.0, 1.0, 1.0})
    defaultShader:send('ambience', ambientLight)
    defaultShader:send('specularStrength', 0.5)
    defaultShader:send('metallic', 32.0)

    gfx.setCullingEnabled(true)
    gfx.setBlendMode(nil)
    lovr.headset.setClipDistance(0.1, 20)

    --Try out our GameObject class!
    p = Player:new(0, 0, -3, 'models/female_warrior_1.obj')
    p:init() -- <- actually loads the model to drawables array

    map1 = Map:new('maps/map1_0.csv')
    map1:init() -- < loads map and override to drawables
    -- shader block of dynamic transforms
-- MOVE ME TO MAP INIT:
    local blocktest = gfx.newShaderBlock('uniform', 
        { modelTransforms = { 'mat4', 20*20 } }, 
        { usage = 'static' })
    local transforms = {}
    for y=1,20 do 
        for x = 1,20 do 
            local position = m:vec3((x - 11)*4, -2, (y - 11)*4)
            local orientation = m:quat(0, 0, 1, 0)
            local scale = m:vec3(1) -- change to 2.0
            transforms[((y-1)*20) + x] = m:mat4(position, scale, orientation)
        end
    end
    blocktest:send('modelTransforms', transforms)
    blockShader = gfx.newShader(blocktest:getShaderCode('ModelBlock') .. [[
        out vec3 vNormal;
        vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
            vNormal = lovrNormal;
            return projection * transform * modelTransforms[lovrInstanceID] * vertex;
        }
    ]], [[
        in vec3 vNormal;
        vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
            return vec4(0.5, 1.0, 1.0, 1.0);
        }
    ]]);
    blockShader:sendBlock('ModelBlock', blocktest)
    blockmodel = gfx.newModel('models/cube.obj')
--
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
    -- skybox
    gfx.setColor(0.3, 0.3, 0.3, 1.0)
    gfx.box('fill', 0, 0, 0, 50, 50, 50, 0, 0, 1, 0)
    gfx.setColor(WHITE)

    gfx.setShader(blockShader) -- includes teal color
    blockmodel:draw(m:mat4(), 20*20) 

    -- model , normal shader
    gfx.setShader(defaultShader)
    gfx.push()
    local sx, sy, sz = 1, 1, 1
    gfx.transform(0, -2, 0, sx, sy, sz, 0, 0, 1, 0) -- "player perspective"
    for i=1,#globals.drawables do 
        globals.drawables[i]:draw() -- global class constructor draw override test go!
    end
    gfx.pop() -- return to default transform (headset@origin)
    
    -- ui, special shader
    gfx.setShader() -- Reset to default/unlit
    gfx.setColor(1, 1, 1, 1)
    --gfx.print('hello world', 0, 2, -3, .5)
    iTotalFrames = iTotalFrames + 1
    gfx.print('map1 is ' .. #map1.tiles .. 'tiles large!', 0, 2, -3, .5)
    gfx.print("size of drawables: " .. #globals.drawables, 0, 0, -3, 0.4)
    gfx.print('GPU FPS: ' .. lovr.timer.getFPS(), 0, 0.5, -3, 0.2)
end

function lovr.quit()
	-- QUITME
end
