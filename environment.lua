local test_position = {x=51,y=1,z=50}

-- minetest.dig_node(pos)
-- ^ Dig node with the same effects that a player would cause
--   Returns true if successful, false on failure (e.g. protected location)
describe("minetest.dig_node(pos)", function()
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

describe("core.string_to_pos(string)", function()
	it("parses correctly formed position strings", function()
		for pos_string, expected in pairs({
			["10.0, 5, -2"] = {x=10.0, y=5, z=-2},
			["( 10.0, 5, -2)"] = {x=10.0, y=5, z=-2}
		}) do
			local pos = core.string_to_pos(pos_string)
			assert.are_same(expected, pos)
		end
	end)
	it("rejects malformed position strings", function()
		for _, pos_string in pairs({
			"asd, 5, -2)",
			"(,,)",
			"( 10.0, 5, -2) cobble cobble cobble!",
		}) do
			local pos = core.string_to_pos(pos_string)
			assert.is_nil(pos)
		end
	end)
end)

if core.string_to_area then
	describe("core.string_to_area(string)", function()
		it("parses correctly formed area strings", function()
			local p1, p2 = core.string_to_area("(10.0, 5, -2) (  30.2,   4, -12.53)")
			assert.are_same(p1, {x=10.0, y=5, z=-2})
			assert.are_same(p2, {x=30.2, y=4, z=-12.53})
		end)
		it("rejects malformed area strings", function()
			for _, area_string in pairs({
				"(10.0, 5, -2  30.2,   4, -12.53",
				"(10.0, 5,) -2  fgdf2,   4, -12.53",
				"(,,) (,,)",
			}) do
				local p1, p2 = core.string_to_area(area_string)
				assert.is_nil(p1)
				assert.is_nil(p2)
			end
		end)
	end)
end
