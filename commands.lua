local privs = _mod.privdata.privs
local devp = _mod.privdata.devp
local cmd = devp.."lua"
local reg = _mod.registry



local mk_handle_wrapper = function(f)
	return function(name, ...)
		local player = minetest.get_player_by_name(name)
		return f(player, ...)
	end
end

local reset = function(player, data)
	reg[player]:reset()
end
local reload = function(player, data)
	reg[player]:reload()
end
local exec = function(player, data)
	reg[player]:exec(data)
end



minetest.register_chatcommand(cmd, {
	params = "<lua fragment>",
	description = "evaluates a lua string in your local environment.",
	privs = privs,
	func = mk_handle_wrapper(exec),
})

minetest.register_chatcommand(cmd.."_reload", {
	params = "",
	description = "reloads your lua environment from the rc files",
	privs = privs,
	func = mk_handle_wrapper(reload),
})

minetest.register_chatcommand(cmd.."_reset", {
	params = "",
	description = "re-initialises your lua environment and re-loads the rc files",
	privs = privs,
	func = mk_handle_wrapper(reset),
})

