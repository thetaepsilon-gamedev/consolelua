-- prefix during development to avoid problems with luacmd.
local devp = "xcmd_"
local cmd = devp.."lua"
local priv = devp.."lua"
local privs = { [priv] = true }

local stub = function(name, data)
	minetest.chat_send_player(name, "not implemented! "..data)
end



minetest.register_privilege(priv, {
	description = "grants the player the ability to execute arbitary lua code (DANGEROUS)",
	give_to_singleplayer = false
})



minetest.register_chatcommand(cmd, {
	params = "<lua fragment>",
	description = "evaluates a lua string in your local environment.",
	privs = privs,
	func = stub
})

minetest.register_chatcommand(cmd.."_reload", {
	params = "",
	description = "reloads your lua environment from the rc files",
	privs = privs,
	func = stub
})

minetest.register_chatcommand(cmd.."_reset", {
	params = "",
	description = "re-initialises your lua environment and re-loads the rc files",
	privs = privs,
	func = stub
})

