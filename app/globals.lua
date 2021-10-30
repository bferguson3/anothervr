--globals.lua
local globals = {}
-- Store everything we are currently drawing here:
globals.drawables = {}

globals.shaders = {}
globals.shaders.default = nil 
globals.shaders.tile = nil 

return globals