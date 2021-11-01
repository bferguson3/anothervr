--Player.lua
-- Subclass of GameObject
local GameObject = require 'GameObject'

-- Create a metatable that contains an instance of the GO
--  (and anything else we may need)
local Player = GameObject:new()
Player.name = "Nanashi"
Player.scale = 2.0
local Player_mt = { __index = Player }

-- Create a draw override to prove class inheritence
--function Player:draw()
--end

-- This is necessary to return a new object with the Player class metadata:
function Player:new(x, y, z, mf, name)
	local new = GameObject:new(x, y, z, mf)

	new.name = name or "Nanashi"
	new.scale = 1.0

	setmetatable(new, Player_mt) 
	return new 
end

return Player 