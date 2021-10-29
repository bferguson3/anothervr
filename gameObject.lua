--gameObject.lua

gameObject = {}

function gameObject:new(pos, model)
	pos = pos or { x = 0, y = 0, z = 0 }
	model = model or nil 

	gameObject.x = pos.x
	gameObject.y = pos.y 
	gameObject.z = pos.z
	gameObject.modelfile = model --lovr.graphics.newModel(model)
end

function gameObject:init()
	gameObject.model = lovr.graphics.newModel(self.modelfile)
end

function gameObject:draw()
	if(self.model) then 
		self.model:draw(self.x, self.y, self.z)
	end
end

return gameObject 