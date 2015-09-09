local dummy = cubictest.dummies.nodes
local test_position = {x=5,y=10,z=5}

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
			table.insert(schematic.data, {name=dummy.facedirected.name, prob=254, param2=facedir})
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

	it("always calls destructors of nodes it replaces (minetest/minetest#3160)", function()
		Given "a node with destructors"
		local dummy = dummy.destructable
		local nodedef = dummy.def
		local node = { name = dummy.name }
		minetest.set_node(test_position, node)
		stub(nodedef, "on_destruct")
		stub(nodedef, "after_destruct")

		And "a schematic with a node to replace it"
		local schematic = {
			size = {x=1, y=1, z=1},
			yslice_prob = { {ypos=0, prob=254}, },
			data = {{name="default:stone", prob=254, param2=0}}
		}

		When "replacing it with the schematic"
		minetest.place_schematic(test_position, schematic, 0, nil, true)

		Then "always call its destructor on_destruct"
		assert.stub(nodedef.on_destruct).was_called()
		assert.stub(nodedef.on_destruct).was_called_with(test_position)
		nodedef.on_destruct:revert()

		And "always call its destructor after_destruct"
		assert.stub(nodedef.after_destruct).was_called()
		assert.stub(nodedef.after_destruct).was_called_with(test_position, node)
		nodedef.after_destruct:revert()
	end)
end)
