--[[
Create the user reference wrappers for a player when they log in,
then destroy them again when they log out.
The user refs are used by subsequent calls to the chat commands,
to refer to the player's environment.
]]

local userrefs = {}

local setup = function(player)
	if minetest.check_player_privs(player, privs) then
		userrefs[player] = !?
	end
end
local teardown = function(player)
	userrefs[player] = nil
end

minetest.register_on_joinplayer(setup)
minetest.register_on_leaveplayer(teardown)
