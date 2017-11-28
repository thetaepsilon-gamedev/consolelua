local i = {}

local mk_preserve_newlines = function(f)
	return function()
		-- file:lines() returns lines with newline chars stripped.
		-- this clashes with the semantics of comments;
		-- re-add the newline char if the iterator didn't indicate termination.
		local v = f()
		return v and (v.."\n") or nil
	end
end
-- loads a file inside an environment but doesn't call it.
-- dofile is a bit annoying here as it does not automatically inherit setfenv.
-- instead, we implement it ourself in a deferred manner.
-- load each line from the file, setfenv on the resulting chunk, and return that.
-- the caller then has to actually invoke it.
-- label is optional but helps with diagnostics.
local envload = function(env, filename, label)
	local file, err = io.open(filename, "r")
	if file == nil then return nil, "io open fail: "..err end
	local result, err = load(mk_preserve_newlines(file:lines()), label)
	if result == nil then
		err = "load fail: "..err
	else
		setfenv(result, env)
	end
	return result, err
end
i.load = envload

-- calls the result of loadstring inside a specified environment.
local enveval = function(env, st)
	local chunk, throw = loadstring(st)
	if not chunk then error("enveval loadstring error: "..throw) end
	setfenv(chunk, env)
	return chunk()
end
i.eval = enveval

return i
