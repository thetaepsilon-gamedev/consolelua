local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname).."/"

point_tool_callbacks = dofile(modpath.."point_tool.lua")

_modpath=modpath
local execenv = dofile(modpath.."execenv.lua")
eenv = execenv

dofile(modpath.."commands.lua")


_modpath = nil
