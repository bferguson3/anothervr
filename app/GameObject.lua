--gameObject.lua
local globals = require 'globals' -- so we have 'drawables'
local lovr = require 'lovr'
local gfx = lovr.graphics 

-- slightly different constructor than Model:draw()
local GameObject = { 
	x = 0, 
	y = 0, 
	z = 0, 
	modelfile = nil,
	r = 0,
	ax = 0,
	ay = 1, 
	az = 0,
	shader = globals.shaders.default,
	scale = 1.0
}
local GameObject_mt = { __index = GameObject } -- metatable is important!!

function GameObject:new(x, y, z, modelfile, r, ax, ay, az)
	-- here we go through the ordinary constructor code
	local new_go = {}
	
	new_go.x = x or 0
	new_go.y = y or 0
	new_go.z = z or 0 
	new_go.ax = ax or 0
	new_go.ay = ay or 1
	new_go.az = az or 0 
	new_go.r = r or 0 
	new_go.shader = globals.shaders.default
	new_go.scale = 1.0
	
	new_go.modelfile = modelfile or nil 
	-- then set our metatable
	setmetatable(new_go, GameObject_mt)
	return new_go -- and uniquely return the new object table
end

-- Call me when initializing this GO for drawing
function GameObject:init()
	if(self.modelfile) then 
		self.model = lovr.graphics.newModel(self.modelfile)
		table.insert(globals.drawables, self)
	end
end

-- Should need no arguments
function GameObject:draw()
	if(self.shader ~= lovr.graphics.getShader()) then 
		gfx.setShader(self.shader)
	end
	if(self.model ~= nil) then 
		self.model:draw(self.x, self.y, self.z, 
			            self.scale, 
			            self.r, 
			            self.ax, self.ay, self.az);
	end
end

return GameObject 
