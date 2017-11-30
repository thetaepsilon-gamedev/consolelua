local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname).."/"

point_tool_callbacks = dofile(modpath.."point_tool.lua")

_mod = {}
_modpath=modpath

_mod.privdata = dofile(modpath.."privs.lua")
dofile(modpath.."commands.lua")

local registry = dofile(modpath.."player_registry.lua")
reg = registry

_modpath = nil
_mod = {}
