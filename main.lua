
-- LOVR 0.15 boiler plate
-- Written by Ben Ferguson, 2021
-- CC0

fRenderDelta = 0.0

ambientLight = { 0.3, 0.3, 0.3, 1.0 }

m = lovr.filesystem.load('lib.lua'); m()

fs = lovr.filesystem
gfx = lovr.graphics


function lovr.load(args)
    --anotherdebug:init()

    -- set up shader
    defaultVertex = fs.read('shaders/defaultVertex.vs')
    defaultFragment = fs.read('shaders/defaultFragment.fs')

    defaultShader = gfx.newShader(defaultVertex, defaultFragment, {})
    
    -- Set default shader values
    defaultShader:send('liteColor', {1.0, 1.0, 1.0, 1.0})
    defaultShader:send('ambience', ambientLight)
    defaultShader:send('specularStrength', 0.5)
    defaultShader:send('metallic', 32.0)

    mod = lovr.graphics.newModel('models/female_warrior_1.obj')
    
end

function lovr.update(dT)
    -- Light position updates
    defaultShader:send('lightPos', { 0.0, 2.0, -3.0 })

    -- Adjust head position (for specular)
    if lovr.headset then 
        hx, hy, hz = lovr.headset.getPosition()
        defaultShader:send('viewPos', { hx, hy, hz } )
    end

    fRenderDelta = math.floor(dT * 1000)
end

function lovr.draw()
	-- skybox
	lovr.graphics.setColor(0.3, 0.3, 0.3, 1.0)
	lovr.graphics.box('fill', 0, 0, 0, 50, 50, 50, 0, 0, 1, 0)
	lovr.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	
	-- model , normal shader
	lovr.graphics.setShader(defaultShader)
    mod:draw(0, 0, -2, 1)

    -- ui, special shader
    lovr.graphics.setShader() -- Reset to default/unlit
    lovr.graphics.setColor(1, 1, 1, 1)
    lovr.graphics.print('hello world', 0, 2, -3, .5)
    lovr.graphics.print('delta ' .. fRenderDelta, 0, 1, -3, 0.5)
end

function lovr.quit()
	-- QUITME
end
