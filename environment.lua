local test_position = {x=51,y=1,z=50}

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
		minetest.set_node(test_position, {name = cubictest.dummies.nodes.undiggable.name })

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