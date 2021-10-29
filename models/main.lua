function lovr.load()
	mod = lovr.graphics.newModel('female_warrior_1.obj')
end 

function lovr.draw()
	mod:draw(0, 0, -2, 1)
end