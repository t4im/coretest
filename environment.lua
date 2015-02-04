local test_position = {x=51,y=1,z=50}
local original_protection = minetest.is_protected

-- minetest.dig_node(pos)
-- ^ Dig node with the same effects that a player would cause
--   Returns true if successful, false on failure (e.g. protected location)
mtt.test("minetest.dig_node(pos) -- minetest/minetest#2015", function(assert)
	minetest.is_protected = function(pos, name) return true end 

	minetest.set_node(test_position, {name="api_test:undiggable"})
	assert.is.False(minetest.dig_node(test_position))

	minetest.is_protected = original_protection
end)

