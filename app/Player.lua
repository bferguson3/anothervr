--Player.lua
-- Subclass of GameObject
require 'GameObject'

-- Create a metatable that contains an instance of the GO
--  (and anything else we may need)
Player = GameObject:new()
Player.name = "Nanashi"
Player_mt = { __index = Player }

-- Create a draw override to prove class inheritence
function Player:draw()
	local scale = 2.0
	if(self.model ~= nil) then 
		self.model:draw(self.x, self.y, self.z, 
			            scale, 
			            self.r, 
			            self.ax, self.ay, self.az);
	end
end

-- This is necessary to return a new object with the Player class metadata:
function Player:new(x, y, z, mf)
	local new = GameObject:new(x, y, z, mf)
	setmetatable(new, Player_mt) 
	return new 
end

return Player 