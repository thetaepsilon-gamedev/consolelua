local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname).."/"

point_tool_callbacks = dofile(modpath.."point_tool.lua")

_mod = {}
_modpath=modpath

_mod.privdata = dofile(modpath.."privs.lua")

local registry = dofile(modpath.."player_registry.lua")
_mod.registry = registry

dofile(modpath.."commands.lua")

_modpath = nil
_mod = {}
