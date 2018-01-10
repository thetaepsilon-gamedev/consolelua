--[[
The user registry is simply an association of a user to their command environment.
when a user first appears, they can be registered to have their environment created.
note that for players, this doesn't happen immediately but either on login,
or first use after gaining the correct privileges to use the /lua command.
]]

local registry = {}
local util = {}
local privs = _mod.privdata.privs
local execenv = dofile(_modpath.."execenv.lua")
local wp = minetest.get_worldpath()


local setup = function(player)
	if minetest.check_player_privs(player, privs) then
		registry[player] = execenv.new(player, wp)
	end
end
local teardown = function(player)
	registry[player] = nil
end

minetest.register_on_joinplayer(setup)
minetest.register_on_leaveplayer(teardown)



-- if the player was granted these privileges sometime after join,
-- their player environment may be nil.
-- this creates it if it doesn't exist.
-- intended to be called only when privilege checking has taken place
-- (e.g. from a command callback).
local get = function(player)
	local reg = registry[player]
	if not reg then
		reg = execenv.new(player, wp)
		registry[player] = reg
	end
	return reg
end
util.get = get

local remove = function(player)
	if not registry[player] then
		local desc = tostring(player.name) .. " (" .. tostring(player) .. ")"
		minetest.log("warning", "duplicate player env removal: " .. desc)
	else
		registry[player] = nil
	end
end
util.remove = remove



return registry, util
