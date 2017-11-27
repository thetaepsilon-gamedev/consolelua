minetest.register_craftitem("consolelua:point_tool", {
	description = "Lua callback point tool",
	inventory_image = "consolelua_pointer_tool.png",

	-- all are "itemstack", "placer/user", "pointed_thing"
	-- though secondary use is for pointed_thing = {type="nothing"}
	on_use = nil,
	on_place = nil,
	on_secondary_use = nil,
})
