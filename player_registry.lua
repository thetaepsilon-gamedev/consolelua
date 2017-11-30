--[[
"Player registry":
Registers hooks to construct a player's environment when they log in,
*if* they have the relevant privilege.
]]

local registry = {}
local privs = _mod.privdata.privs
local execenv = dofile(_modpath.."execenv.lua")
local wp = minetest.get_worldpath()


local setup = function(player)
	registry[player] = execenv.new(player, wp)
end
local teardown = function(player)
	registry[player] = nil
end

minetest.register_on_joinplayer(setup)
minetest.register_on_leaveplayer(teardown)

return registry
