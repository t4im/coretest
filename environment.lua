local test_position = {x=51,y=1,z=50}

local node_name = minetest.get_current_modname() .. ":undiggable"
minetest.register_node(node_name, {
	description = "node that doesn't allow to be dug by players",
	tiles = {
		"cubictest_testnode_bg.png^cubictest_y.png",
		"cubictest_testnode_bg.png^cubictest_-y.png",
		"cubictest_testnode_bg.png^cubictest_x.png",
		"cubictest_testnode_bg.png^cubictest_-x.png",
		"cubictest_testnode_bg.png^cubictest_z.png",
		"cubictest_testnode_bg.png^cubictest_-z.png"},
	groups = { dig_immediate=2, not_in_creative_inventory=1 },
	paramtype = "light",
	can_dig = function(pos, player) return false end
})

-- minetest.dig_node(pos)
-- ^ Dig node with the same effects that a player would cause
--   Returns true if successful, false on failure (e.g. protected location)
describe("minetest.dig_node(pos) -- ", function()
	set_up(function()
		original_protection = minetest.is_protected
	end)

	it("Returns false on failure (e.g. protected location) (minetest/minetest#2015)", function()
		Given "an undiggable node"
		minetest.is_protected = function(pos, name) return true end
		minetest.set_node(test_position, {name = node_name })

		When "digging it"
		local dig = minetest.dig_node(test_position)

		Then "return false"
		assert.is.False(dig)
	end)

	tear_down(function()
		-- revert to former state after run
		minetest.is_protected = original_protection
	end)
end)

