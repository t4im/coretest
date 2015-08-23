local test_position = {x=51,y=1,z=50}
local original_protection = minetest.is_protected

minetest.register_node("api_test:undiggable", {
	description = "node that doesn't allow to be dug by players",
	tiles = {"default_lava.png"},
	groups = { dig_immediate=2 },
	paramtype = "light",
	can_dig = function(pos, player) return false end
})

-- minetest.dig_node(pos)
-- ^ Dig node with the same effects that a player would cause
--   Returns true if successful, false on failure (e.g. protected location)
describe("minetest.dig_node(pos) -- ", function()
	it("Returns false on failure (e.g. protected location) (minetest/minetest#2015)", function()
		Given "an undiggable node"
		minetest.is_protected = function(pos, name) return true end
		minetest.set_node(test_position, {name="api_test:undiggable"})

		When "digging it"
		local dig = minetest.dig_node(test_position)

		Then "return false"
		assert.is.False(dig)
	end)

	after(function()
		-- revert to former state after run
		minetest.is_protected = original_protection
	end)
end)

