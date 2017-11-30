-- main execution environment for player commands.
-- supports "execute this statement", "reload rc", and "reset" operations.
-- when initially constructed the reset behaviour is triggered.

local modpath = _modpath
local rcloader = dofile(modpath.."rcloader.lua")
local eval = rcloader.eval
local i = {}

local tableutils = mtrequire("com.github.thetaepsilon.minetest.libmthelpers.tableutils")
local prettyprint = mtrequire("com.github.thetaepsilon.minetest.libmthelpers.prettyprint")



-- the "chat" object used below to send feedback to the player.
local send = minetest.chat_send_player
local err_throw = function(self, msg) send(self.name, "[lua exception] "..msg) end
local err_syntax = function(self, msg) send(self.name, "[lua syntax error] "..msg) end
local send_result = function(self, msg) send(self.name, "[lua result] "..msg) end
local mk_chat = function(player)
	local name = player:get_player_name()
	local self = {
		name = name,
		err_throw = err_throw,
		err_syntax = err_syntax,
		send_result = send_result,
	}
	return self
end



local reload = function(self)
	local ok, err, message, offender = rcloader.loadrc(self.player, self.env, self.worldpath)
	if not ok then
		local chat = self.chat
		local failmsg = "reload failed while loading "..offender..": "..err..": "..message
		local abortmsg = "environment load has been aborted due to previous errors."
		local msgs = { failmsg, abortmsg }
		for _, msg in ipairs(msgs) do chat:send("[consolelua warning] "..msg) end
	end
	return ok
end

-- capture of the global namespace at load time.
local extenv = _G
-- reset the environment to everything globally visible then re-load rc files.
local reset = function(self)
	self.env = tableutils.shallowcopy(extenv)
	return reload(self)
end



local vfmt = prettyprint.vfmt
local vfmt_if_nonempty = function(...)
	if select("#", ...) > 0 then return vfmt(...) end
end
-- the compiled statement may throw due to bad indexes, incompatible operations etc.
-- in order to preserve the number of varargs potentially returned from an eval'd chunk,
-- we have to try to format the results inside pcall.
local vfmt_result = function(env, f) return vfmt_if_nonempty(f()) end
local exec = function(self, st)
	local chat = self.chat
	local success = true

	local chunk, err, message = eval(self.env, st)
	chunk, err, message = eval(self.env, st)
	if not chunk then
		chat:err_syntax(message)
		success = false
	else
		local result
		success, result = pcall(vfmt_result, self.env, chunk)
		if not success then
			chat:err_throw(result)
		else
			if result then chat:send_result(result) end
		end
	end

	return success
end



local construct = function(player, worldpath)
	local self = {}
	self.player = player
	self.worldpath = worldpath
	self.chat = mk_chat(player)
	reset(self)

	self.exec = exec
	self.reset = reset
	self.reload = reload

	return self
end
i.new = construct



return i
