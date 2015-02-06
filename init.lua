local modpath = minetest.get_modpath(minetest.get_current_modname())

minetest.register_node("api_test:undiggable", {
	description = "node that doesn't allow to be dug by players",
	tiles = {"default_lava.png"},
	groups = { dig_immediate=2 },
	paramtype = "light",
	can_dig = function(pos, player) return false end
})

dofile(modpath .. "/data_handling.lua")
dofile(modpath .. "/item_handling.lua")
dofile(modpath .. "/environment.lua")
