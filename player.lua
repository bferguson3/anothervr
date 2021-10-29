--player.lua

go = require 'gameObject'

player = go:new{
	x=0, 
	y=0, 
	z=0, 
	model='models/female_warrior_1.obj'
}

return player;