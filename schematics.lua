local test_position = {x=5,y=10,z=5}

local node_name = minetest.get_current_modname() .. ":facedir_node"
minetest.register_node(node_name, {
	description = "facedir node",
	tiles = {
		"mtt_testnode_bg.png^mtt_y.png",
		"mtt_testnode_bg.png^mtt_-y.png",
		"mtt_testnode_bg.png^mtt_x.png",
		"mtt_testnode_bg.png^mtt_-x.png",
		"mtt_testnode_bg.png^mtt_z.png",
		"mtt_testnode_bg.png^mtt_-z.png"},
	groups = { dig_immediate=2, not_in_creative_inventory=1 },
	paramtype = "light",
	paramtype2 = "facedir",
})

-- minetest.place_schematic(pos, schematic, rotation, replacements, force_placement)
describe("minetest.place_schematic(pos, schematic, rotation, replacements, force_placement)", function()
	it("rotates the facedir of nodes correctly by the supplied angle (minetest/minetest#3093)", function()
		Given "a schematic with nodes of different facedir values"
		local schematic = {
			size = {x=24, y=1, z=1},
			yslice_prob = { {ypos=0, prob=254}, },
			data = {}
		}
		for facedir=0, 23 do
			table.insert(schematic.data, {name=node_name, prob=254, param2=facedir})
		end

		When "placing it without rotation"
		minetest.place_schematic(test_position, schematic, 0, nil, true)

		Then "don't rotate any node"
		for x = 0, 23 do
			local node = minetest.get_node_or_nil({x=test_position.x+x, y=test_position.y, z=test_position.z})
			assert.is_not.Nil(node)
			assert.equals(node.param2, x)
		end

		When "placing it with rotation"
		minetest.place_schematic(test_position, schematic, 180, nil, true)

		Then "don't skip rotation"
		for x = 0, 23 do
			local node = minetest.get_node_or_nil({x=test_position.x+23-x, y=test_position.y, z=test_position.z})
			assert.is_not.Nil(node)
			assert.is_not.equal(node.param2, x)
		end
	end)
end)
