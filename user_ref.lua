--[[
user_ref.lua
When the callbacks for chat commands are invoked,
the passed player ref can be nil if it was the server console who ran the command.
therefore, we need to wrap up and isolate just what we need of a "player" for the purpose of the inner code.
This basically just amounts to a chat send function (or console print),
and optionally the actual player ref for the "me" variable (see rcloader.lua).
]]

local console = print
local print_server = function(self, msg)
	print(msg)
end

local print_player = function(self, msg)
	local name = self.name
	minetest.chat_send_player(name, msg)
end

--[[
Returned interface:
	i:sendtext(msg)
		sends raw, unformatted text to this user.
	i.name, i.ref (optional)
		respectively, name and player ref objects for this player.
		may be nil.
]]
local mk_user_ref = function(player)
	local result = {}

	if player then
		result.name = player:get_player_name()
		result.ref = player
		result.sendtext = print_player
	else
		result.sendtext = print_server
	end

	return result
end

return mk_user_ref
