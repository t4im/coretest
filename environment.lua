local test_position = {x=51,y=1,z=50}
local original_protection = minetest.is_protected

-- minetest.dig_node(pos)
-- ^ Dig node with the same effects that a player would cause
--   Returns true if successful, false on failure (e.g. protected location)
describe("minetest.dig_node(pos) -- minetest/minetest#2015", function()

	given("an undiggable node", function()
		minetest.is_protected = function(pos, name) return true end
		minetest.set_node(test_position, {name="api_test:undiggable"})
	end)

	it("returns false when digging", function(assert)
		assert.is.False(minetest.dig_node(test_position))
	end)

	-- revert to former state after run
	minetest.is_protected = original_protection
end)

