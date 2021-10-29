-- Another Ether

-- Every file that needs access to the global variables file
--  simply needs to require 'globals'. the 'drawables' array
--  is included here.
local globals = require 'globals'

local lovr = require 'lovr' 

-- My personal library:
local m = lovr.filesystem.load('lib.lua'); m()

-- Abbreviations
local fs = lovr.filesystem
local gfx = lovr.graphics

-- Include the class files
--local go = require 'GameObject'
local Player = require 'Player'

local defaultVertex, defaultFragment, defaultShader
local p 

-- FPS/CPU% counter variables
local fRenderDelta = 0.0
local iTotalFrames = 0
local frameCounter = 0.0
local updateCpuCtr = false 
local fpsrough = 0.0
local FRAMERATE = 72

-- Currently the skybox renders at the same color as ambience.
local ambientLight = { 0.3, 0.3, 0.3, 1.0 }

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

    --Try out our GameObject class!
    p = Player:new(0, 0, -3, 'models/female_warrior_1.obj')
    p:init() -- <- actually loads the model to drawables array
end


function lovr.update(dT)
    -- framerate nonsense
    frameCounter = frameCounter + 1
    if(frameCounter > FRAMERATE) then 
        updateCpuCtr = true 
        frameCounter = 0
        fRenderDelta = lovr.timer.getTime()
    end

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
    gfx.setColor(1.0, 1.0, 1.0, 1.0)
	
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
    gfx.print('hello world', 0, 2, -3, .5)
    gfx.print("size of drawables: " .. #globals.drawables, 0, 0, -3, 0.4)
    iTotalFrames = iTotalFrames + 1
    gfx.print('GPU FPS: ' .. lovr.timer.getFPS(), 0, 0.5, -3, 0.2)
    gfx.print('CPU %: ' .. fpsrough, 0, 1, -3, 0.2)
    if(updateCpuCtr) then 
        updateCpuCtr = false
        fpsrough = round((lovr.timer.getTime() - fRenderDelta) * 100, 2)
    end
end

function lovr.quit()
	-- QUITME
end
